---
title: "Effective harnesses for long-running agents"
author: "Anthropic Engineering"
source: "https://www.anthropic.com/engineering/effective-harnesses-for-long-running-agents"
date: "2026-04-15"
tags: ["multi-agent", "harness-engineering", "context-management", "long-running-agents"]
related_chapters: ["06-02-Harness Engineering 驾驭工程", "03-03-多 Agent 协作系统"]
summary: "长时运行智能体解决方案：初始化智能体+编码智能体双模式，跨上下文窗口工作"
---
As AI agents become more capable, developers are increasingly asking them to take on complex tasks requiring work that spans hours, or even days. However, getting agents to make consistent progress across multiple context windows remains an open problem.随着AI智能体的能力不断增强，开发者越来越多地要求它们承担需要耗时数小时甚至数天的复杂任务。然而，让智能体在多个上下文窗口中保持稳定的进展，仍然是一个尚未解决的问题。

The core challenge of long-running agents is that they must work in discrete sessions, and each new session begins with no memory of what came before. Imagine a software project staffed by engineers working in shifts, where each new engineer arrives with no memory of what happened on the previous shift. Because context windows are limited, and because most complex projects cannot be completed within a single window, agents need a way to bridge the gap between coding sessions.长期运行智能体的核心挑战在于，它们必须在离散的会话中工作，且每个新会话开始时都没有之前的记忆。想象一个软件项目由轮班工作的工程师组成，每位新工程师到岗时都不记得上一班发生的事情。由于上下文窗口有限，且大多数复杂项目无法在单个窗口内完成，智能体需要一种方法来弥合编码会话之间的差距。

