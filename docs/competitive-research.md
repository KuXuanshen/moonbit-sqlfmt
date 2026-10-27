# 生态查重清单（M1 第一项任务）

> 目的：确认「MoonBit 生态没有 SQL formatter/parser」这个前提仍然成立；若已撞车，启动差异化策略。
> 完成日期：（待填写）｜ 结论：（待填写：空位确认 / 已撞车+对策）

## 查重步骤

- [ ] Mooncakes.io（https://mooncakes.io）搜索关键词：`sql`、`sqlfmt`、`formatter`、`tokenizer`、`parser`、`postgres`
- [ ] 通读 https://github.com/moonbitlang/awesome-moonbit 全部分类
- [ ] GitHub 搜索：`moonbit language:moonbit sql`（topic / code 搜索）
- [ ] MoonBit 论坛（taolun.moonbitlang.com）与 Discord #showcase 频道搜「sql」

## 命名候选（按优先级）

1. `moonbit-sqlfmt`（repo 名）/ `sqlfmt.mbt`（包名）
2. `moonbit-pgfmt`（强调 PG 方向）
3. tokenizer 包独立命名：`sql-tokenizer.mbt` 或并入主包

## 若已撞车的差异化方向

| 差异点 | 说明 |
|---|---|
| PG 方言深度 | dollar-quoted、`::`、`E''`、`$n` 等原生支持，通用库通常缺 |
| 日志场景 | 面向「从日志里抠出的裸 SQL」的美化（容错半截语句） |
| 对拍质量 | 用 sql-formatter(JS) 官方样例做对拍，输出质量可验证 |
| lint 长线 | M3 的 AST → SQL lint，通用 formatter 不做 |

## 命中记录

（发现的相关包逐条记录：包名 / 维护者 / 最后更新 / 功能重叠度 / 差异化结论）
