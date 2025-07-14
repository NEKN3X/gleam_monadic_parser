# monadic_parser

[![Package Version](https://img.shields.io/hexpm/v/monadic_parser)](https://hex.pm/packages/monadic_parser)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/monadic_parser/)

```sh
gleam add monadic_parser@1
```

```gleam
import gleam/option.{Some}
import monadic_parser/sample

pub fn main() -> Nil {
  sample.eval("2 + 3")
}
```

Further documentation can be found at <https://hexdocs.pm/monadic_parser>.

## Development

```sh
gleam run   # Run the project
gleam test  # Run the tests
```
