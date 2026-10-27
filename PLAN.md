# moonbit-sqlfmt 总计划

> 创建：2026-10-27 ｜ 状态：计划阶段 ｜ 节奏：业余时间推进，每周约 5-8 小时

## 目标

- **主目标**：做出 MoonBit 生态第一个 PostgreSQL 方向的 SQL formatter，并渐进生长为 tokenizer → formatter → parser 工具链
- **三重收益**：GitHub/Mooncakes 作品集 ｜ 接入日常工作流（SQL 美化、日志排查）｜ 把 Coding Plan 额度烧成资产

## 非目标（scope 边界）

- ❌ 不做查询执行、优化、数据库连接（生态已有 postgres/sqlite3 客户端绑定）
- ❌ 阶段 3 之前不追求完整 PostgreSQL 语法覆盖（只做高频子集）
- ❌ 不做多方言抽象层（先 PostgreSQL，方言架构等有真实需求再说）
- ❌ 不设截止日期压力——每阶段独立可发布，停在任意里程碑都有完整产出

## 里程碑总览

```
M0 环境与流程验证（第 1 周）
   └ 装工具链、Tour 入门、JSON pretty-printer 热身、hello 包发布跑通全流程
M1 sql-tokenizer v0.1（第 2-4 周）
   └ SQL 词法分析：token 类型设计 + PG 特有语法 + 快照测试
M2 sql-formatter v0.1（第 5-8 周）★ 自用价值达成点
   └ 格式化规则、配置项、接入 TraceId 日志 SQL 美化工作流
M3 sqlparser 0.x（第 2-3 月，可选）
   └ SELECT/INSERT/UPDATE/DELETE 子集 → AST → SQL lint 雏形
```

---

## M0 · 环境与流程验证（第 1 周）

**目的**：用最小的代价验证「开发环境 + AI 辅助循环 + 发布流程」全链路，扫清所有流程性障碍。

### 任务清单

