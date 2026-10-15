# Workflow

Read this file before you start a queue item. AGENTS.md holds the rules for every
turn. This file holds the rest. `/shotgun update` replaces this file whole, so put your
own rules in the Project rules section of AGENTS.md. A rule there wins over this file.

## Authority

Record each accepted change of scope or policy in the file that owns it. Source and
tests establish what is built. A live observation is true only for the version you
tested. If two sources disagree and you cannot settle it, record the contradiction.

## Work

1. Resume in-progress work first.
2. Otherwise, check due maintenance before normal work.
3. Then take the first ready item whose dependencies are met.
4. Explain the item's outcome, purpose and scope simply.
5. Wait for the owner to authorize it, unless they already did.
6. Then continue through acceptance without asking again for permission.

If an item is blocked, record the owner and the unblock action. Do not invent work.
Do not waive a requirement silently. If work is unnecessary, say so. Propose a change
before you weaken an acceptance check.

Prefer deletion, then simplification, then optimization, then automation.

Work slowly and at maximum quality. A correct result three turns later beats a fast
result the owner has to send back. Nothing here is a race.

## Asking

Before the first round, list for yourself every decision still open that would change
what you build. Leave out any decision recorded under "Decided with the owner". Ask
about all of them, up to four questions in a round. Put your recommended option first,
and mark it. Describe each option in the owner's terms, and never in terms of the code
or the kit. Read the answers, then ask follow-ups or the next round. Continue while another round would
change what you build. When you stop, say what you still do not know.

Record each answer at once under the queue item, in a list headed "Decided with the
owner", with the date. A later agent reads that list and asks none of it again.

Ask during setup, before you start a new queue item, and whenever an ambiguity would
change the work. Mid-task, ask as soon as you see the fork.

Read the source, the tests and the four startup files before you ask. Never ask what
they answer.

Give every option a consequence that you can name. "Which framework?" is a poor
question. "Which framework, and what each one costs in setup time and lock-in" is a
real one.

If the owner says go, proceed or just do it, treat that as the answer. State your
assumptions in one line and start.

## Environment

If the owner says their setup changed, update the Environment and access section of AGENTS.md
and nothing else.

## Naming the chat

Name the chat twice, then never again.

1. As the session opens, write `<prefix> <queue id>: <subject>`, for example
   `shotgun Q8: 3.0 removals`. If no item is in play, drop the id:
   `shotgun: picking what is next`.
2. When the real subject is clear, rename it once in the owner's words:
   `shotgun Q8: dropped the voice file`.
3. Keep that name for the life of the chat, even when the work moves on.

A title that keeps changing is worse than a stale one. The owner remembers a name,
comes back for it, and cannot find it. Use the prefix exactly as AGENTS.md writes it.
Three agents that chose "shotgun", "Shotgun starter" and "handoff-starter" for one
project made the chat list useless.

If the platform cannot set a title, print the name as the first line of the first
message. Print it again as the first line after the rename.

## Reporting

A fact about the code is not a report. "This function takes a raw byte slice and
checks only its length" is a fact about the code. "Anyone can forge an entry" is the
same fact told to the owner, and it is the only version they can act on.

An agent that shows its working is writing for itself. Talk the way you would to a friend who is good at their job and busy. Two real
examples of getting it wrong:

> Kit resolved to `/Users/x/.claude/skills/shotgun`, version 2.9. Project version
> matches.

Say "Checking for updates. You're up to date." Where you found your own files is you
talking about yourself.

> The check script prints 62 and current-state.md says 85, because the script counts
> `func Test` declarations and `go test -v` counts subtests. Both are right.

Say nothing. Nobody asked, and it changes nothing they were going to do.

Leave out which files you resolved, which version matched and how many commands you
ran. Never explain a discrepancy that the owner has not noticed and is not affected by.

## Execution

Use one agent by default. Delegate when work has a large input and a small output:
searching many files, checking many places against one rule, or an independent review.
State the return format before you start a subagent. Keep decisions in the main
session. A subagent cannot ask the owner anything. Ask in the main session, then pass
the answers to the subagent. If the owner named a model or an effort level, use it.

Models, delegation and review are defaults, and none of them is a mandatory stage.
Choose the simplest route that meets the authorized outcome, the constraints and the
acceptance evidence.

## Handoff

1. Mark an item done only when acceptance evidence exists.
2. Record detailed evidence once, and link it under the task.
3. When an item reaches done or rejected, move it to `project-context/done.md` as the
   queue describes.
4. Update current-state.md for each present fact that changed.
5. Mark a replaced decision as superseded. Keep unique historical proof.

For partial work, record these under the active task: the exact resume action, the
changed and uncommitted files, the failed and unrun checks, the blockers and any
external residue. An optional progress file is a short historical index. Never make
it a second status dashboard.

Before a temporary deployment or a change to live data, record a checkpoint in the
task's evidence: the current version, the restoration source, the temporary changes
and data ids, the missing proof, the next action and the cleanup. Record each
identifier as soon as you know it. Chat history and in-memory state disappear at an
interruption.
