// Blackbox tests for @json-pretty's public API.
// Snapshots are refreshed with `moon test --update`.

///|
test "pretty/simple_object" {
  let json : @json-pretty.JsonValue = Obj([
    ("name", Str("Alice")),
    ("age", Number(30.0)),
    ("active", Bool(true)),
  ])
  inspect(
    json.pretty(),
    content=(
      #|{
      #|  "name": "Alice",
      #|  "age": 30,
      #|  "active": true
      #|}
    ),
  )
}

///|
test "pretty/nested_array" {
  let json : @json-pretty.JsonValue = Obj([
    (
      "matrix",
      Arr([Arr([Number(1.0), Number(2.0)]), Arr([Number(3.0), Number(4.0)])]),
    ),
    ("empty", Arr([])),
    ("empty_obj", Obj([])),
  ])
  inspect(
    json.pretty(),
    content=(
      #|{
      #|  "matrix": [
      #|    [
      #|      1,
      #|      2
      #|    ],
      #|    [
      #|      3,
      #|      4
      #|    ]
      #|  ],
      #|  "empty": [],
      #|  "empty_obj": {}
      #|}
    ),
  )
}

///|
test "pretty/null_and_escapes" {
  let json : @json-pretty.JsonValue = Obj([
    ("note", Str("line1\nline2\ttab")),
    ("quote", Str("say \"hi\"")),
    ("backslash", Str("a\\b")),
    ("nil", Null),
  ])
  inspect(
    json.pretty(),
    content=(
      #|{
      #|  "note": "line1\nline2\ttab",
      #|  "quote": "say \"hi\"",
      #|  "backslash": "a\\b",
      #|  "nil": null
      #|}
    ),
  )
}

///|
test "pretty/indent_4" {
  let json : @json-pretty.JsonValue = Obj([("a", Arr([Number(1.0)]))])
  inspect(
    json.pretty(indent=4),
    content=(
      #|{
      #|    "a": [
      #|        1
      #|    ]
      #|}
    ),
  )
}
