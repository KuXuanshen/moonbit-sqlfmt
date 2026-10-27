///|
/// Demo: pretty-print a small JSON tree, matching the README example.
/// Run with `moon run cmd/main` from the project root.
fn main {
  let json : @lib.JsonValue = @lib.Obj([
    ("name", @lib.Str("Alice")),
    ("age", @lib.Number(30.0)),
    ("tags", @lib.Arr([@lib.Str("sql"), @lib.Str("moonbit")])),
  ])
  println(json.pretty())
}
