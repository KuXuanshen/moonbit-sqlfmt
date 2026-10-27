# 参考源码（只读，不入库）

MoonBit 训练语料少，AI 辅助开发时这里的源码是 **API 的唯一事实来源**（规则见根目录 AGENTS.md）。

## 初始化

```bash
git clone https://github.com/moonbitlang/core refs/core
git clone https://github.com/moonbitlang/moonbit-docs refs/moonbit-docs
```

## 内容

| 目录 | 用途 |
|---|---|
| `core/` | MoonBit 标准库源码：写任何用到 core API 的代码前先读对应模块 |
| `moonbit-docs/` | 官方文档仓库：Tour、语言手册、构建系统（moon）、发布到 Mooncakes 的流程 |

## 更新

工具链升级后同步更新：

```bash
cd refs/core && git pull
cd refs/moonbit-docs && git pull
```
