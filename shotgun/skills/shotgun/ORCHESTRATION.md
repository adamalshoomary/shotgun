# Selective orchestration

Owner-approved defaults, revised 2026-09-15. These are working preferences. They install no
profiles, switch no models automatically, and guarantee no reduction in usage. Model choice,
delegation and review are defaults, and none of them is a mandatory stage. Choose the simplest
route that meets the authorized outcome, the constraints and the acceptance evidence.

## What delegation actually buys

A subagent runs in its own context window. Whatever it reads, greps, and discards stays in that
window, and the parent session receives only what the subagent returns. A subagent that spends
10,000 tokens reading twenty files and returns a 400-token answer keeps 9,600 tokens out of the
session that is making decisions.

The parent session therefore stays coherent for longer and reloads files less often. Across the
whole run, a subagent-heavy workflow can bill several times what one thread would have billed,
with published estimates around seven times for heavy use. Both figures are true at once, and they
answer different questions. Main-context economy is what buys quality on a long task. Total spend
is what shows up on the bill.

Two consequences, and the whole policy follows from them.

**Delegate the reading, keep the deciding.** Searching a codebase for every place a value is set,
checking twelve files against one rule, extracting the shape of an API from its documentation: work
whose input is large and whose output is small belongs in a subagent. Work whose output is as large
as its input belongs in the main session, because isolating it saves nothing and costs a handoff.

**A subagent that returns a wall of text has saved nothing.** Specify the return format before
spawning. A list of file paths. A table. A PASS or FAIL with one correction. If you cannot say in
advance what shape the answer takes, the task is not ready to delegate.

An orchestrator that delegates nothing is one agent with extra words in its prompt. If the work
ahead has no large-input, small-output component, run it in one session and say so.

## Choose the smallest useful execution mode

Use one agent by default. Delegate substantial bounded work, an independent task, or a consequential
review when the expected gain in quality, speed or main-context economy justifies the coordination.
State that reason in one sentence before spawning. Never delegate to fill a role. Parallel workers
need independent work and distinct write ownership; dependent stages wait for their prerequisites.

## Opening your own session

Addressed to the owner. Open whichever agent and model you prefer. Nothing in this
file has any authority over that choice, and no agent may change it or suggest
changing it unless you ask.

A recommendation, and only that. On Codex, GPT-6 Astra at Medium. On Claude Code,
Opus 5 at medium. A session that plans, asks questions, reviews work and decides what
happens next benefits from a judgement-tier model, and moderate effort is enough for
it, because the session is rarely the thing writing volume.

Everything below this line is addressed to the agent, and none of it applies to the
session you opened.

## Model preferences for subagents

Addressed to the agent. These rows cover work you delegate to a subagent during a
task. They say nothing about the session the owner opened, which is settled and not
yours to revisit.

| Delegated work | Codex | Claude Code |
| --- | --- | --- |
| Clear, substantial implementation | GPT-5.6 Terra, Medium | Sonnet 5, medium |
| Difficult debugging or complex implementation | GPT-5.6 Sol, Medium; raise reasoning when evidence warrants | Opus 5, high; raise to xhigh when evidence warrants |
| Important independent review | GPT-6 Astra, High | Opus 5, high, in a session that did not write the code |
| Narrow extraction, search fan-out, mechanical checks | GPT-5.6 Luna, Medium | Haiku 4.5 |

Codex model IDs: `gpt-6-astra`, `gpt-5.6-terra`, `gpt-5.6-sol`, `gpt-5.6-luna`.
Claude model IDs: `claude-opus-5`, `claude-sonnet-5`, `claude-haiku-4-5-20251001`.

Claude Code effort levels are low, medium, high, xhigh and max, set in a subagent
definition. Opus 5 defaults to high. Haiku 4.5 accepts no effort level; its speed is
the point. Claude Fable 5.1 exists and costs roughly double Opus 5 per token. Reach
for it only after Opus 5 at max has measurably fallen short on a specific task, and
record the comparison.

Request the model and the effort explicitly where the platform supports it, then verify
what actually ran. On any other platform, use the configured equivalent and disclose
material differences. Never silently substitute for a model the owner named.

### Claude Code specifics

The built-in `Explore` subagent covers search fan-out: it reads excerpts across many files and
returns findings. `Plan` covers design work. For an independent review, spawn a general-purpose
agent with `model: opus`, or open a fresh session, so the reviewer has not already convinced itself
the code is correct.

Skills, subagents and MCP servers solve different problems. A skill is instructions loaded on
demand into the current context. A subagent is a separate context with its own budget. Reach for a
skill when the agent needs to know something, and for a subagent when the agent needs to read a lot
and report a little.

## Brief, execute, review

Give each worker: the outcome and the reason for it, constraints and permissions, the files and
resources it owns, the minimum relevant context, acceptance checks, escalation conditions, and the
return format. Do not paste the parent conversation. Logs and exploration stay with the worker,
which returns a short result, a changed-file list, evidence links and any remaining uncertainty.

The leader reviews at meaningful checkpoints and leaves unfinished edits alone. Escalate changed
assumptions, changed scope, changed authority and real failures as soon as they appear. Keep the
user updated without importing intermediate output. One worker is usually enough. Add another only
for work that is independently useful. Use wait and notification tools where they exist, and stop
polling for status.

Run verification appropriate to the change and preserve the required acceptance checks. For
substantial or consequential work, prefer a fresh independent review when the risk it removes
justifies the effort. A finished stage is not on its own a reason for a reviewer, and a trivial
edit needs none. A reviewer returns PASS, FAIL with a concrete correction, or MISSING EVIDENCE.
Reviewers may write throwaway test files in a disposable workspace and may not edit the
implementation under review. Reviewers may challenge the leader's design.

## Recovery and efficiency

Before a temporary deployment or a change to live data, save a checkpoint in the task's existing
evidence record: the current version, the restoration source and path, the exact temporary changes
and data identifiers, what is proven and what is missing, and the next action including cleanup.
Update it the moment an identifier or a version becomes known. Chat history and an in-memory
variable both disappear at an interruption, so neither one holds a checkpoint. On resumption,
inspect the checkpoint and the real state before repeating work. Never record credentials or
customer content.

If an agent becomes unavailable, preserve the checkpoint and finish a small remainder with the
available agent when that is authorized, then report the change of executor. For a few substantial
tasks, record the execution choice, the models used, measured usage where the platform reports it,
any rework, and the acceptance result. Keep active work separate from waiting work. Never invent a
usage figure or a comparison against a solo run that nobody made. A cheaper model can cost less
while using more tokens, and a lower token count on its own proves nothing about quality. Add no
dashboard, memory service, profile, plugin or scheduler for the sake of this policy.

Sources for the delegation economics above: [Claude Code sub-agents
documentation](https://code.claude.com/docs/en/sub-agents), [The Orchestrator's
Dilemma](https://responseawareness.substack.com/p/claude-code-subagents-the-orchestrators),
[Subagents and context isolation](https://claude-world.com/tutorials/s04-subagents-and-context-isolation/).
