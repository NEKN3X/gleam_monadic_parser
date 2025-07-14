import gleam/string
import gleeunit

pub fn main() -> Nil {
  gleeunit.main()
}

// gleeunit test functions end in `_test`

pub fn crlf_test() {
  assert "\r\n" |> string.split("") == ["\r\n"]
}
