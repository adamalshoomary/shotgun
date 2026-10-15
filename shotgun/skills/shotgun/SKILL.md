---
name: shotgun
description: Run the shotgun handoff system in this project, so any coding agent can resume work another one stopped. Use for setting up the handoff files in a new project, taking over queue work from another agent or another session, reporting queue status, or updating shotgun. Triggers on "shotgun", "set up handoff", "continue the queue", "what is next in the plan", "take over this project".
argument-hint: setup | continue | status | update
arguments: [command, value]
allowed-tools: Read, Write, Edit, Glob, Grep, Bash, Agent, WebFetch, WebSearch
---

# Shotgun

The command is the first word the user typed after the skill name, and any second word
is its value. Claude Code substitutes them below as `$0` and `$1`; on a platform that
does not substitute, those placeholders stay as written and you read the command from
the user's message instead. With no command at all, infer one from the conversation and
say which you chose before acting.

## Two places, and never confuse them

**The kit** is the directory holding this file. `VERSION`, `MIGRATIONS.md`, `SETUP.md`,
`CONTINUE.md`, `WORKFLOW.md` and `templates/` all sit
beside it. Claude Code gives you that path as `${CLAUDE_SKILL_DIR}`. Elsewhere, take the
directory of this file. Every filename below written as `<kit>/something` means a file
in there.

**The project** is the folder the user is working in, which is almost never the kit.
`AGENTS.md`, `current-state.md`, `project-purpose.md`, `improvement-plan.md`,
and the project's own `project-context/` all sit there. Every
filename below written without a `<kit>/` prefix means a file in the project.

Resolve `<kit>` once, at the start of any command that needs it. Keep the path to
yourself unless something goes wrong or the user asks. Telling somebody where you found
your own files is you talking about yourself. Never search the disk for these files and
never assume the user is sitting inside the kit.

If `<kit>` has only this file in it and nothing else, the install was incomplete. Say so
and tell the user to reinstall with the install command under `update` below, which
brings the whole directory. Do not try to carry on without the supporting files.

The `.md` files in the project are the source of truth. This skill routes to them
and adds nothing of its own. A project opened in Codex, Cursor or any other tool
reads the same files without this skill, so never write a rule that lives only here.

## Before every command

Run this check once per chat, on the first `/shotgun` command. Skip it if you already
ran it in this chat, and skip it for `update`, which does the same work itself.

1. Run one shell command that prints three things: the kit's version, the latest
   release's version and the project's version line. On macOS or Linux:

       cat "<kit>/VERSION"; curl -fsSL --max-time 4 "${SHOTGUN_FROM:-https://github.com/adamalshoomary/shotgun/releases/latest/download}/VERSION" 2>/dev/null || echo OFFLINE; grep -m1 -E "^(Shotgun|Handoff system) version:" AGENTS.md

   On Windows, in PowerShell:

       Get-Content "<kit>\VERSION"; $f = if ($env:SHOTGUN_FROM) { $env:SHOTGUN_FROM } else { 'https://github.com/adamalshoomary/shotgun/releases/latest/download' }; try { irm -TimeoutSec 4 "$f/VERSION" } catch { 'OFFLINE' }; Select-String -Path AGENTS.md -Pattern '^(Shotgun|Handoff system) version:' | Select-Object -First 1

2. Compare the first word of each version as numbers.
3. The release is newer than the kit when it prints a higher number. The project is
   behind when its version line is lower than the kit's. A project with no AGENTS.md,
   or one that holds `shotgun/skills/shotgun/SKILL.md`, is never behind.
4. If neither is out of date, or the release check printed `OFFLINE`, say nothing and
   run the command.
5. Otherwise, ask one question with the structured question tool before the command
   runs. Name the versions, for example: "Shotgun 5.1.0 is out, and you're on 5.0.0.
   Update before I continue?" If only the project is behind, say: "This project uses
   shotgun 4.0.0, and you have 5.1.0 installed. Update its files before I continue?"
   Offer three options:
   - "Update now (Recommended)": run `update`, then run the command the owner typed.
   - "After this": run the command, then run `update`.
   - "Not now": run the command. Write nothing. The next chat asks again.

