import gleam/option.{None, Some}
import gleam/regexp.{Match}
import monadic_parser/parser.{parse}
import monadic_parser/regex

pub fn regex_test() {
  let assert Ok(re) = regexp.from_string("abc")
  let p = regex.rematch(re)
  assert parse(p, "abc") == Some(#(Match("abc", []), ""))
  assert parse(p, "abcd") == Some(#(Match("abc", []), "d"))
  assert parse(p, "ab") == None
  let assert Ok(re2) = regexp.from_string("a(bc|de)")
  let p2 = regex.rematch(re2)
  assert parse(p2, "abc") == Some(#(Match("abc", [Some("bc")]), ""))
  assert parse(p2, "abd") == None
  let assert Ok(re3) =
    regexp.compile("^\\s*\\?\\s+abc$", regexp.Options(False, True))
  let p3 = regex.rematch(re3)
  assert parse(p3, "? abc") == Some(#(Match("? abc", []), ""))
  assert parse(p3, "?abc") == None
  assert parse(p3, " ? abc") == Some(#(Match(" ? abc", []), ""))
  assert parse(p3, " ? abc\n ? def") == Some(#(Match(" ? abc", []), "\n ? def"))
}