- [x] 安装 `moon` 工具链（官方安装指引），记录版本号到本文件「环境记录」节
- [x] 过一遍 [Tour of MoonBit](https://docs.moonbitlang.com) 语法导览（AI 侧已按 `refs/moonbit-docs` 源码精读 fundamentals/tests 关键章节；人工通读待补）
- [~] VS Code 插件安装验证——用户决定暂缓（2026-10-27）：开发循环用 bash + moon 命令已验证可行，编译器工具链（moonc）独立于 IDE
- [x] **热身项目**：JSON pretty-printer（与 formatter 技能同构：读入 → 结构化 → 缩进输出）
  - [x] `declare` 定义 `JsonValue` 枚举 + pretty 函数签名
  - [x] 快照测试 3 组：简单对象、嵌套数组、空值/转义字符（+额外 indent=4 用例，共 4 组）
- [x] **发布演练**：`KuXuanshen/json-pretty@0.1.0` 已发布到 Mooncakes.io（2026-10-27）；页面 https://mooncakes.io/docs/KuXuanshen/json-pretty ；第三方目录 `import` + `moon update` + check/test 闭环验证通过
- [ ] GitHub 建 repo `moonbit-sqlfmt`，CI 用官方 `setup-moonbit` Action，跑绿一次 `moon test`（workflow 已写好：`.github/workflows/ci.yml`，用 `hustcer/setup-moonbit@v1`；建 repo + push 需用户操作）
- [x] README 完善中英双语：`README.md`（英文主文档）+ `README.zh-CN.md`（简体中文），互相链接；包 README `src/README.mbt.md` 已补全
### 验收标准

1. Mooncakes.io 上能搜到自己发布的包
2. GitHub Actions CI 绿灯（至少跑通 `moon check && moon test`）
3. 「从零到发布」的完整流程在 AI 辅助下走通一遍——这比代码本身重要

### 环境记录

| 项 | 值 |
|---|---|
| moon 版本 | 0.1.20261023 (3778465 2026-10-23) |
| 操作系统 | Windows（bash 会话需 `export PATH="$HOME/.moon/bin:$PATH"`） |
| core 版本 | refs/core 主干快照 2026-10-27 a0f1c5bf（moon 安装时另行 bundle 了 core） |
| 备注 | GitHub 直连不通，clone/push 需代理 `http://127.0.0.1:7897` |
---

## M1 · sql-tokenizer v0.1（第 2-4 周）

**目的**：把 SQL 文本切成带类型的 token 流。纯函数、无 IO，是 AI 辅助生成正确率最高的部分。

### 任务清单

- [ ] 查重：完成 [docs/competitive-research.md](docs/competitive-research.md) 清单（Mooncakes 搜 `sql`、`tokenizer`、`formatter`；扫 awesome-moonbit）
- [ ] `declare` 设计 `Token` 枚举：
  - 关键字 / 标识符（含双引号 `"..."`）/ 未限定标识符
  - 数字字面量（整数、小数、科学计数法）
  - 字符串字面量（`'...'`，含 `''` 转义）/ PG `E'...'` / Dollar-quoted `$$...$$`
  - 注释（`--` 行注释、`/* */` 块注释，保留原文供 formatter 决定去留）
  - 操作符（含 PG `::` 类型转换）、`$1` 参数占位符、逗号/分号/括号
- [ ] 实现 `tokenize(input: String) -> Result[Array[Token], TokenizeError]`
- [ ] 行号/列号定位（为错误信息与后续 parser 服务）
- [ ] 快照测试集 ≥ 30 组用例，覆盖：
  - 常规 SELECT/INSERT/UPDATE/DELETE 片段
  - PG 特有：`::`、`E'\x41'`、`$$ 函数体 $$`、`$1`、`U&'...'`
  - 边界：未闭合字符串、未闭合注释、空输入、纯空白
- [ ] 文档：README 带 token 类型表格 + 使用示例
- [ ] 发布 `sql-tokenizer` v0.1 到 Mooncakes，提交 awesome-moonbit PR

### 验收标准

1. `moon test` 全绿，快照用例 ≥ 30 组
2. 对日常工作中抓到的 10 条真实裸 SQL（脱敏）tokenize 无报错
3. Mooncakes 包带文档可被 `moon add` 引用

---

## M2 · sql-formatter v0.1（第 5-8 周）★ 自用价值达成点

**目的**：token 流 → 格式化 SQL 文本。做完这一步，项目开始产生日常价值。

### 任务清单

- [ ] 配置项设计（对标 sql-formatter）：
  - `tabWidth`（默认 2）、`useTabs`
  - `keywordCase`：preserve / upper / lower（默认 upper）
  - `indentStyle`：standard / tabularLeft（第一版只做 standard）
  - `linesBetweenQueries`（多语句分段）
- [ ] 格式化规则（第一版范围）：
  - SELECT 字段列表换行、`FROM` / `WHERE` / `GROUP BY` / `ORDER BY` / `LIMIT` 块级缩进
  - JOIN 系列换行对齐（INNER/LEFT/RIGHT/FULL + ON 条件）
  - AND / OR 子句换行缩进
  - 子查询（嵌套 SELECT）缩进递归
  - INSERT INTO ... VALUES (...) 块状排版
  - 注释保留与对齐
- [ ] 对拍验证：取 sql-formatter（JS）的官方测试样例 20 组，输出结构一致（允许空白策略差异）
- [ ] **接入自用工作流**：写一个 CLI 子命令或独立小工具，输入文件/stdin → 美化输出；配合脚本处理 TraceId 日志中的裸 SQL
- [ ] **核心场景：日志脏 SQL 容错美化**（差异化卖点 = 自用痛点，合一）：输入是 TraceId 日志里抠出的裸 SQL——带日志前缀噪声、绑定参数 `$1`、甚至半截语句；容错策略：可配置噪声剥离 + 半截语句「尽量美化已闭合部分」。这是 npx sql-formatter 覆盖不了的场景
- [ ] **接入自用工作流**：CLI（stdin/文件 → 美化输出）+ 包装脚本，排 TraceId 日志时一键美化
- [ ] **语料回流**：工作真实脱敏 SQL 沉淀到 `testdata/corpus/`，同时用作 ufx-gen-sql 的 few-shot 样例与输出校验库——语料一次积累，两边受益
- [ ] 发布 `sql-formatter` v0.1；README 增加 before/after 效果展示（用真实脱敏 SQL）
- [ ] 宣发：taolun.moonbitlang.com 发帖 + 知乎/掘金一篇「用 AI 辅助在 MoonBit 写 SQL formatter」

### 验收标准

1. 自己日常工作流里**真实使用两周以上**，无不可接受的格式化错误
2. CI 绿、Mooncakes 可安装、README 有 before/after 示例
3. 有一篇公开的发布帖/文章

---

## M3 · sqlparser 0.x（第 2-3 月，可选进阶）

**目的**：token 流 → AST。只做高频子集，为 lint/分析类工具打地基。**是否启动取决于 M2 后的时间与兴趣，不启动也不影响项目完整性。**

### 任务清单（草案）

- [ ] AST 设计：`SelectStmt` / `InsertStmt` / `UpdateStmt` / `DeleteStmt` 子集（表达式只做到函数调用 + 二元运算 + 字面量）
- [ ] 递归下降 parser，错误信息带位置
- [ ] 第一個上层应用：SQL lint 规则 3-5 条（如 `SELECT *` 警告、无 WHERE 的 UPDATE/DELETE 警告）
- [ ] 语法覆盖度测试：用 pg_query 类语料抽样

### 验收标准

1. 能解析对拍语料中 ≥ 80% 的高频语句
2. lint 工具能跑通一条端到端 pipeline

---

## 风险与对策

| 风险 | 对策 |
|---|---|
| MoonBit 0.x 工具链变化快，API 漂移 | 锁定 moon 版本记录在案；关注官方月报，升级单独开分支做 |
| AI 凭记忆编造 MoonBit API（训练语料少） | AGENTS.md 铁律：只信 `refs/core` 真实源码，`moon check` 把关 |
| 被别人抢先发布同类库 | M1 第一周就查重；若撞车则差异化（PG 方言深度、日志工作流场景、对拍质量） |
| 时间不足烂尾 | 每阶段独立可发布；最低完成线 = M2 |
| 快照测试与行为改动扯皮 | 任何快照变更必须在 commit message 里说明理由 |

## 与工作流的协同（兼顾设计）

本项目定位是「投资品」，但通过三个杠杆让过程产物回流日常工作，避免"纯烧时间"：

1. **题材合一**：M2 核心场景 = 日志脏 SQL 容错美化——生态差异化卖点与日常工作痛点是同一件事，做完即自用，且无现成替代品
2. **语料回流**：`testdata/corpus/` 的脱敏 SQL 快照样例同时是 ufx-gen-sql 的 few-shot 样例与输出校验库，语料积累一次、两边受益
3. **方法论迁移**：「declare 接口 + 快照测试先行 + 只信真实源码」的 AI 辅助纪律，逐步移植到 CodeX 高频技能（ufx-gen-sql、ai-code-review）的打磨中

**时间原则**：工作流提效优先，本项目用剩余业余时间推进（约 70/30）；项目每月至少一个小步提交防停滞——工作再忙，M1/M2 独立可发布的结构也允许随时暂停。

---

## 进度记录

- 2026-10-27 ｜ 创建计划文档
- 2026-10-27 ｜ M0 ｜ moon 0.1.20261023 安装完成；refs/ 初始化（core + moonbit-docs）；热身项目 json-pretty 完成（JsonValue + pretty + 4 组 inspect 快照测试全绿，moon check/test/fmt 通过）；CI workflow 就绪。待办：VS Code 验证、moon login 发布、GitHub 建 repo 推送
- 2026-10-27 ｜ M0 ｜ 发布演练完成：moon login（用户 KuXuanshen）→ 包名改为 KuXuanshen/json-pretty → moon publish 200 OK → 第三方 import 闭环验证通过。VS Code 插件验证经用户决定暂缓
- 2026-10-27 ｜ 更新 M2 scope：核心场景改为日志脏 SQL 容错美化，新增「与工作流的协同」节
- （后续按「日期 ｜ 里程碑 ｜ 摘要」格式追加）

## 决策日志

- 2026-10-27 ｜ 选定 SQL formatter→parser 方向（而非解释器玩具）：与日常工作流强连接、需求经其他语言验证、纯函数题型对 AI 辅助友好
- 2026-10-27 ｜ 只做 PostgreSQL 方言，不做多方言抽象：避免第一版过度设计
- 2026-10-27 ｜ 兼顾设计：M2 主打「日志脏 SQL 容错美化」（差异化=自用合一），语料与方法论双向回流工作流；时间按 70/30（工作流优先）
