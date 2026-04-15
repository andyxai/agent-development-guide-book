---
title: "Best Practices for Claude Code"
author: "Anthropic"
source: "https://code.claude.com/docs/en/best-practices"
date: "2026-04-15"
tags: ["engineering", "claude-code", "context-management", "agent-patterns"]
related_chapters: ["06-01-Agent Engineering 最佳实践", "06-03-Vibe Coding 实践"]
summary: "Claude Code使用最佳实践，包括上下文窗口管理、验证机制、探索规划模式等"
---
Claude Code 是一个具备自主能力的编程环境。与仅能回答问题并等待指令的聊天机器人不同，Claude Code 可以读取你的文件、运行命令、进行修改，并在你注视、引导或完全离开的情况下自主解决问题。 这改变了你的工作方式。你不再需要自己编写代码并让 Claude 审阅，而是只需描述你的需求，Claude 就会找出构建它的方法。Claude 会进行探索、规划并完成实现。 但这种自主性仍需要一个学习过程。Claude 有一些你需要了解的限制条件。 本指南涵盖了已在 Anthropic 内部团队以及在不同代码库、编程语言和环境中使用 Claude Code 的工程师身上被证明行之有效的模式。有关智能体循环的底层工作原理，请参阅 [Claude Code 的工作原理](https://code.claude.com/docs/en/how-claude-code-works) 。

---

大多数最佳实践都基于一个限制条件：Claude 的上下文窗口会快速填满，且随着内容不断填充，其性能会下降。 Claude 的上下文窗口会保存你的整个对话，包括每一条消息、Claude 读取的所有文件以及每一条命令输出。不过，这个窗口很快就会被占满。一次简单的调试会话或代码库探索可能会生成并消耗数万个令牌。 这一点至关重要，因为随着上下文内容增多，大语言模型的性能会下降。当上下文窗口即将填满时，Claude 可能会开始“忘记”之前的指令，或出现更多错误。上下文窗口是需要重点管理的核心资源。要了解会话实际的填充情况，可查看 [交互式演示](https://code.claude.com/docs/en/context-window) ，了解启动时加载的内容以及读取每个文件的资源消耗。通过 [自定义状态栏](https://code.claude.com/docs/en/statusline) 持续跟踪上下文使用情况，同时可参考 [减少令牌使用](https://code.claude.com/docs/en/costs#reduce-token-usage) 获取降低令牌消耗的相关策略。

---

## 让 Claude 有办法验证其工作成果

附上测试用例、截图或预期输出，以便 Claude 自查。这是你能做的最具高杠杆作用的事。

当Claude能够验证自身工作（例如运行测试、对比截图和验证输出结果）时，其表现会显著提升。 如果没有明确的成功标准，它可能会产出一些看似正确但实际无法运行的内容。你会成为唯一的反馈环节，每一个错误都需要你的关注。

| 策略 | 之前 | 优化后 |
| --- | --- | --- |
| **提供验证标准** | *”实现一个验证电子邮件地址的函数”* | *编写一个 validateEmail 函数。示例测试用例： [user@example.com](mailto:user@example.com) 返回 true，无效邮箱返回 false， [user@.com](mailto:user@.com) 返回 false。实现后运行测试* |
| **直观地验证UI更改** | *“让仪表盘看起来更美观”* | *“\[粘贴截图\] 实现该设计。截取结果的截图并与原图对比，列出差异并修正”* |
| **解决根本问题，而非表面症状** | *”构建失败了”* | *“构建因以下错误而失败：\[粘贴错误信息\]。请修复该错误并验证构建成功。要解决根本原因，切勿屏蔽错误”* |

可以使用 [Claude 浏览器扩展](https://code.claude.com/docs/en/chrome) 来验证 UI 更改。它会在你的浏览器中打开新标签页，测试 UI 并不断迭代，直到代码正常运行。 你的验证机制也可以是测试套件、代码检查工具，或是用于检查输出的 Bash 命令。务必投入精力打造稳固可靠的验证机制。

---

## 先探索，再规划，再编写代码

将研究和规划与实施区分开来，以避免解决错误的问题。

让 Claude 直接上手编写代码可能会产出解决错误问题的代码。使用 [规划模式](https://code.claude.com/docs/en/common-workflows#use-plan-mode-for-safe-code-analysis) 将探索与执行分离开来。 推荐的工作流程包含四个阶段：

规划模式很有用，但也会增加额外开销。 对于范围明确且修改量小的任务（比如修正拼写错误、添加日志行或重命名变量），直接让 Claude 完成。 当你对方法不确定、修改涉及多个文件，或是不熟悉要修改的代码时，规划最为有用。如果你能用一句话描述出差异，就无需制定规划。

---

## 在提示中提供特定上下文

你的指令越精确，你需要进行的修正就越少。

Claude 可以推断意图，但无法读懂你的想法。请引用具体文件、说明限制并指出示例模式。

| 策略 | 之前 | 之后 |
| --- | --- | --- |
| 明确任务范围。</b>> 指定要处理的文件、具体场景以及测试偏好。 | *”为 foo.py 添加测试”* | *为 foo.py 编写一个测试，覆盖用户未登录的边界情况，避免使用模拟对象。* |
| **指向来源。** 将能回答问题的来源告知 Claude。 | *“为什么 ExecutionFactory 的 API 这么奇怪？”* | *“查看 ExecutionFactory 的 git 提交历史，并总结其 API 是如何形成的”* |
| **参考现有模式。** 将代码库中的模式指向 Claude。 | *“添加一个日历小部件”* | *“查看首页上现有组件的实现方式以理解其设计模式。HotDogWidget.php 是一个很好的示例。请按照该模式实现一个新的日历组件，允许用户选择月份，并通过向前/向后翻页来选定年份。请从零开始开发，除代码库中已使用的库外，不得使用其他任何库。”* |
| **描述症状。** 请说明症状、可能的发病部位以及“修复”后的表现。 | *”修复登录漏洞“* | *“用户反馈会话超时后登录失败。请检查 src/auth/ 中的认证流程，尤其是令牌刷新环节。编写一个能复现该问题的失败测试用例，然后修复问题”* |

在探索阶段且能够及时调整方向时，模糊的提示可能会很有用。像 `"what would you improve in this file?"` 这样的提示，可能会让你发现一些从未想过要去询问的问题。

### 提供丰富内容

使用 `@` 引用文件、粘贴截图/图片，或直接传输数据。

你可以通过多种方式向 Claude 提供丰富数据：
- **使用 `@` 引用文件** ，而不是描述代码的位置。Claude 会在回复前读取该文件。
- **直接粘贴图片** 。通过复制粘贴或拖放的方式将图片放入提示框中。
- **提供文档和 API 参考的链接** 。使用 `/permissions` 将常用域名加入白名单。
- **传入数据** ，运行 `cat error.log | claude` 以直接发送文件内容。
- **让 Claude 获取它所需的内容** 。让 Claude 使用 Bash 命令、MCP 工具或读取文件自行提取上下文。

---

## 配置你的环境

几个设置步骤能让 Claude Code 在你所有的会话中显著更高效。有关扩展功能的完整概述以及何时使用每项功能，请参阅 [扩展 Claude Code](https://code.claude.com/docs/en/features-overview) 。

### 撰写一份实用的 CLAUDE.md

运行 `/init` 可根据你当前的项目结构生成一个初始的 CLAUDE.md 文件，之后再逐步完善。

CLAUDE.md 是一个特殊文件，Claude 会在每次对话开始时读取该文件。文件中需包含 Bash 命令、代码规范以及工作流程规则，这能为 Claude 提供仅靠代码无法推断出的持久上下文信息。 `/init` 命令会分析你的代码库以检测构建系统、测试框架和代码模式，为你提供完善的坚实基础。 CLAUDE.md 文件没有强制格式要求，但请保持内容简短且易于阅读。例如：

```markdown
# Code style
- Use ES modules (import/export) syntax, not CommonJS (require)
- Destructure imports when possible (eg. import { foo } from 'bar')

# Workflow
- Be sure to typecheck when you're done making a series of code changes
- Prefer running single tests, and not the whole test suite, for performance
```

每次会话都会加载 CLAUDE.md，因此仅收录适用范围较广的内容。对于仅在特定情况下相关的领域知识或工作流，请改用 [技能](https://code.claude.com/docs/en/skills) 。Claude 会按需加载这些技能，不会让每次对话都变得臃肿。 保持简洁。针对每一行，询问： *“删除这一行会导致 Claude 出错吗？”* 如果不会，就删掉。内容冗余的 CLAUDE.md 文件会让 Claude 忽略你的真实指令！

| ✅ 保留 | ❌ 排除 |
| --- | --- |
| Claude 无法推测的 Bash 命令 | Claude 可通过阅读代码自行推断的内容 |
| 与默认设置不同的代码风格规则 | Claude 已熟知的标准语言规范 |
| 测试说明和首选测试运行器 | 详细的 API 文档（改为提供文档链接） |
| 代码仓库规范（分支命名、拉取请求约定） | 频繁更新的信息 |
| 针对你的项目的特定架构决策 | 冗长的解释或教程 |
| 开发者环境特性（所需环境变量） | 代码库的逐文件说明 |
| 常见的陷阱或不明显的行为 | 类似“编写整洁代码”这类不言而喻的准则 |

如果 Claude 明明有相关禁止规则却仍持续做出你不希望的行为，很可能是文件太长，导致规则被忽略了。如果 Claude 提出的问题在 CLAUDE.md 中已有答案，说明表述可能存在歧义。请将 CLAUDE.md 当作代码来对待：出现问题时对其进行审查，定期精简内容，并通过观察 Claude 的行为是否真的发生改变来测试修改效果。 你可以通过添加强调内容（例如“重要”或“你必须”）来优化指令，以提高执行依从性。将 CLAUDE.md 提交到 git 仓库，以便你的团队可以参与贡献。该文件的价值会随着时间的推移而不断累积。 CLAUDE.md 文件可使用 `@path/to/import` 语法导入其他文件：

```markdown
See @README.md for project overview and @package.json for available npm commands.

# Additional Instructions
- Git workflow: @docs/git-instructions.md
- Personal overrides: @~/.claude/my-project-instructions.md
```

你可以将 CLAUDE.md 文件放在多个位置：
- **主文件夹（ `~/.claude/CLAUDE.md` ）** ：适用于所有 Claude 会话
- **项目根目录（`./CLAUDE.md` ）** ：提交到 git 以便与团队共享
- **项目根目录（`./CLAUDE.local.md` ）** ：个人专属项目笔记；请将此文件添加到 `.gitignore` 中，避免与团队共享
- **父目录** ：适用于同时自动拉取 `root/CLAUDE.md` 和 `root/foo/CLAUDE.md` 的单体代码仓库
- **子目录** ：在处理这些目录中的文件时，Claude 会按需引入子目录中的 CLAUDE.md 文件

### 配置权限

使用 [自动模式](https://code.claude.com/docs/en/permission-modes#eliminate-prompts-with-auto-mode) 让分类器处理审批， `/permissions` 将特定命令加入白名单，或 `/sandbox` 实现操作系统级隔离。每种方式都能减少干扰，同时让你保持控制权。

默认情况下，Claude Code 会请求执行可能修改你系统的操作的权限：文件写入、Bash 命令、MCP 工具等。这种方式安全但繁琐。到第十次批准后，你实际上已经不再进行审核，只是在机械点击。有三种方法可以减少这类中断：
- **自动模式** ：一个独立的分类器模型会审查指令，仅拦截看似有风险的内容：权限范围扩大、未知基础设施或由恶意内容驱动的操作。当你信任任务的整体方向但又不想逐一点击每个步骤时，此模式为最佳选择
- **权限白名单** ：允许你确认安全的特定工具，比如 `npm run lint` 或 `git commit`
- **沙箱化** ：实现操作系统级别的隔离，限制文件系统和网络访问，让 Claude 能在既定边界内更自由地运行
了解更多关于 [权限模式](https://code.claude.com/docs/en/permission-modes) 、 [权限规则](https://code.claude.com/docs/en/permissions) 和 [沙箱化](https://code.claude.com/docs/en/sandboxing) 的内容。

### 使用命令行工具

告诉 Claude Code 在与外部服务交互时使用 `gh` 、 `aws` 、 `gcloud` 和 `sentry-cli` 等 CLI 工具。

CLI 工具是与外部服务交互的最上下文高效方式。如果你使用 GitHub，请安装 `gh` 命令行工具。Claude 知道如何使用它来创建议题、发起拉取请求和读取评论。没有 `gh` 的话，Claude 仍然可以使用 GitHub API，但未经验证的请求经常会触发速率限制。 Claude 还能高效学习它尚不熟悉的 CLI 工具。你可以尝试这样的提示： `Use 'foo-cli-tool --help' to learn about foo tool, then use it to solve A, B, C.`

### 连接 MCP 服务器

运行 `claude mcp add` 以连接外部工具，例如 Notion、Figma 或你的数据库。

借助 [MCP 服务器](https://code.claude.com/docs/en/mcp) ，你可以让 Claude 实现问题跟踪器中的功能、查询数据库、分析监控数据、整合 Figma 的设计内容并自动化工作流程。

### 设置钩子

将钩子用于那些必须每次都执行、毫无例外的操作。

[钩子](https://code.claude.com/docs/en/hooks-guide) 会在 Claude 工作流的特定节点自动运行脚本。与起提示作用的 CLAUDE.md 说明不同，钩子具有确定性，可确保指定操作必定执行。 Claude 可以为你编写钩子。尝试类似这样的提示： *“编写一个在每次文件修改后运行 eslint 的钩子”* 或 *“编写一个阻止对 migrations 文件夹进行写入的钩子”* 。直接编辑 `.claude/settings.json` 来手动配置钩子，并运行 `/hooks` 查看已配置的内容。

### 创建技能

在 `.claude/skills/` 目录下创建 `SKILL.md` 文件，为 Claude 提供领域知识和可复用的工作流。

[技能](https://code.claude.com/docs/en/skills) 可通过与你的项目、团队或领域相关的特定信息来扩展 Claude 的知识。Claude 会在相关场景下自动应用这些技能，你也可以直接通过 `/skill-name` 来调用它们。 创建技能的方法是在`.claude/skills/` 目录下添加一个包含 `SKILL.md` 文件的目录：

```markdown
---
name: api-conventions
description: REST API design conventions for our services
---
# API Conventions
- Use kebab-case for URL paths
- Use camelCase for JSON properties
- Always include pagination for list endpoints
- Version APIs in the URL path (/v1/, /v2/)
```

技能还可以定义可直接调用的可重复工作流：

```markdown
---
name: fix-issue
description: Fix a GitHub issue
disable-model-invocation: true
---
Analyze and fix the GitHub issue: $ARGUMENTS.

1. Use \`gh issue view\` to get the issue details
2. Understand the problem described in the issue
3. Search the codebase for relevant files
4. Implement the necessary changes to fix the issue
5. Write and run tests to verify the fix
6. Ensure code passes linting and type checking
7. Create a descriptive commit message
8. Push and create a PR
```

运行 `/fix-issue 1234` 来调用它。对于希望手动触发的带有副作用的工作流，请使用 `disable-model-invocation: true` 。

### 创建自定义子代理

在 `.claude/agents/` 中定义专用助手，供 Claude 委派给这些助手处理独立任务。

[子智能体](https://code.claude.com/docs/en/sub-agents) 在各自的上下文和允许的工具集中运行。它们适用于需要读取大量文件或需要专注处理的任务，同时不会让你的主对话变得杂乱。

```markdown
---
name: security-reviewer
description: Reviews code for security vulnerabilities
tools: Read, Grep, Glob, Bash
model: opus
---
You are a senior security engineer. Review code for:
- Injection vulnerabilities (SQL, XSS, command injection)
- Authentication and authorization flaws
- Secrets or credentials in code
- Insecure data handling

Provide specific line references and suggested fixes.
```

明确要求 Claude 使用子智能体： *“让子智能体检查这段代码的安全问题。”*

### 安装插件

运行 `/plugin` 浏览应用市场。插件可添加技能、工具和集成功能，无需配置。

[插件](https://code.claude.com/docs/en/plugins) 将技能、钩子、子智能体以及 MCP 服务器打包成来自社区和 Anthropic 的单一可安装单元。如果你使用的是类型化语言，请安装 [代码智能插件](https://code.claude.com/docs/en/discover-plugins#code-intelligence) ，以便 Claude 在编辑后能实现精准的符号导航和自动错误检测。 有关如何在技能、子智能体、钩子和 MCP 之间进行选择的指南，请参阅 [扩展 Claude 代码](https://code.claude.com/docs/en/features-overview#match-features-to-your-goal) 。

---

## 高效沟通

你与 Claude Code 的沟通方式会显著影响结果的质量。

### 询问代码库相关问题

向 Claude 提出你会向高级工程师询问的问题。

在熟悉新代码库时，可使用 Claude Code 进行学习和探索。你可以向 Claude 提出与询问其他工程师相同的各类问题：
- 日志系统是如何运作的？
- 我该如何创建一个新的API端点？
- `async move { ... }` 在 `foo.rs` 的第134行有什么作用？
- `CustomerOnboardingFlowImpl` 处理了哪些边缘情况？
- 为什么这段代码在第333行调用 `foo()` 而不是 `bar()` ？
以这种方式使用 Claude Code 是一种高效的入职工作流程，它能缩短上手时间并减轻其他工程师的工作负担。无需特殊提示，直接提问即可。

### 让 Claude 对你进行面试

对于更复杂的功能，先让 Claude 对你进行访谈。从一个简洁的提示开始，并要求 Claude 使用 `AskUserQuestion` 工具向你提问。

Claude 会询问你可能尚未考虑到的事项，包括技术实现、用户界面/用户体验、边缘情况以及权衡取舍。

```text
I want to build [brief description]. Interview me in detail using the AskUserQuestion tool.

Ask about technical implementation, UI/UX, edge cases, concerns, and tradeoffs. Don't ask obvious questions, dig into the hard parts I might not have considered.

Keep interviewing until we've covered everything, then write a complete spec to SPEC.md.
```

规范完成后，开启一个全新的会话来执行它。新会话拥有干净的上下文，完全聚焦于实现，同时你还有一份书面规范可供参考。

---

## 管理你的会话

对话具有持续性和可逆性。请善用这一特性！

### 尽早且频繁地纠正

一旦发现Claude偏离正轨，立即纠正它。

最佳的结果源自紧密的反馈循环。尽管 Claude 偶尔能在首次尝试中完美解决问题，但快速对其进行修正通常能更快得出更优的解决方案。
- **`Esc`** ：使用 `Esc` 键在 Claude 执行操作中途停止它。上下文会被保留，因此你可以重定向操作。
- **`Esc + Esc` 或 `/rewind`** ：按两次 `Esc` 或运行 `/rewind` 以打开倒回菜单，恢复之前的对话和代码状态，或从选定的消息进行总结。
- **`"Undo that"`** ：让 Claude 恢复其之前的修改。
- **`/clear`** ：在不相关的任务之间重置上下文。包含无关上下文的长会话可能会降低性能。
如果你在一次对话中就同一个问题纠正 Claude 超过两次，上下文就会充斥着失败的尝试。请运行 `/clear` 并重新开始，使用一个更具体、融入了你所学内容的提示词。一个干净的对话配合更优的提示词，几乎总是比一场积累了多次修正的冗长对话效果更好。

### 主动管理上下文

在不相关的任务之间运行 `/clear` 以重置上下文。

当接近上下文限制时，Claude Code 会自动精简对话历史，在保留重要代码和决策的同时释放空间。 在长时间的对话中，Claude 的上下文窗口可能会充斥着不相关的对话、文件内容和指令。这会降低其性能，有时还会让 Claude 分心。
- 在任务之间频繁使用 `/clear` 以完全重置上下文窗口
- 当自动压缩触发时，Claude 会总结最关键的内容，包括代码模式、文件状态和关键决策
- 如需更精确的控制，请运行 `/compact <instructions>` ，例如 `/compact Focus on the API changes`
- 若仅需精简部分对话，可使用 `Esc + Esc` 或 `/rewind` ，选择一条消息节点，然后点击 **从这里总结** 。该操作会精简该节点之后的消息，同时保留之前的上下文。
- 在 CLAUDE.md 中自定义压缩行为，可添加类似 `"When compacting, always preserve the full list of modified files and any test commands"` 的说明，以确保关键上下文在摘要中保留完整
- 对于无需保留上下文的快速问题，使用 [`/btw`](https://code.claude.com/docs/en/interactive-mode#side-questions-with-btw) 。答案会出现在可关闭的浮层中，且不会进入对话历史，因此你可以查看细节而不会增加上下文内容。

### 使用子代理进行调查

使用“使用子智能体调查 X”</b>的方式委派研究任务。子智能体会在独立的语境中展开探索，让你的主对话保持整洁以用于执行。

由于上下文是你的基本限制，子智能体是目前最强大的工具之一。当 Claude 研究代码库时，它会读取大量文件，所有这些文件都会占用你的上下文。子智能体在独立的上下文窗口中运行，并返回摘要：

```text
Use subagents to investigate how our authentication system handles token
refresh, and whether we have any existing OAuth utilities I should reuse.
```

子代理会探索代码库、阅读相关文件并反馈发现的内容，整个过程不会让你的主对话变得杂乱。 你也可以在 Claude 完成某项功能的实现后，使用子智能体进行验证：

```text
use a subagent to review this code for edge cases
```

### 通过检查点回退

Claude 执行的每一个操作都会创建一个检查点。你可以将对话、代码或两者恢复到任意之前的检查点。

Claude 会在修改前自动创建检查点。双击 `Escape` 或运行 `/rewind` 可打开回退菜单。你可以仅恢复对话、仅恢复代码、同时恢复两者，或从选定的消息开始总结。详细信息请参阅 [检查点功能](https://code.claude.com/docs/en/checkpointing) 。 你无需精心规划每一步，只需让 Claude 尝试一些有风险的操作。如果操作失败，就回退并换一种方法。检查点会在不同会话间保留，因此你可以关闭终端，之后仍能进行回退操作。

检查点仅跟踪 *Claude* 所做的更改，而非外部进程。这并非 git 的替代品。

### 恢复对话

运行 `claude --continue` 来继续之前的操作，或者使用 `--resume` 从最近的会话中选择。

Claude Code 会将对话本地保存。当一项任务跨越多个会话时，你无需重新解释上下文：

```shellscript
claude --continue    # Resume the most recent conversation
claude --resume      # Select from recent conversations
```

使用 `/rename` 为会话指定描述性名称，例如 `"oauth-migration"` 或 `"debugging-memory-leak"` ，以便日后查找。将会话视为分支：不同的工作流程可拥有独立且持久的上下文。

---

## 自动化与规模化

当你熟练使用一个 Claude 后，可通过并行会话、非交互模式和扇出模式来提升你的输出效率。 到目前为止，所有内容都假设只有一个人类、一个 Claude 以及一场对话。但 Claude Code 具备水平扩展的能力。本节中的技巧将向你展示如何完成更多任务。

### 运行非交互模式

在 CI、pre-commit 钩子或脚本中使用 `claude -p "prompt"` 。添加 `--output-format stream-json` 以获取流式 JSON 输出。

使用 `claude -p "your prompt"` ，你可以以非交互模式运行 Claude，无需开启会话。非交互模式是你将 Claude 集成到 CI 流水线、pre-commit 钩子或任何自动化工作流中的方式。输出格式支持以编程方式解析结果：纯文本、JSON 或流式 JSON。

```shellscript
# One-off queries
claude -p "Explain what this project does"

# Structured output for scripts
claude -p "List all API endpoints" --output-format json

# Streaming for real-time processing
claude -p "Analyze this log file" --output-format stream-json
```

### 运行多个 Claude 会话

并行运行多个 Claude 会话，以加快开发速度、开展独立实验或启动复杂工作流。

有三种主要的并行运行会话的方式：
- [Claude Code 桌面应用](https://code.claude.com/docs/en/desktop#work-in-parallel-with-sessions) ：可视化管理多个本地会话。每个会话都拥有独立的工作树。
- [网页版 Claude Code](https://code.claude.com/docs/en/claude-code-on-the-web) ：在 Anthropic 安全的云基础设施上于独立虚拟机中运行。
- [智能体团队](https://code.claude.com/docs/en/agent-teams) ：对多个会话进行自动化协调，包含共享任务、消息传递和团队负责人。
除了并行处理工作外，多会话还能支持以质量为核心的工作流程。全新的上下文能优化代码审查，因为 Claude 不会对刚编写的代码产生偏好。 例如，可采用编写者/审阅者模式：

| 会话A（撰写者） | 会话 B（审阅者） |
| --- | --- |
| `Implement a rate limiter for our API endpoints` |  |
|  | `Review the rate limiter implementation in @src/middleware/rateLimiter.ts. Look for edge cases, race conditions, and consistency with our existing middleware patterns.` |
| `Here's the review feedback: [Session B output]. Address these issues.` |  |

你也可以在测试上做类似的操作：让一个 Claude 编写测试，然后让另一个编写代码来通过这些测试。

### 跨文件展开

循环遍历任务，为每个任务调用 `claude -p` 。使用 `--allowedTools` 为批量操作限定权限范围。

对于大型迁移或分析任务，你可以将工作分配到多个并行的 Claude 调用中完成： 你还可以将 Claude 集成到现有的数据/处理流程中：

```shellscript
claude -p "<your prompt>" --output-format json | your_command
```

在开发过程中使用 `--verbose` 进行调试，并在生产环境中将其关闭。

### 自动模式下自主运行

要在后台安全检查的同时实现无中断执行，请使用 [自动模式](https://code.claude.com/docs/en/permission-modes#eliminate-prompts-with-auto-mode) 。分类器模型会在命令运行前对其进行审查，阻止权限提升、未知基础设施以及恶意内容驱动的操作，同时让日常工作无需提示即可正常进行。

```shellscript
claude --permission-mode auto -p "fix all lint errors"
```

对于使用 `-p` 标志的非交互式运行，如果分类器反复阻止操作，自动模式将中止，因为没有用户可以回退。有关阈值，请参见 [自动模式何时回退](https://code.claude.com/docs/en/permission-modes#when-auto-mode-falls-back) 。

---

## 规避常见的失败模式

这些都是常见的错误。尽早识别它们能节省时间：
- **厨房水槽式会话。** 你从一个任务开始，然后向 Claude 询问无关的内容，再回到第一个任务。上下文里全是不相关的信息。
	> **解决方法** ：在不相关的任务之间使用 `/clear` 。
- **反复纠正。** Claude 做错了某件事，你纠正它，它还是错的，你再纠正。上下文被错误的方法污染了。
	> **修复** ：两次修正失败后， `/clear` 并编写一个更好的初始提示词，融入你所学到的内容。
- **过于详细的 CLAUDE.md 文件。** 如果你的 CLAUDE.md 文件过长，Claude 会忽略其中一半内容，因为重要的规则会被大量无关信息淹没。
	> **修复** ：果断精简。如果 Claude 在没有指令的情况下就能正确完成某项操作，要么将其删除，要么将其转换为钩子。
- **先信任后验证的差距。** Claude 生成了一个看似合理的实现，但没有处理边缘情况。
	> **修复** ：始终提供验证（测试、脚本、截图）。如果无法验证，就不要发布。
- **无限探索。** 你让 Claude 去“调查”某件事却不设定范围。Claude 会阅读数百个文件，填充上下文。
	> **修复** ：缩小范围调查的范围，或使用子智能体，这样探索就不会占用你的主上下文。

---

## 培养直觉

本指南中的模式并非一成不变。它们是普遍适用的起点，但并非适用于所有情况的最优方案。 有时你 *应该* 让上下文不断累积，因为你正深陷一个复杂的问题，而其历史信息十分宝贵。有时你应该跳过规划，让 Claude 自主解决问题，因为任务具有探索性。有时一个模糊的提示恰好合适，因为你想先看看 Claude 如何解读问题，再对其进行限制。 关注有效的方法。当 Claude 输出出色的内容时，留意你做了什么：提示词结构、提供的上下文、所处的模式。当 Claude 表现不佳时，探究原因。是上下文过于杂乱？提示词太过模糊？还是任务对于单次处理来说过于庞大？ 久而久之，你会形成一种任何指南都无法涵盖的直觉。你会知道何时该具体、何时该开放式，何时该规划、何时该探索，何时该理清背景、何时该让背景不断积累。

## 相关资源

- [Claude Code 的工作原理](https://code.claude.com/docs/en/how-claude-code-works) ：智能体循环、工具与上下文管理
- [扩展 Claude Code](https://code.claude.com/docs/en/features-overview) ：技能、钩子、MCP、子智能体和插件
- [常见工作流程](https://code.claude.com/docs/en/common-workflows) ：用于调试、测试、代码审查等场景的分步操作指南
- CLAUDE.md</b>：存储项目约定和持久化上下文