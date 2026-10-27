# moonbit-sqlfmt AI 协作约定

本文件约束所有 AI 辅助开发会话（pi / 其他 agent）在本项目内的行为。

## 语言

- 输出与思考一律使用简体中文；代码注释用英文，标识符用英文。

## 铁律：只信 refs/ 里的真实源码

MoonBit 是新语言，模型训练语料少，**凭记忆写 MoonBit API 大概率是编造的**。因此：

1. 用到 `@moonbitlang/core` 的任何 API 前，必须先 `read` 对应模块源码：
   - 字符串处理 → `refs/core/bytes/`、`refs/core/string/`
   - 容器 → `refs/core/array/`、`refs/core/map/`、`refs/core/vec/`
   - 迭代 → `refs/core/iter/`
   - 其他模块同理；不确定就先搜 `refs/core/` 再写
2. 语言语法不确定时，查 `refs/moonbit-docs/`（官方文档仓库，含 Tour、手册、构建系统文档）
3. `moon check` 是最终裁判：类型不过就是写错了，回去读源码，不要猜

## 参考源码初始化（refs/ 首次准备）

```bash
git clone https://github.com/moonbitlang/core refs/core
git clone https://github.com/moonbitlang/moonbit-docs refs/moonbit-docs
```

`refs/` 已被 .gitignore 排除，不进入本仓库。

## 标准开发循环

每个功能单元都走这个循环，不许跳步：

```
1. declare 定接口（类型/函数签名）+ 写快照测试（先写失败用例）
2. 让 AI 实现
3. moon check → moon test → moon fmt
4. 全绿才 commit；快照变更必须在 commit message 里写明理由
```

- 测试放在 `*_test.mbt`，快照（golden file）放 `testdata/`
- 小步提交：一个 commit 只做一件事（feat/fix/test/docs/chore）
- 提交信息格式：`feat(tokenizer): support dollar-quoted strings`

## 上下文纪律

- 每次会话开始：先读 `PLAN.md` 的「进度记录」与当前里程碑任务清单，只做当前里程碑的事
- 不做 PLAN 中「非目标」清单里的事（多方言、执行器、完整语法覆盖）
- 方案级变化（改里程碑、改 scope）：先在 PLAN.md「决策日志」追加一条，再动手

## 版本与升级

- moon 版本记录在 PLAN.md「环境记录」；升级工具链/core 版本单独开分支验证，全量测试通过才合入

## 目录约定

```
moonbit-sqlfmt/
├── README.md / PLAN.md / AGENTS.md   # 本三件套
├── docs/                             # 查重、对拍差异、设计笔记
├── refs/                             # 只读参考源码（git 忽略）
├── src/                              # moon new 生成的包结构（M0 建立）
└── testdata/                         # 快照测试 golden files
```
