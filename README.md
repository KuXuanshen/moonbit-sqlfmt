# moonbit-sqlfmt

**English** | [简体中文](README.zh-CN.md)

> A SQL formatter for the PostgreSQL dialect, written in MoonBit — growing from tokenizer → formatter → parser, one publishable library at a time.

## Status

**🚧 Early stage** — roadmap in [PLAN.md](PLAN.md) (zh-CN), AI-collaboration rules in [AGENTS.md](AGENTS.md) (zh-CN)

| Milestone | Scope | Status |
|---|---|---|
| M0 | Environment + publish pipeline validation | 🟡 Almost done — warm-up package released |
| M1 | `sql-tokenizer` v0.1 | ⬜ Not started |
| M2 | `sql-formatter` v0.1 (self-use value) | ⬜ Not started |
| M3 | `sqlparser` (optional) | ⬜ Not started |

**M0 artifact**: [`KuXuanshen/json-pretty`](https://mooncakes.io/docs/KuXuanshen/json-pretty) — a JSON pretty-printer (`JsonValue` tree + `JSON.stringify`-style indentation) that exercised the full declare → test → implement → publish loop on Mooncakes.io.

## Why

1. **Ecosystem gap**: Mooncakes currently only has PostgreSQL/SQLite *client bindings* — no SQL formatting/parsing library (to be re-checked before release, see `docs/competitive-research.md`)
2. **Proven demand**: JS `sql-formatter` gets millions of weekly downloads; Python `sqlparse` is the de-facto standard
3. **Daily-driver**: the author generates SQL and digs raw SQL out of TraceId logs at work — the formatter plugs straight into that workflow

## Roadmap in one line

```
Tokenizer (pure functions + snapshot tests) → Formatter (PostgreSQL) → Parser (AST subset)
```

Every stage ships as an **independently publishable** library; the project can pause at any milestone with something complete.

## References

- [sql-formatter](https://github.com/sql-formatter-org/sql-formatter) (JS) — formatting rules & config design
- [sqlparse](https://github.com/andialbrecht/sqlparse) (Python) — tokenizer/parser architecture
- [moonbitlang/core](https://github.com/moonbitlang/core) — the source of truth for MoonBit APIs during development (kept under `refs/`)

## License

Apache-2.0

## Related docs

- [PLAN.md](PLAN.md) — master plan: milestones, tasks, acceptance criteria, risks (zh-CN)
- [AGENTS.md](AGENTS.md) — AI collaboration rules: real-source-only API usage, declare-first, test discipline (zh-CN)
- [docs/competitive-research.md](docs/competitive-research.md) — ecosystem gap checklist (zh-CN)
- [README.zh-CN.md](README.zh-CN.md) — 简体中文版
