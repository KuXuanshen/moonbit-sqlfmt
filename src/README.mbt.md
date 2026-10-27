# json-pretty

JSON pretty-printer for MoonBit: build a `JsonValue` tree, render it with
`JSON.stringify(value, null, indent)`-style indentation.

> Warm-up package for the [moonbit-sqlfmt](https://github.com/) project (M0
> milestone): it exercises the full declare → test → implement → publish loop.

## Usage

```moonbit nocheck
let json : @json-pretty.JsonValue = Obj([
  ("name", Str("Alice")),
  ("age", Number(30.0)),
  ("tags", Arr([Str("sql"), Str("moonbit")])),
])
println(json.pretty())
```

Output:

```
{
  "name": "Alice",
  "age": 30,
  "tags": [
    "sql",
    "moonbit"
  ]
}
```

- `pretty(indent~ = 2)` — spaces per nesting level
- empty containers stay inline: `{}`, `[]`
- strings are escaped exactly like `JSON.stringify`

## API

| Member | Description |
|---|---|
| `JsonValue` | `Null \| Bool(Bool) \| Number(Double) \| Str(String) \| Arr(Array[JsonValue]) \| Obj(Array[(String, JsonValue)])` |
| `JsonValue::pretty` | `(self, indent~ : Int = 2) -> String` |

Object members keep insertion order (stored as an array of pairs, not a map).