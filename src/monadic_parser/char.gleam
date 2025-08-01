import gleam/list
import gleam/string
import monadic_parser/string as str

/// A character type that wraps a single character string.
pub opaque type Char {
  Char(String)
}

/// Create a new Char from a single character string.
pub fn new(i: String) -> Char {
  assert string.length(i) == 1
  Char(i)
}

/// Split a string into a list of Char, each containing a single character.
pub fn split_string(input: String) {
  string.split(input, "")
  |> list.map(Char)
}

/// Convert a Char back to a string.
pub fn to_string(c: Char) -> String {
  case c {
    Char(s) -> s
  }
}

/// Join a list of Char back into a single string.
pub fn join(chars: List(Char)) -> String {
  chars
  |> list.map(to_string)
  |> string.join("")
}

pub fn append(c: Char, s: String) -> String {
  case c {
    Char(i) -> string.append(i, s)
  }
}

pub fn equals(c1: Char, c2: Char) -> Bool {
  case c1, c2 {
    Char(s1), Char(s2) -> s1 == s2
  }
}

pub fn uppercase(c: Char) -> Char {
  case c {
    Char(s) -> Char(string.uppercase(s))
  }
}

pub fn lowercase(c: Char) -> Char {
  case c {
    Char(s) -> Char(string.lowercase(s))
  }
}

pub fn is_digit(c: Char) -> Bool {
  case c {
    Char(s) -> str.is_digit(s)
  }
}

pub fn is_lower(c: Char) -> Bool {
  case c {
    Char(s) -> str.is_lower(s)
  }
}

pub fn is_upper(c: Char) -> Bool {
  case c {
    Char(s) -> str.is_upper(s)
  }
}

pub fn is_alpha(c: Char) -> Bool {
  case c {
    Char(s) -> str.is_alpha(s)
  }
}

pub fn is_alpha_num(c: Char) -> Bool {
  case c {
    Char(s) -> str.is_alpha_num(s)
  }
}

pub fn is_space(c: Char) -> Bool {
  case c {
    Char(s) -> str.is_space(s)
  }
}

pub fn is_full_space(c: Char) -> Bool {
  case c {
    Char(s) -> str.is_full_space(s)
  }
}

pub fn is_tab(c: Char) -> Bool {
  case c {
    Char(s) -> str.is_tab(s)
  }
}

pub fn is_newline(c: Char) -> Bool {
  case c {
    Char(s) -> str.is_newline(s)
  }
}

pub fn is_cr(c: Char) -> Bool {
  case c {
    Char(s) -> str.is_cr(s)
  }
}

pub fn is_crlf(c: Char) -> Bool {
  case c {
    Char(s) -> str.is_crlf(s)
  }
}

pub fn is_blank(c: Char) -> Bool {
  case c {
    Char(s) -> str.is_blank(s)
  }
}