We developed a two-fold solution to enable the [Claude Agent SDK](https://platform.claude.com/docs/en/agent-sdk/overview) to work effectively across many context windows: an **initializer agent** that sets up the environment on the first run, and a **coding agent** that is tasked with making incremental progress in every session, while leaving clear artifacts for the next session. You can find code examples in the accompanying [quickstart.](https://github.com/anthropics/claude-quickstarts/tree/main/autonomous-coding)我们开发了一套双重解决方案，以实现 [Claude 智能体软件开发工具包](https://platform.claude.com/docs/en/agent-sdk/overview) 在众多上下文窗口中高效运行：一是 **初始化智能体** ，负责在首次运行时搭建运行环境；二是 **编码智能体** ， tasked 以在每次会话中逐步推进任务，同时为下一次会话留下清晰的中间产物。你可以在配套的 [快速入门指南](https://github.com/anthropics/claude-quickstarts/tree/main/autonomous-coding) 中找到代码示例。

## The long-running agent problem 长时运行智能体问题

The Claude Agent SDK is a powerful, general-purpose agent harness adept at coding, as well as other tasks that require the model to use tools to gather context, plan, and execute. It has context management capabilities such as compaction, which enables an agent to work on a task without exhausting the context window. Theoretically, given this setup, it should be possible for an agent to continue to do useful work for an arbitrarily long time.Claude Agent SDK 是一款功能强大的通用智能体工具包，不仅擅长编码，还能胜任其他需要模型借助工具收集上下文、制定计划并执行的任务。它具备压缩等上下文管理功能，可让智能体在执行任务时不会耗尽上下文窗口。从理论上讲，基于这一配置，智能体有望持续开展有价值的工作，且时间可无限延长。

However, compaction isn’t sufficient. Out of the box, even a frontier coding model like Opus 4.5 running on the Claude Agent SDK in a loop across multiple context windows will fall short of building a production-quality web app if it’s only given a high-level prompt, such as “build a clone of [claude.ai](http://claude.ai/redirect/website.v1.170892e1-6a87-42f0-a44f-145133230533).” 然而，压缩并不足以解决问题。默认情况下，即便像 Opus 4.5 这样的前沿编码模型在 Claude Agent SDK 上跨多个上下文窗口循环运行，若仅收到“构建一个 [claude.ai](http://claude.ai/redirect/website.v1.170892e1-6a87-42f0-a44f-145133230533) 的克隆版”这类高级提示，也无法打造出符合生产级标准的网络应用。

Claude’s failures manifested in two patterns. First, the agent tended to try to do too much at once—essentially to attempt to one-shot the app. Often, this led to the model running out of context in the middle of its implementation, leaving the next session to start with a feature half-implemented and undocumented. The agent would then have to guess at what had happened, and spend substantial time trying to get the basic app working again. This happens even with compaction, which doesn’t always pass perfectly clear instructions to the next agent.Claude的失误呈现出两种模式。首先，该智能体往往试图一次性完成过多任务——本质上是想一步到位地完成整个应用程序的开发。这种做法常常导致模型在实现过程中途耗尽上下文，使得下一个会话启动时，某个功能只完成了一半且没有相关文档记录。随后，该智能体不得不猜测之前发生了什么情况，并花费大量时间重新让应用程序的基础功能正常运行。即便使用了压缩（compaction）技术，这种情况依然会发生，因为压缩并不总能向后续智能体传递完全清晰的指令。

A second failure mode would often occur later in a project. After some features had already been built, a later agent instance would look around, see that progress had been made, and declare the job done.第二种故障模式通常会在项目后期出现。在部分功能已经开发完成后，后续的智能体实例会环顾四周，发现已有进展，便宣告任务完成。

This decomposes the problem into two parts. First, we need to set up an initial environment that lays the foundation for *all* the features that a given prompt requires, which sets up the agent to work step-by-step and feature-by-feature. Second, we should prompt each agent to make incremental progress towards its goal while also leaving the environment in a clean state at the end of a session. By “clean state” we mean the kind of code that would be appropriate for merging to a main branch: there are no major bugs, the code is orderly and well-documented, and in general, a developer could easily begin work on a new feature without first having to clean up an unrelated mess.这将问题分解为两个部分。首先，我们需要搭建一个初始环境，为给定提示所需的 *所有* 功能奠定基础，从而让智能体能够按步骤、按功能逐步开展工作。其次，我们需要提示每个智能体朝着目标取得渐进式进展，同时在每个会话结束时将环境恢复至干净状态。这里所说的“干净状态”，指的是适合合并到主分支的代码：不存在重大漏洞，代码结构规整且文档完善，总体而言，开发人员无需先清理无关的杂乱内容，就能轻松着手开发新功能。

When experimenting internally, we addressed these problems using a two-part solution:在内部实验中，我们通过一个两部分的解决方案解决了这些问题：

1. Initializer agent: The very first agent session uses a specialized prompt that asks the model to set up the initial environment: an `init.sh` script, a claude-progress.txt file that keeps a log of what agents have done, and an initial git commit that shows what files were added.初始化智能体：首个智能体会话会使用一个专门的提示词，要求模型搭建初始环境：一个 `init.sh` 脚本、一个用于记录智能体操作日志的claude-progress.txt文件，以及一个显示已添加文件的初始git提交记录。
2. Coding agent: Every subsequent session asks the model to make incremental progress, then leave structured updates.<sup>1</sup> 编码智能体：每个后续会话都要求模型取得渐进式进展，然后输出结构化的更新。1

The key insight here was finding a way for agents to quickly understand the state of work when starting with a fresh context window, which is accomplished with the claude-progress.txt file alongside the git history. Inspiration for these practices came from knowing what effective software engineers do every day.这里的核心见解是找到一种方法，让智能体在开启全新的上下文窗口时，能够快速了解工作状态——这一点通过配合 git 历史记录的 claude-progress.txt 文件得以实现。这些实践的灵感来源于了解优秀的软件工程师每天都在做什么。

## Environment management 环境管理

In the updated [Claude 4 prompting guide](https://docs.claude.com/en/docs/build-with-claude/prompt-engineering/claude-4-best-practices#multi-context-window-workflows), we shared some best practices for multi-context window workflows, including a harness structure that uses “a different prompt for the very first context window.” This “different prompt” requests that the initializer agent set up the environment with all the necessary context that future coding agents will need to work effectively. Here, we provide a deeper dive on some of the key components of such an environment.在更新后的 [Claude 4 提示词指南](https://docs.claude.com/en/docs/build-with-claude/prompt-engineering/claude-4-best-practices#multi-context-window-workflows) 中，我们分享了多上下文窗口工作流的一些最佳实践，其中包括一种采用“为首个上下文窗口使用不同提示词”的框架结构。这个“不同的提示词”要求初始化智能体为后续编码智能体高效工作所需的所有必要上下文搭建好环境。在此，我们将深入探讨此类环境的一些关键组成部分。

### Feature list 功能列表

To address the problem of the agent one-shotting an app or prematurely considering the project complete, we prompted the initializer agent to write a comprehensive file of feature requirements expanding on the user’s initial prompt. In the [claude.ai](http://claude.ai/redirect/website.v1.170892e1-6a87-42f0-a44f-145133230533) clone example, this meant over 200 features, such as “a user can open a new chat, type in a query, press enter, and see an AI response.” These features were all initially marked as “failing” so that later coding agents would have a clear outline of what full functionality looked like.为解决智能体一次性完成某个应用功能或过早认定项目已完成的问题，我们让初始化智能体撰写一份全面的功能需求文件，对用户的初始提示进行扩展。在 [claude.ai](http://claude.ai/redirect/website.v1.170892e1-6a87-42f0-a44f-145133230533) 克隆案例中，这意味着要列出200多项功能，例如“用户可以打开新聊天、输入查询内容、按下回车键并查看人工智能的回复”。这些功能最初都被标记为“未完成”，以便后续的编码智能体能清晰了解完整功能的实现标准。

```
{
    "category": "functional",
    "description": "New chat button creates a fresh conversation",
    "steps": [
      "Navigate to main interface",
      "Click the 'New Chat' button",
      "Verify a new conversation is created",
      "Check that chat area shows welcome state",
      "Verify conversation appears in sidebar"
    ],
    "passes": false
  }
```

We prompt coding agents to edit this file only by changing the status of a passes field, and we use strongly-worded instructions like “It is unacceptable to remove or edit tests because this could lead to missing or buggy functionality.” After some experimentation, we landed on using JSON for this, as the model is less likely to inappropriately change or overwrite JSON files compared to Markdown files.我们提示编码代理仅通过修改 passes 字段的状态来编辑此文件，并使用措辞强硬的指令，例如“删除或编辑测试是不可接受的，因为这可能导致功能缺失或存在漏洞”。经过多次实验，我们最终选择使用 JSON 来完成这项操作，因为与 Markdown 文件相比，模型不太可能不当修改或覆盖 JSON 文件。

### Incremental progress 渐进式进展

Given this initial environment scaffolding, the next iteration of the coding agent was then asked to work on only one feature at a time. This incremental approach turned out to be critical to addressing the agent’s tendency to do too much at once.基于这一初始环境搭建，编码智能体的下一个迭代版本随后被要求一次只处理一个功能。事实证明，这种增量式方法对于纠正智能体一次处理过多任务的倾向至关重要。

Once working incrementally, it’s still essential that the model leaves the environment in a clean state after making a code change. In our experiments, we found that the best way to elicit this behavior was to ask the model to commit its progress to git with descriptive commit messages and to write summaries of its progress in a progress file. This allowed the model to use git to revert bad code changes and recover working states of the code base.即使采用增量式的工作方式，模型在完成代码修改后将环境恢复到干净状态仍然至关重要。在实验中，我们发现引导模型实现这一行为的最佳方法是让其将进度提交到git仓库并附上描述性的提交信息，同时在进度文件中记录工作进展总结。这使得模型能够利用git回滚错误的代码修改，并恢复代码库的可用状态。

These approaches also increased efficiency, as they eliminated the need for an agent to have to guess at what had happened and spend its time trying to get the basic app working again.这些方法还提高了效率，因为它们消除了智能体必须猜测发生了什么情况、并花费时间尝试让基础应用恢复正常运行的需求。

### Testing 测试

One final major failure mode that we observed was Claude’s tendency to mark a feature as complete without proper testing. Absent explicit prompting, Claude tended to make code changes, and even do testing with unit tests or `curl` commands against a development server, but would fail recognize that the feature didn’t work end-to-end.我们观察到的最后一个主要故障模式是，Claude 倾向于在未进行适当测试的情况下将功能标记为已完成。在没有明确提示的情况下，Claude 往往会进行代码修改，甚至会针对开发服务器使用单元测试或 `curl` 命令进行测试，但却无法意识到该功能无法端到端正常运行。

In the case of building a web app, Claude mostly did well at verifying features end-to-end once explicitly prompted to use browser automation tools and do all testing as a human user would. 在构建网络应用程序的情况下，一旦明确提示 Claude 使用浏览器自动化工具并像人类用户一样进行所有测试，它在端到端验证功能方面大多表现良好。

![ Screenshots taken by Claude through the Puppeteer MCP server as it tested the claude.ai clone. ](https://www.anthropic.com/_next/image?url=https%3A%2F%2Fwww-cdn.anthropic.com%2Fimages%2F4zrzovbb%2Fwebsite%2Ff94c2257964fb2d623f1e81f874977ebfc0986bc-1920x1080.gif&w=3840&q=75)

Screenshots taken by Claude through the Puppeteer MCP server as it tested the claude.ai clone. Claude 通过 Puppeteer MCP 服务器在测试 claude.ai 克隆版时拍摄的截图。

Providing Claude with these kinds of testing tools dramatically improved performance, as the agent was able to identify and fix bugs that weren’t obvious from the code alone.为 Claude 配备这类测试工具后，其性能得到了显著提升，因为该智能体能够识别并修复那些仅从代码中难以发现的漏洞。

Some issues remain, like limitations to Claude’s vision and to browser automation tools making it difficult to identify every kind of bug. For example, Claude can’t see browser-native alert modals through the Puppeteer MCP, and features relying on these modals tended to be buggier as a result.仍存在一些问题，比如 Claude 的视觉功能存在局限，且浏览器自动化工具也难以识别各类漏洞。例如，Claude 无法通过 Puppeteer MCP 看到浏览器原生的警告弹窗，因此依赖这些弹窗的功能往往存在更多漏洞。

## Getting up to speed 快速上手

With all of the above in place, every coding agent is prompted to run through a series of steps to get its bearings, some quite basic but still helpful:在完成以上所有准备工作后，系统会提示每个编码智能体执行一系列步骤来明确自身的定位，其中一些步骤相当基础，但依然很有帮助：

1. *Run `pwd` to see the directory you’re working in. You’ll only be able to edit files in this directory.运行 `pwd` 查看你当前所在的目录。你只能编辑该目录下的文件。*
2. *Read the git logs and progress files to get up to speed on what was recently worked on.阅读 Git 日志和进度文件，了解最近的工作内容。*
3. *Read the features list file and choose the highest-priority feature that’s not yet done to work on.阅读功能列表文件，选择尚未完成的优先级最高的功能进行开发。*

This approach saves Claude some tokens in every session since it doesn’t have to figure out how to test the code. It also helps to ask the initializer agent to write an init.sh script that can run the development server, and then run through a basic end-to-end test before implementing a new feature.这种方法能让 Claude 在每次会话中节省一些令牌，因为它无需思考如何测试代码。此外，还有一个好处是可以让初始化代理编写一个能启动开发服务器的 init.sh 脚本，然后在实现新功能前完成一次基本的端到端测试。

In the case of the claude.ai clone, this meant that the agent always started the local development server and used the Puppeteer MCP to start a new chat, send a message, and receive a response. This ensured that Claude could quickly identify if the app had been left in a broken state, and immediately fix any existing bugs. If the agent had instead started implementing a new feature, it would likely make the problem worse.以 claude.ai 克隆应用为例，这意味着智能体总是先启动本地开发服务器，然后通过 Puppeteer MCP 开启新对话、发送消息并接收回复。这能确保 Claude 快速判断应用是否处于异常状态，并立即修复所有现存漏洞。而如果智能体转而着手开发新功能，问题很可能会进一步恶化。

Given all this, a typical session starts off with the following assistant messages:基于以上所有情况，一次典型的会话会以下列助手消息开头：

```
[Assistant] I'll start by getting my bearings and understanding the current state of the project.
[Tool Use] <bash - pwd>
[Tool Use] <read - claude-progress.txt>
[Tool Use] <read - feature_list.json>
[Assistant] Let me check the git log to see recent work.
[Tool Use] <bash - git log --oneline -20>
[Assistant] Now let me check if there's an init.sh script to restart the servers.
<Starts the development server>
[Assistant] Excellent! Now let me navigate to the application and verify that some fundamental features are still working.
<Tests basic functionality>
[Assistant] Based on my verification testing, I can see that the fundamental functionality is working well. The core chat features, theme switching, conversation loading, and error handling are all functioning correctly. Now let me review the tests.json file more comprehensively to understand what needs to be implemented next.
<Starts work on a new feature>
```

Agent failure modes and solutions 智能体故障模式与解决方案

| **Problem 问题** | **Initializer Agent Behavior 初始化智能体行为** | **Coding Agent Behavior 编码智能体行为** |
| --- | --- | --- |
| Claude declares victory on the entire project too early.Claude过早地宣布整个项目已完成。 | Set up a feature list file: based on the input spec, set up a structured JSON file with a list of end-to-end feature descriptions.创建功能列表文件：根据输入的规范，创建一个包含端到端功能描述列表的结构化 JSON 文件。 | Read the feature list file at the beginning of a session. Choose a single feature to start working on.在会话开始时阅读功能列表文件。选择一个单一功能开始着手工作。 |
| Claude leaves the environment in a state with bugs or undocumented progress.Claude 让环境处于存在漏洞或进度未被记录的状态。 | An initial git repo and progress notes file is written.会创建一个初始的 git 仓库和进度记录文件。 | Start the session by reading the progress notes file and git commit logs, and run a basic test on the development server to catch any undocumented bugs. End the session by writing a git commit and progress update.开始本次任务时，先阅读进度笔记文件和 git 提交日志，然后在开发服务器上运行基础测试，以发现任何未记录的 bug。结束本次任务时，撰写一次 git 提交记录和进度更新。 |
| Claude marks features as done prematurely.Claude 过早将功能标记为已完成。 | Set up a feature list file. 创建一个功能清单文件。 | Self-verify all features. Only mark features as “passing” after careful testing.自行核查所有功能。只有在经过仔细测试后，才能将功能标记为“通过”。 |
| Claude has to spend time figuring out how to run the app.Claude 得花时间弄清楚如何运行这个应用程序。 | Write an `init.sh` script that can run the development server.编写一个可以启动开发服务器的 `init.sh` 脚本。 | Start the session by reading `init.sh`.开始本次任务时，先阅读 `init.sh` 文件。 |

Summarizing four common failure modes and solutions in long-running AI agents.总结长时运行人工智能智能体的四种常见故障模式及解决方案

## Future work 未来工作

This research demonstrates one possible set of solutions in a long-running agent harness to enable the model to make incremental progress across many context windows. However, there remain open questions.这项研究展示了在长期智能体框架中一种可行的解决方案，可使模型在多个上下文窗口中实现渐进式进展。不过，目前仍存在一些尚未解决的问题。

Most notably, it’s still unclear whether a single, general-purpose coding agent performs best across contexts, or if better performance can be achieved through a multi-agent architecture. It seems reasonable that specialized agents like a testing agent, a quality assurance agent, or a code cleanup agent, could do an even better job at sub-tasks across the software development lifecycle.最值得注意的是，目前仍不清楚单一的通用型编码智能体在各类场景下是否能表现最佳，也不确定通过多智能体架构能否实现更优的性能。像测试智能体、质量保证智能体或代码清理智能体这类专用智能体，似乎更能在软件开发生命周期的子任务上表现得更为出色。

Additionally, this demo is optimized for full-stack web app development. A future direction is to generalize these findings to other fields. It’s likely that some or all of these lessons can be applied to the types of long-running agentic tasks required in, for example, scientific research or financial modeling.此外，本演示针对全栈 Web 应用开发进行了优化。未来的一个方向是将这些研究结论推广到其他领域。部分或全部这些经验很可能可应用于长期智能体任务类型，例如科学研究或金融建模中所需的任务。

### Acknowledgements 致谢

Written by Justin Young. Special thanks to David Hershey, Prithvi Rajasakeran, Jeremy Hadfield, Naia Bouscal, Michael Tingley, Jesse Mu, Jake Eaton, Marius Buleandara, Maggie Vo, Pedram Navid, Nadine Yasser, and Alex Notov for their contributions.本文由贾斯汀·杨撰写。特别感谢大卫·赫希、普里特维·拉贾萨克兰、杰里米·哈菲尔德、奈娅·布斯卡尔、迈克尔·廷利、杰西·穆、杰克·伊顿、马里乌斯·布伦达拉、玛吉·沃、佩德拉姆·纳维德、纳丁·亚塞尔以及亚历克斯·诺托夫所做出的贡献。

This work reflects the collective efforts of several teams across Anthropic who made it possible for Claude to safely do long-horizon autonomous software engineering, especially the code RL & Claude Code teams. Interested candidates who would like to contribute are welcome to apply at [anthropic.com/careers](http://anthropic.com/careers).这项工作凝聚了 Anthropic 旗下多个团队的共同努力，正是这些团队让 Claude 能够安全地开展长周期自主软件工程工作，其中代码强化学习团队与 Claude 代码团队贡献尤突出。有意加入并贡献力量的求职者，欢迎前往 [anthropic.com/careers](http://anthropic.com/careers) 申请。

1\. We refer to these as separate agents in this context only because they have different initial user prompts. The system prompt, set of tools, and overall agent harness was otherwise identical.1\. 在此语境下，我们将它们称为独立智能体，仅因为它们拥有不同的初始用户提示词。除此之外，系统提示词、工具集以及整体智能体框架完全一致。