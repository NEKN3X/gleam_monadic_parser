import gleam/int
import gleam/string

pub fn is_digit(s: String) -> Bool {
  case int.parse(s) {
    Ok(_) -> True
    Error(_) -> False
  }
}

pub fn is_lower(s: String) -> Bool {
  case string.lowercase(s) {
    s2 if s == s2 -> True
    _ -> False
  }
}

pub fn is_upper(s: String) -> Bool {
  case string.uppercase(s) {
    s2 if s == s2 -> True
    _ -> False
  }
}

pub fn is_alpha(s: String) -> Bool {
  is_lower(s) != is_upper(s)
}

pub fn is_alpha_num(s: String) -> Bool {
  is_alpha(s) || is_digit(s)
}

pub fn is_space(s: String) -> Bool {
  case s {
    " " -> True
    _ -> False
  }
}

pub fn is_full_space(s: String) -> Bool {
  case s {
    "　" -> True
    _ -> False
  }
}

pub fn is_tab(s: String) -> Bool {
  case s {
    "\t" -> True
    _ -> False
  }
}

pub fn is_newline(s: String) -> Bool {
  case s {
    "\n" -> True
    _ -> False
  }
}

pub fn is_cr(s: String) -> Bool {
  case s {
    "\r" -> True
    _ -> False
  }
}

pub fn is_crlf(s: String) -> Bool {
  case s {
    "\r\n" -> True
    _ -> False
  }
}

pub fn is_blank(s: String) -> Bool {
  is_space(s)
  || is_full_space(s)
  || is_tab(s)
  || is_newline(s)
  || is_cr(s)
  || is_crlf(s)
}
