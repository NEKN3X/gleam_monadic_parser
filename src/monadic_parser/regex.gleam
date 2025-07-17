import gleam/option.{None, Some}
import gleam/regexp
import gleam/string
import monadic_parser/parser.{P}

pub fn token(re: regexp.Regexp) {
  P(fn(input) {
    case regexp.scan(re, input) {
      [match, ..] -> {
        let len = match.content |> string.length
        Some(#(match, string.drop_start(input, len)))
      }
      _ -> None
    }
  })
}
