# 生态查重清单（M1 第一项任务）

> 目的：确认「MoonBit 生态没有 SQL formatter/parser」这个前提仍然成立；若已撞车，启动差异化策略。
> 完成日期：2026-10-27 ｜ 结论：**部分撞车**——`moonbit-community/sqlparser` 已覆盖多方言 lexer/parser/pretty-print，但 PG 专属语法有硬缺口（`::`、`E''`、`$$..$$` 均未支持）且为严格失败模式（无容错）；「PG 深度 + 日志容错美化」方向仍成立，详见命中记录。

## 查重步骤

- [x] Mooncakes.io（https://mooncakes.io）搜索关键词：`sql`、`sqlfmt`、`formatter`、`tokenizer`、`parser`、`postgres`（注：搜索 API 不公开，改用 GitHub repo 搜索 + awesome-moonbit 交叉验证，Mooncakes 发布状态经 clone 源码 moon.mod 确认）
- [x] 通读 https://github.com/moonbitlang/awesome-moonbit 全部分类（2026-10-27 版）
- [x] GitHub 搜索：`sql moonbit`（repositories 搜索）
- [ ] MoonBit 论坛（taolun.moonbitlang.com）与 Discord #showcase 频道搜「sql」——论坛需账号登录，待用户顺带确认；GitHub 搜索已覆盖公开发布物，风险低

## 命名候选（按优先级）

1. `moonbit-sqlfmt`（repo 名，已启用）/ `sqlfmt.mbt`（包名）
2. `moonbit-pgfmt`（强调 PG 方向）
3. tokenizer 包独立命名：`sql-tokenizer.mbt` 或并入主包

## 若已撞车的差异化方向

| 差异点 | 说明 |
|---|---|
| PG 方言深度 | dollar-quoted、`::`、`E''`、`$n` 等原生支持，通用库通常缺（sqlparser 已证实缺前三者） |
| 日志场景 | 面向「从日志里抠出的裸 SQL」的美化（容错半截语句）；sqlparser 为 `raise` 严格失败模式 |
| 对拍质量 | 用 sql-formatter(JS) 官方样例做对拍，输出质量可验证 |
| lint 长线 | M3 的 AST → SQL lint，通用 formatter 不做 |

## 命中记录

### 1. moonbit-community/sqlparser（重合度：中高）

- 仓库：https://github.com/moonbit-community/sqlparser ｜ Mooncakes 已发布 v0.5.1
- 维护者：moonbit-community（官方社区组织）｜ 最后提交 2026-10-13（活跃）｜ 10 stars
- 功能：多方言 SQL lexer + parser + AST + pretty_print（`parse_sql(dialect~) raise SqlParserError`），依赖 `prettyprinter@0.4.11`；284+ 测试；方言含 MySQL/PostgreSQL/SQLite/ANSI/BigQuery/Snowflake/Redshift/ClickHouse/DuckDB；对标 datafusion-sqlparser-rs
- **PG 专属语法实测缺口**（2026-10-27 clone 源码确认）：
  - ❌ `::` 类型转换（lexer 无 DoubleColon/TypeCast token）——PG 高频语法
  - ❌ `E'\x41'` 转义字符串字面量
  - ❌ `$$...$$` dollar-quoted 字符串（grep 仅命中 `$n` 占位符，已支持）
  - ❌ 容错模式：tokenize/parse 失败直接 `raise`，半截 SQL（日志场景）无法美化
- 差异化结论：**不正面竞争通用 parser**。本项目定位 = PG 深度方言工具链 + 日志容错美化；sqlparser 反而是潜在下游/对拍参照

### 2. moonbit-community/sqlite3、moonbit-community/postgres（重合度：无）

- 均为数据库客户端绑定，与 formatter/parser 方向无重叠

### 3. ORM/query-builder 类：oboard/morm、moonbitstack/moonorm、Allianaab2m/aya-orm、ash1day/moonbit-sql、mizchi/sqlc_gen_moonbit（重合度：无）

- 均为「生成 SQL」方向（ORM、query builder、sqlc 代码生成），不做「解析/美化已有 SQL」

### 4. moonbit-community/prettyprinter（重合度：低，可借用）

- 通用文档布局/美化库（Wadler 风格）；M2 可作为格式化引擎候选依赖，或自研轻量布局器

### 5. 官方工具链：MoonLex（lexer 生成器）、MoonYacc（LR(1)）、moonbitlang/parser（MoonBit 自举 parser）（重合度：无）

- 均为 MoonBit 语言自身工具链；M3 设计时可参考其架构
