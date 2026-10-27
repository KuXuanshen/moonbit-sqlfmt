# moonbit-sqlfmt

[English](README.md) | **简体中文**

> MoonBit 生态的 PostgreSQL 方向 SQL 格式化器——tokenizer → formatter → parser 渐进生长，每个阶段都是独立可发布的库

## 项目状态

**🚧 早期阶段** —— 路线图见 [PLAN.md](PLAN.md)，AI 协作规则见 [AGENTS.md](AGENTS.md)

| 里程碑 | 内容 | 状态 |
|---|---|---|
| M0 | 环境验证 + 发布流程跑通 | ✅ 完成（json-pretty 已发布，CI 绿） |
| M1 | `sql-tokenizer` v0.1 | ⬜ 未开始 |
| M2 | `sql-formatter` v0.1（自用价值达成点） | ⬜ 未开始 |
| M3 | `sqlparser`（可选进阶） | ⬜ 未开始 |

**M0 产出**：[`KuXuanshen/json-pretty`](https://mooncakes.io/docs/KuXuanshen/json-pretty)——JSON 美化打印包（`JsonValue` 树 + 对齐 `JSON.stringify` 的缩进行为），用它完整走通了一遍「declare 接口 → 快照测试 → 实现 → 发布上 Mooncakes」的流程。

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

Apache-2.0

## 相关文档

- [PLAN.md](PLAN.md) — 总计划：里程碑、任务分解、验收标准、风险
- [AGENTS.md](AGENTS.md) — AI 辅助开发约定（喂真实源码、declare 先行、测试纪律）
- [docs/competitive-research.md](docs/competitive-research.md) — 生态查重清单
- [README.md](README.md) — English version
