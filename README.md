# moonbit-sqlfmt

> MoonBit 生态的 PostgreSQL 方向 SQL 格式化器（formatter → tokenizer → parser 渐进路线）

**English**: A SQL formatter for PostgreSQL dialect, written in MoonBit. Growing from tokenizer → formatter → parser, one publishable library at a time.

## 项目状态

**🚧 计划阶段** —— 路线图见 [PLAN.md](PLAN.md)，AI 协作规则见 [AGENTS.md](AGENTS.md)

| 里程碑 | 内容 | 状态 |
|---|---|---|
| M0 | 环境验证 + 发布流程跑通 | ⬜ 未开始 |
| M0 | 环境验证 + 发布流程跑通 | 🟡 进行中（热身项目已完成，发布/CI 待用户操作） |
| M1 | `sql-tokenizer` v0.1 | ⬜ 未开始 |
| M2 | `sql-formatter` v0.1（自用价值达成点） | ⬜ 未开始 |
| M3 | `sqlparser`（可选进阶） | ⬜ 未开始 |

## 动机

1. **生态空位**：Mooncakes 上目前只有 PostgreSQL/SQLite 的客户端绑定，没有 SQL 格式化/解析库（发布前需查重，见 [docs/competitive-research.md](docs/competitive-research.md)）
2. **需求经过验证**：JS 的 `sql-formatter` 周下载百万级，Python 的 `sqlparse` 是事实标准——需求真实存在
3. **自用闭环**：日常工作中生成 SQL（ufx-gen-sql）、排查 TraceId 日志里的裸 SQL，格式化器做完直接接入现有工作流

## 路线一句话

```
Tokenizer（纯函数+快照测试） → Formatter（PG 方向格式化） → Parser（AST 子集）
```

每个阶段都是**独立可发布**的库，随时可停在最近的里程碑。

## 参考与对标

- [sql-formatter](https://github.com/sql-formatter-org/sql-formatter)（JS）— 格式化规则与配置项设计参考
- [sqlparse](https://github.com/andialbrecht/sqlparse)（Python）— tokenizer/parser 架构参考
- [moonbitlang/core](https://github.com/moonbitlang/core) — MoonBit 标准库源码（开发时的 API 事实来源，见 `refs/`）

## 许可证

Apache-2.0（待首个发布前确认）

## 相关文档

- [PLAN.md](PLAN.md) — 总计划：里程碑、任务分解、验收标准、风险
- [AGENTS.md](AGENTS.md) — AI 辅助开发约定（喂真实源码、declare 先行、测试纪律）
- [docs/competitive-research.md](docs/competitive-research.md) — 生态查重清单