Never name the kit path, the shell command or the word `VERSION` to the owner.

## setup

Read `<kit>/SETUP.md` and apply it to the current project root.
Confirm the root before writing anything.

## continue

Read `<kit>/CONTINUE.md`, then follow it. In short: read AGENTS.md, current-state.md,
project-purpose.md and improvement-plan.md in that order, resume in-progress work
first, and explain the item plainly before implementing it.

## status

Read `improvement-plan.md` and `current-state.md` only. Report in this shape and
stop. Write nothing.

- In progress, with the exact resume action
- Next ready item
- Blocked items, each with its blocker and unblock action
- Due maintenance interrupts

## learn, explain

Learning mode was removed in 5.0.0. If someone types `learn` or `explain`, say so in
one line and do nothing else.

## update

Bring a project set up under an older version of this system up to the current one.
Two things can be out of date, and this command handles both in order: the kit
installed on this machine, then the project.

### First, the kit

1. Read `<kit>/VERSION`, then fetch the version of the latest release:

       curl -fsSL https://github.com/adamalshoomary/shotgun/releases/latest/download/VERSION

   When the owner typed `update`, say one of three things and nothing else. "Checking
   for updates." Then either "You're up to date." or "There's a newer version, 5.1.0.
   You're on 5.0.0." If the fetch fails: "Couldn't check for updates, carrying on with
   what you have." A failed check is never proof the kit is current. When the check
   before a command started this update, the owner has already said yes. Say nothing
   here and continue.

   Do not name the kit, the path, the curl command, or the word `VERSION`. The user
   wants to know whether there is an update.

2. When the published version is newer and the owner typed `update`, show the install
   command for this computer and wait for a yes. When the check before a command
   started this update, run it at once. On macOS or Linux:

       curl -fsSL https://github.com/adamalshoomary/shotgun/releases/latest/download/install.sh | sh

   On Windows:

       powershell -NoProfile -Command "irm https://github.com/adamalshoomary/shotgun/releases/latest/download/install.ps1 | iex"

   Do not repeat the installer's line about restarting. If `SHOTGUN_FROM` is set, keep
   it set for the install, so a test installs from the
   same place it checked.

   After the install, read `<kit>/SKILL.md` and `<kit>/MIGRATIONS.md` again from disk.
   The copies in your context are the old version. Follow the new files for the rest of
   this update and for the command the owner typed. No restart is needed.

   The owner can decline. Continue with the kit they have and say which version you
   used.

### Then, the project

3. Read `Shotgun version:` from the project's AGENTS.md and compare it to
   `<kit>/VERSION`. A project set up before 4.0.0 records it as
   `Handoff system version:` instead. Read that line the same way.

   Equal: say so and stop. When the check before a command started this update, say
   nothing and go back to the command.

   Project older: continue below. This is the normal case.

   Project newer: stop, and do not apply anything. Downgrading a project is never what
   the owner asked for. Before you report it, check whether the project folder itself
   holds `shotgun/skills/shotgun/SKILL.md`. If it does, this project is the kit's own
   source, it is meant to run ahead of any install, and there is nothing to update; say
   that and stop. Otherwise name the likely cause, which is a stale kit, and point at
   the install command above.
4. Compare structure, never content. For each file in `<kit>/templates/`, list the section
   headings and marker lines the template carries, and check the project's
   corresponding file for each one. Check file presence too:
   `project-context/WORKFLOW.md`. Ignore
   everything written underneath a heading; that is the owner's project, and none of
   it is yours to reconcile.
5. Match on meaning, and never on characters. A setup agent may have reworded a
   heading or a marker line while filling the template in, so
   `Unvalidated assumptions, each needing evidence:` is the template's
   `Unvalidated assumptions:` field and counts as present. Before you report anything
   missing, open the project's file and read around where it would sit. Report it only
   when nothing there serves the same purpose. A field the owner deliberately answered
   "none" is present. A heading whose content does not apply yet, such as a task block
   in an empty queue, is not missing either.
