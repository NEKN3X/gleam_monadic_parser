# monadic_parser

[![Package Version](https://img.shields.io/hexpm/v/monadic_parser)](https://hex.pm/packages/monadic_parser)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/monadic_parser/)

```sh
gleam add monadic_parser@1
```

```gleam
import gleam/option.{Some}
import monadic_parser.{type Parser} as parser

pub fn expr() -> Parser(Int) {
  use t <- parser.bind(term())
  {
    use _ <- parser.bind(parser.symbol("+"))
    use e <- parser.bind(expr())
    parser.pure(t + e)
  }
  |> parser.alt(parser.pure(t))
}

pub fn term() -> Parser(Int) {
  use f <- parser.bind(factor())
  {
    use _ <- parser.bind(parser.symbol("*"))
    use t <- parser.bind(term())
    parser.pure(f * t)
  }
  |> parser.alt(parser.pure(f))
}

pub fn factor() -> Parser(Int) {
  {
    use _ <- parser.bind(parser.symbol("("))
    use e <- parser.bind(expr())
    use _ <- parser.bind(parser.symbol(")"))
    parser.pure(e)
  }
  |> parser.alt(parser.natural())
}

pub fn eval(xs: String) -> Result(Int, String) {
  case parser.parse(expr(), xs) {
    Some(#(n, "")) -> Ok(n)
    Some(#(_, out)) -> Error("unused input " <> out)
    _ -> Error("invalid input")
  }
}

pub fn main() -> Nil {
  eval("2 + 3)
}
```

Further documentation can be found at <https://hexdocs.pm/monadic_parser>.

## Development

```sh
gleam run   # Run the project
gleam test  # Run the tests
```
