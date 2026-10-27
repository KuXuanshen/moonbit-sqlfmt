///|
/// JSON value tree used by the warm-up pretty-printer.
/// Object members keep insertion order, so `Obj` stores an array of pairs
/// instead of a hash map.
pub(all) enum JsonValue {
  Null
  Bool(Bool)
  Number(Double)
  Str(String)
  Arr(Array[JsonValue])
  Obj(Array[(String, JsonValue)])
} derive(Eq)

///|
pub extend JsonValue with Eq::{not_equal, equal}

///|
/// Render a JSON value as indented, human-readable text.
///
/// Behavior mirrors `JSON.stringify(value, null, indent)`:
/// - empty objects/arrays render as `{}` / `[]`
/// - every other container spans multiple lines, one member per line
/// - `indent` is the number of spaces per nesting level (default 2)
pub fn JsonValue::pretty(self : JsonValue, indent~ : Int32 = 2) -> String {
  let buf = StringBuilder()
  write_value(buf, self, indent, 0)
  buf.to_string()
}

///|
fn write_indent(buf : StringBuilder, width : Int32, level : Int32) -> Unit {
  let total = width * level
  for _ in 0..<total {
    buf.write_char(' ')
  }
}

///|
fn write_value(
  buf : StringBuilder,
  value : JsonValue,
  indent : Int32,
  level : Int32,
) -> Unit {
  match value {
    Null => buf.write_string("null")
    Bool(b) => buf.write_string(if b { "true" } else { "false" })
    Number(n) => buf.write_object(n)
    Str(s) => write_escaped(buf, s)
    Arr(items) =>
      if items.is_empty() {
        buf.write_string("[]")
      } else {
        buf.write_char('[')
        for i, item in items {
          if i > 0 {
            buf.write_char(',')
          }
          buf.write_char('\n')
          write_indent(buf, indent, level + 1)
          write_value(buf, item, indent, level + 1)
        }
        buf.write_char('\n')
        write_indent(buf, indent, level)
        buf.write_char(']')
      }
    Obj(members) =>
      if members.is_empty() {
        buf.write_string("{}")
      } else {
        buf.write_char('{')
        for i, (key, elem) in members {
          if i > 0 {
            buf.write_char(',')
          }
          buf.write_char('\n')
          write_indent(buf, indent, level + 1)
          write_escaped(buf, key)
          buf.write_string(": ")
          write_value(buf, elem, indent, level + 1)
        }
        buf.write_char('\n')
        write_indent(buf, indent, level)
        buf.write_char('}')
      }
  }
}

///|
fn write_escaped(buf : StringBuilder, s : String) -> Unit {
  buf.write_char('"')
  for ch in s {
    match ch {
      '"' => buf.write_string("\\\"")
      '\\' => buf.write_string("\\\\")
      '\n' => buf.write_string("\\n")
      '\r' => buf.write_string("\\r")
      '\t' => buf.write_string("\\t")
      '\b' => buf.write_string("\\b")
      _ => {
        let code = ch.to_int()
        // Escape C0 control chars and DEL the way JSON.stringify does.
        if code < 0x20 || code == 0x7F {
          buf.write_string("\\u00")
          buf.write_char(hex_digit(code / 16))
          buf.write_char(hex_digit(code % 16))
        } else {
          buf.write_char(ch)
        }
      }
    }
  }
  buf.write_char('"')
}

///|
fn hex_digit(n : Int32) -> Char {
  let code = if n < 10 { '0'.to_int() + n } else { 'a'.to_int() + n - 10 }
  code.to_char().unwrap()
}