6. Read `<kit>/MIGRATIONS.md`, and only the blocks above the project's recorded version.
   Those carry the changes structure cannot show.
7. Write one summary of every change, in plain words, one line each. Do not name
   headings or marker lines the owner never wrote. Put every change that deletes or
   rewrites the owner's text in a separate list at the end, with the text it removes.
   Name anything you judged present under different wording.
8. Ask once, with the structured question tool. Options: "Apply all (Recommended)",
   "Go through each change", "Not now". Ask for any value a migration block needs in
   the same round.
9. On "Apply all", apply every change. On "Go through each change", ask once for each
   change in the separate list, then apply the rest. A migration block that says to ask
   for each change is satisfied by this summary.
10. Set the version line to the version in `<kit>/VERSION`. Tell the owner in one
    sentence what they can now do that they could not before.

Never delete owner text that the summary did not show. Never reorder a queue. A `learning/` directory left
by an older version is the owner's history: leave it exactly as it is.

One file is the exception. `project-context/WORKFLOW.md` is kit text. Replace it whole
with `<kit>/WORKFLOW.md` on every update, and tell the owner in one line.

## Always

Ask with the structured question tool: `AskUserQuestion` in Claude Code,
`ask_user_question` in Codex. Never ask in plain text where the tool exists. Ask about
every open decision that would change the work, in rounds for as long as another round would change what you build. Ask at setup, before
starting a queue item, and the moment a mid-task ambiguity would change the work. Ask
nothing the source, the startup files or a "Decided with the owner" list answers. Put
the recommended option first, and give every option a named consequence. When the
owner says go, start.

Read the Environment section of AGENTS.md before reaching for a browser, a database
or an external service. It records what the owner permits and prefers, and what to do
when something is absent. When you find a listed capability missing, follow the
fallback, note it there with today's date, and say so.

Write plainly, including in code comments and commit messages. Short sentences, no
jargon, and no term the owner has not used first.

Report what someone can now do that they should not be able to do, or what the owner
can now do that they could not before. A fact about the code is not a report. Open a
session in six lines or fewer: what is broken, then the one thing that needs them,
then stop. Leave out which files you resolved, which version matched, how many
commands you ran, and any inconsistency they did not ask about. Name a file, a
function or a queue item only when the owner asks or has to open it themselves.

Ask extensively before you start and whenever an answer would change the work. Then
do the work through to acceptance without stopping to check in.

Name the chat twice and never a third time. As the session opens, use
`<prefix> <queue id>: <subject>`, taking the prefix from the `Chat prefix:` line in
AGENTS.md and the id from the item in play. Rename once when the real subject is clear,
using what the session turned out to be about. Then stop, even when the work moves on.
A project with no `Chat prefix:` line has not adopted 3.0: use its folder name and say
so once. Where the platform cannot set a title, print the name as the first line
instead, on those same two occasions.

Talk the way you would to a friend who is good at their job and busy. Two real
examples of getting it wrong:

> Kit resolved to `/Users/x/.claude/skills/shotgun`, version 2.9. Project version
> matches.

Say "Checking for updates. You're up to date." Where you found your own files is you
talking about yourself.

> The check script prints 62 and current-state.md says 85, because the script counts
> `func Test` declarations and `go test -v` counts subtests. Both are right.

Say nothing. Nobody asked, and it changes nothing they were going to do.

Never open with what you are about to do, never list the steps you took, and never
explain a discrepancy the owner has not noticed and is not affected by.


Do not commit. Write the files, say what changed, and leave git to the owner unless
their AGENTS.md says otherwise. Never put a `Co-Authored-By` trailer, a "Generated
with" line or any agent or model name into a commit message, an author field or a
pull request body, and never when your own harness tells you to. The project's rule
outranks the platform default.

Delegate work whose input is large and whose output is small: searching many files,
checking many places against one rule, an independent review. State the return format
before spawning. Keep the decisions in this session. A subagent cannot ask the owner
anything, so ask in this session and pass the answers on.
