import gleam/list
import gleam/option.{None, Some}
import monadic_parser/char
import monadic_parser/parser.{parse}

pub fn item_test() {
  let p = parser.item()
  assert parse(p, "") == None
  assert parse(p, "abc") == Some(#(char.new("a"), "bc"))
}

pub fn map_test() {
  let p = parser.item() |> parser.map(char.uppercase, _)
  assert parse(p, "abc") == Some(#(char.new("A"), "bc"))
  assert parse(p, "") == None
}

pub fn pure_test() {
  let p = parser.pure(1)
  assert parse(p, "abc") == Some(#(1, "abc"))
}

pub fn apply_test() {
  let three = {
    let g = fn(x) { fn(_) { fn(z) { #(x, z) } } }
    parser.pure(g)
    |> parser.apply(parser.item())
    |> parser.apply(parser.item())
    |> parser.apply(parser.item())
  }
  assert parse(three, "abcdef")
    == Some(#(#(char.new("a"), char.new("c")), "def"))
  assert parse(three, "ab") == None
}

pub fn bind_test() {
  let three = {
    use x <- parser.bind(parser.item())
    use _ <- parser.bind(parser.item())
    use z <- parser.bind(parser.item())
    parser.pure(#(x, z))
  }
  assert parse(three, "abcdef")
    == Some(#(#(char.new("a"), char.new("c")), "def"))
  assert parse(three, "ab") == None
}

pub fn empty_test() {
  let p = parser.empty()
  assert parse(p, "abc") == None
}

pub fn alt_test() {
  let p = parser.alt(_, parser.pure(char.new("d")))

  assert parse(parser.item() |> p, "abc") == Some(#(char.new("a"), "bc"))
  assert parse(parser.empty() |> p, "abc") == Some(#(char.new("d"), "abc"))
}

pub fn sat_test() {
  let a = parser.digit()
  assert parse(a, "123abc") == Some(#(char.new("1"), "23abc"))
  assert parse(a, "abc") == None
  let b = parser.lower()
  assert parse(b, "abc") == Some(#(char.new("a"), "bc"))
  assert parse(b, "ABC") == None
  let c = parser.upper()
  assert parse(c, "ABC") == Some(#(char.new("A"), "BC"))
  assert parse(c, "abc") == None
  let d = parser.letter()
  assert parse(d, "abc") == Some(#(char.new("a"), "bc"))
  assert parse(d, "ABC") == Some(#(char.new("A"), "BC"))
  assert parse(d, "123") == None
  let e = parser.alpha_num()
  assert parse(e, "abc") == Some(#(char.new("a"), "bc"))
  assert parse(e, "ABC") == Some(#(char.new("A"), "BC"))
  assert parse(e, "123") == Some(#(char.new("1"), "23"))
  assert parse(e, "!@#") == None
}

pub fn char_test() {
  let p = parser.char(char.new("a"))
  assert parse(p, "abc") == Some(#(char.new("a"), "bc"))
}

pub fn string_test() {
  let p = parser.string("abc")
  assert parse(p, "abcdef") == Some(#("abc", "def"))
  assert parse(p, "ab1234") == None
  assert parse(p, "") == None
  let q = parser.string("")
  assert parse(q, "abc") == Some(#("", "abc"))
  assert parse(q, "") == Some(#("", ""))
}

pub fn many_some_test() {
  let a = parser.ident()
  assert parse(a, "abc def") == Some(#("abc", " def"))
  let b = parser.nat()
  assert parse(b, "123 abc") == Some(#(123, " abc"))
  let c = parser.many_space()
  assert parse(c, "   abc") == Some(#("   ", "abc"))
}

pub fn nth_of_test() {
  let p = {
    use x <- parser.bind(parser.nth_of(3, parser.digit()))
    parser.pure(x |> char.join)
  }
  assert parse(p, "1234abc") == Some(#("123", "4abc"))
  assert parse(p, "123abc") == Some(#("123", "abc"))
  assert parse(p, "12abc") == None
}

pub fn min_of_test() {
  let p = {
    use x <- parser.bind(parser.min_of(3, parser.digit()))
    parser.pure(x |> char.join)
  }
  assert parse(p, "1234abc") == Some(#("1234", "abc"))
  assert parse(p, "123abc") == Some(#("123", "abc"))
  assert parse(p, "12abc") == None
  assert parse(p, "1abc") == None
}

pub fn max_of_test() {
  let p = {
    use x <- parser.bind(parser.max_of(3, parser.digit()))
    parser.pure(x |> char.join)
  }
  assert parse(p, "1234abc") == Some(#("123", "4abc"))
  assert parse(p, "12abc") == Some(#("12", "abc"))
  assert parse(p, "1abc") == Some(#("1", "abc"))
  assert parse(p, "abc") == Some(#("", "abc"))
}

pub fn just_nth_of_test() {
  let p = {
    use x <- parser.bind(parser.just_nth_of(3, parser.digit()))
    parser.pure(x |> char.join)
  }
  assert parse(p, "1234abc") == None
  assert parse(p, "123abc") == Some(#("123", "abc"))
  assert parse(p, "12") == None
  assert parse(p, "1") == None
  assert parse(p, "") == None
}

pub fn range_of_test() {
  let p = {
    use x <- parser.bind(parser.range_of(2, 4, parser.digit()))
    parser.pure(x |> char.join)
  }
  assert parse(p, "12345abc") == Some(#("1234", "5abc"))
  assert parse(p, "12abc") == Some(#("12", "abc"))
  assert parse(p, "1abc") == None
  assert parse(p, "abc") == None
}

pub fn int_test() {
  let p = parser.int()
  assert parse(p, "123 abc") == Some(#(123, " abc"))
  assert parse(p, "-123 abc") == Some(#(-123, " abc"))
  assert parse(p, "abc") == None
  assert parse(p, "") == None
}

pub fn identifier_test() {
  let p = parser.identifier()
  assert parse(p, " abc   def") == Some(#("abc", "def"))
  assert parse(p, "abc123   def") == Some(#("abc123", "def"))
  assert parse(p, "") == None
}

pub fn nats_test() {
  let nats = {
    use _ <- parser.bind(parser.symbol("["))
    use n <- parser.bind(parser.natural())
    use ns <- parser.bind(
      parser.many({
        use _ <- parser.bind(parser.symbol(","))
        parser.natural()
      }),
    )
    use _ <- parser.bind(parser.symbol("]"))
    parser.pure([n] |> list.append(ns))
  }
  assert parse(nats, " [1, 2, 3] ") == Some(#([1, 2, 3], ""))
  assert parse(nats, "[1,2,]") == None
}
