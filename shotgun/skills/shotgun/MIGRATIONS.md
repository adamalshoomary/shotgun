# Migrations

`/shotgun update` works by comparing structure. It reads each file in `templates/`,
reads the project's corresponding file, and compares section headings, marker lines
and file presence. Anything the template carries and the project lacks is a feature
the project has not adopted yet.

That comparison stays correct without anybody maintaining it, because the templates
are the specification. Editing a template updates the check.

This file exists for the changes that comparison cannot see: a changed default, a
reordered reading list, a rewritten table, a rule whose wording matters. Most releases
add nothing here. Add a block only when you have asked yourself whether the heading
comparison would catch the change and the answer is no.

Human-facing release notes belong in the GitHub release, not here. Write these blocks
as instructions to an agent.

Format: one block per version, newest first. An agent reads only the blocks above the
version recorded in the project's AGENTS.md.

---

## 5.1.0 (2026-10-15)

**No project file changes.** The kit now checks for updates on the first `/shotgun`
command in each chat, and `/shotgun update` asks once for all changes. Set the version
line. Tell the owner in one sentence that the first command in each chat now checks
for updates.

---

## 5.0.0 (2026-10-15)

**Finished items leave the queue.** A done or rejected item moves, word for word, to
`project-context/done.md`. The queue keeps one line for it in a new `## Done` section
at the bottom. The heading comparison reports the missing `## Done` section. It cannot
see the items that must move, or the two AGENTS.md sentences below.

Move the items in this order:

1. List every task in improvement-plan.md whose status starts with done or rejected.
   A reason or a date after the status still moves, such as "rejected: merged into
   Q31". A status that says part of the work is still open stays, such as "done in
   software; hardware is Adam's". A deferred task stays.
2. Show the owner the list with each item's word count, and ask once before you move
   anything.
3. Count the words in improvement-plan.md before you change it.
4. Move each listed block unchanged to the end of `project-context/done.md`, in queue
   order. A block runs from its task heading to the next heading at the same level or
   higher. If no heading follows the last task, end its block before any paragraph
   that speaks about the whole queue. If the end is unclear, ask the owner. Create the
   file with the heading `# Done items` if it does not exist.
5. Count again. The words removed from the queue must equal the words in the moved
   blocks in `done.md`. If the counts differ, put the queue back and stop.
6. Add the `## Done` section from the template at the end of improvement-plan.md. Add
   one line for each moved item, oldest first by queue id.
7. Search the queue for links into a moved block, such as `#q12`. Point each one at
   `project-context/done.md`.

Leave everything else in the queue as it is, including preamble text the owner wrote
about finished items.

In AGENTS.md, two sentences are new. Show the owner the current paragraph and the
proposed paragraph side by side, then ask before you change either:

- After the startup reading paragraph: "Finished queue items live in
  `project-context/done.md`. Read it only for a concrete reason, such as a dependency
  on a finished item."
- In the Handoff section, after "link it under the task": "When an item reaches done
  or rejected, move it to `project-context/done.md` as the queue describes."

If you apply the AGENTS.md change below in the same update, skip these two sentences.
The new AGENTS.md and WORKFLOW.md already carry both.

**AGENTS.md is short, and the procedure moved to `project-context/WORKFLOW.md`.**
Claude Code and Codex load AGENTS.md into every session, and Claude Code's docs advise
under 200 lines. The heading comparison sees the new `## Start here`, `## Every turn`
and `## Project rules` headings. It cannot see which old text to remove.

1. Copy `<kit>/WORKFLOW.md` to `project-context/WORKFLOW.md` unchanged.
2. Count the lines of AGENTS.md.
3. Find the shotgun sections that WORKFLOW.md and the new template now cover: the
   unheaded paragraphs under the version line, including any `done.md` sentence that the
   queue part added, and `## Work`, `## Asking`,
   `## Writing`, `## Reporting to the owner`, `## Execution` and `## Handoff`. An
   owner may have renamed one, for example "Reporting to Adam". Match on meaning.
4. Read each of those sections sentence by sentence. A sentence is shotgun text when
   its rule appears in WORKFLOW.md or in the new template. Any other sentence is owner
   text.
5. Propose to replace those sections with the template's `## Start here` and
   `## Every turn` sections. Carry the owner text word for word into
   `## Project rules`.
6. In the version-line paragraph, `## Authority and permissions`,
   `## Environment and access`,
   `## Naming the chat` and `## Commits`, propose the template's shorter shotgun
   paragraphs. Keep every line the owner filled in, such as each Environment entry and
   the `Chat prefix:` line.
7. Add `## Project rules` at the end if the file has none.
8. Show the owner each section's current text and proposed text side by side. Ask once
   for each section.
9. Then list each owner section of about 20 lines or 300 words or more. Count words
   too, because some owners write a whole section on one line. Keep the Authority and
   Environment entries in their sections, however long they are. For each one, offer to move
   it word for word to its own file in `project-context/`, such as
   `project-context/publishing.md`, and leave a one-line link where it was. Ask once
   for each section.
10. Count the lines again. Report the count before and after, and whether the file is
    under 200 lines.

Never delete owner text. If a sentence could be either shotgun text or owner text,
treat it as owner text.

**Answers are recorded, and agents ask about every open decision.** The agent asks
about every decision still open, with the recommended option first and marked. Each
answer goes under its queue item in a "Decided with the owner" list,
with the date. The new AGENTS.md and WORKFLOW.md carry both rules. The queue template
gains a `Decided with the owner:` line in each task block. Do not add the line to
existing tasks during the update. The next question round on a task adds it.

**Learning mode is removed.** The `learn` and `explain` commands are gone, and so are
the kit's `LEARNING.md` and `ORCHESTRATION.md`. The heading comparison cannot report a
removal, so apply each step below. Show the owner each change and ask once for each.

1. In AGENTS.md, delete the `## Learning mode` section and its `Learning mode:` line.
2. In current-state.md, show the owner the "What just changed and why" section. It may
   hold text they want to keep. If they say yes, delete it.
3. In improvement-plan.md, delete the paragraph that begins "When the task reaches done
   and learning mode is on".
4. Delete `project-context/LEARNING.md` and `project-context/ORCHESTRATION.md`. If the
   owner edited `ORCHESTRATION.md`, for example with their own model choices, offer to
   move those lines word for word into `## Project rules` in AGENTS.md first.
5. Search AGENTS.md for links to either file, and for "learning mode". Propose a
   change for each line found.

Leave any `learning/` folder exactly as it is. It is the owner's history.

---

## 4.0.0 (2026-10-15)

**The command is now `/shotgun`.** It was `/handoff`. Codex users type `$shotgun`.
The skill installs to `~/.claude/skills/shotgun` and `~/.agents/skills/shotgun`.
The installer removes an old `handoff` skill folder only when its `SKILL.md` names
the shotgun repository.

**The version line is renamed.** In AGENTS.md, `Handoff system version:` becomes
`Shotgun version:`. The paragraph under it names `/handoff update`, which becomes
`/shotgun update`. Show the owner the current lines and the new lines side by side,
then ask before you change them.

Search the rest of the project's AGENTS.md for `/handoff`. Show each line that holds
it, propose the same line with `/shotgun`, and ask once for all of them.

**Updates come from GitHub releases.** The update check reads `VERSION` from the
latest release. A kit older than 4.0.0 reads it from the repository root, where it no
longer exists, so an old kit reports that it could not check. Tell the owner to
install again with the command in the README.

No other project file changes.

---

## 3.1 (2026-09-19)

**Chat naming is new.** AGENTS.md gains a `## Naming the chat` section holding a
`Chat prefix:` line. Ask the owner for a short project name, two words at most, and
write it there. The rule: name the chat as the session opens, rename it once when the
real subject is clear, then never again for the life of that chat. Where the platform
cannot set a title, the agent prints the name instead, on those same two occasions.

Why: every chat arrived called something like "handoff continuation", and a list of
forty of them was unusable. Naming twice and no more is the owner's own constraint: a
title that keeps moving is worse than a stale one, because he memorises a name, comes
back for it, and finds it gone. A chat covering three subjects keeps its second name.

---

## 3.0 (2026-09-19)

Three removals and one addition. This is the first release that takes things away, so
read all four points before presenting a plan.

**VOICE.md is gone from the system.** Delete the file from the project root and delete
the `## Voice` section from AGENTS.md. In its place the AGENTS.md template carries a
`## Writing` section holding one instruction: write plainly, short sentences, no jargon,
no term the owner has not used first.

Ask the owner before deleting their VOICE.md. Some of them wrote their own rules into
it and will want the text back, so show them the file and offer to move it somewhere the
system does not manage. Never delete it silently.

**Learning mode is on or off.** The `Learning mode:` line takes `on` or `off` in place
of `0`, `1` and `2`. A project recorded as `2` or `1` becomes `on`. A project recorded
as `0` becomes `off`. Level 2 no longer exists: an agent asks the owner nothing at the
close of a finished item. Ask during the work instead, when an answer would change what
gets built.

**The explanation moved into current-state.md.** The per-item explainer file is gone.
Add a `## What just changed and why` section to current-state.md, above
`## Limits and unresolved observations`. When an item is finished and learning mode is
on, rewrite that section in full so it explains that item to the owner, then say in one
sentence that it is there. It holds the most recent item and nothing before it.

Remove the `Explainer:` line from the queue's task block in improvement-plan.md, and
remove the paragraph telling an agent to replace it. Leave `Explainer:` lines already
written under finished tasks: they point at real files and are part of the record.

An existing `learning/` directory is the owner's history. Leave every file in it exactly
as it is, leave it out of the reading order, and tell the owner the system no longer
writes there. Do not migrate old explainers into current-state.md; that section holds one
item and merging years of them into it would defeat the change.

`templates/.gitignore.template` no longer ignores `learning/` or `VOICE.md`. A project
whose own .gitignore lists them can keep those lines, because the files may still exist.

**Reporting rules are new and they bind.** AGENTS.md gains a `## Reporting to the owner`
section, and the same rules sit in SKILL.md so they apply in a project set up before 3.0.
Report what someone can now do that they should not be able to do, or what the owner can
now do that they could not before. Six lines opens a session. No file paths, function
names or queue identifiers unless the owner asks or has to open something themselves.

Why all four: the owner of this project ran 2.x on real work for four days. He did not
read the explainer files, described the level 2 questions as a tax, and could not read a
session opener that was correct and dense. Each removal here is a feature that measured
worse than nothing.

---

## 2.9 (2026-09-15)

`/handoff update` now updates the kit before it updates the project. It fetches the
published `VERSION` over https, reports both numbers, shows the reinstall command and
waits for the owner. A failed fetch is reported as a failed check and never as proof the
kit is current.

It also handles a project recorded at a version newer than the installed kit, which it
previously had no rule for. It stops rather than downgrade. Where the project folder
itself holds `templates/` and `MIGRATIONS.md`, that project is the kit's own source and
is meant to run ahead, so the command says so and stops.

The README's Updating section was wrong: it told people to pull a copy of the repository,
which almost nobody has. It now covers `npx skills update -g` and how to check an install.

No project file changes.

---

## 2.8 (2026-09-15)

Nothing in a project changes. Everyone must reinstall.

Until now `install.sh` copied only `SKILL.md`, so Claude Code users got a skill with no
`VERSION`, no `templates/` and no `MIGRATIONS.md`. Every command that needs those failed
outside the kit's own folder. `SKILL.md` also referred to "the starter folder" without
ever saying where it was.

`SKILL.md` now opens by distinguishing the kit from the project and resolves the kit as
the directory holding itself, `${CLAUDE_SKILL_DIR}` in Claude Code. `install.sh` copies
the whole directory.

Tell the owner to run `npx skills add adamalshoomary-ctrl/shotgun` again, or
`sh install.sh` from a fresh clone. An agent whose kit directory holds only `SKILL.md`
must say so and stop rather than searching the disk.

---

## 2.7 (2026-09-15)

Distribution only. The repository gained `.claude-plugin/marketplace.json` and
`.claude-plugin/plugin.json`, so Claude Code users can install it with
`/plugin marketplace add adamalshoomary-ctrl/shotgun` and find it in the Discover tab.

`skills/handoff/SKILL.md` is a symlink to the root `SKILL.md`, which the plugin format
requires and the `npx skills` resolver does not. One real file, two paths to it, so
neither copy can drift from the other.

No project file changes, and nothing about the skill's behaviour changed.

---

## 2.6 (2026-09-15)

`project-context/LEARNING.md` must be replaced with the starter's copy. The level 2
question rules were rewritten after the questions failed on this project's own owner,
who could not follow them.

The old file said only to ask about judgement and consequence. The new one adds three
rules: ask about something the owner watched happen in the session, use the words used
at the time, and make the answer matter to them. It carries a worked pair showing the
same question asked badly and well, and it tells the agent what to do when the owner
cannot follow a question, which is to answer it themselves and log the cause.

No other project file changes.

---

## 2.5 (2026-09-15)

`SKILL.md` moved to the repository root so `npx skills add adamalshoomary-ctrl/shotgun`
resolves it. Nothing about the skill's content changed, and an existing install keeps
working. No project file changes.

---

## 2.4 (2026-09-15)

The skill moved from `.claude/skills/handoff/` to `skill/handoff/` in the repository,
and `install.sh` now copies it into `~/.claude/skills/` and `~/.agents/skills/` so
Claude Code, Codex and the other Agent Skills adopters all find it. Tell the owner to
run the installer once and restart their agent. Any old copy under a project's
`.claude/skills/handoff/` can be deleted; the installed personal copy replaces it.

The skill body no longer depends on `$0` substitution, which only Claude Code performs.
No project file changes.

---

## 2.3 (2026-09-15)

`project-context/ORCHESTRATION.md` was restructured and must be replaced with the
starter's copy. The old file mixed two decisions in one table: which agent and model
the owner opens, and which model an agent requests for a subagent. An agent reading
the old table could take a row about the owner's session as an instruction it was
meant to act on.

The new file splits them. One short section addressed to the owner, carrying a
recommendation and no authority. One table addressed to the agent, covering delegated
work only and saying so.

Tell the owner the rule in one sentence when you apply it: they open whatever agent
they want, and no agent may change that or suggest changing it unless asked.

No project file changes.

---

## 2.2 (2026-09-15)

AGENTS.md gains a `## Commits` section. The structure check finds it, and the wording
comes from the template unchanged.

The default changed. Agents no longer commit at all; the owner reads the diff and
writes the history. A project whose AGENTS.md already grants commit permission keeps
that grant, and you ask the owner whether they still want it before touching the line.
Show them the old wording and the new default side by side.

The attribution rule inside that section is neither a setting nor a question. Apply it
whatever the owner chooses about committing.

Say this to the owner in plain words when you apply it: a coding agent's own harness
often instructs it to add a `Co-Authored-By` trailer, which makes the model a visible
contributor on GitHub. This section overrides that instruction. Where earlier commits
already carry the trailer, offer to amend the recent ones, and tell them a force push
is needed for anything already pushed.

---

## 2.1 (2026-09-15)

The handoff files now stay out of the published repository by default. Copy
`templates/.gitignore.template` to the project root as `.gitignore` when the project
has none, and merge its entries when one exists. Ask the owner first, and tell them
what it costs: a collaborator cloning the remote receives no handoff files, and an
agent on another machine sees the current state only once file sync has finished.

Where the owner wants the repository to carry continuity for a team, uncomment the
four state files in that template and say so in the project's AGENTS.md Authority
section.

The startup reading target in the README moved from roughly 2,000 words to roughly
3,000. Nothing was cut to reach it. No project needs changing.

---

## 2.0 (2026-09-15)

Files to copy into the project if absent:

- `VOICE.md` at the project root. Ask the owner whether the shipped guide is theirs
  before leaving it in place.
- `project-context/LEARNING.md`
- `project-context/ORCHESTRATION.md`, replacing any 1.x copy. The 1.x version carried
  a Codex-only model table and no account of delegation cost.

Values the owner must choose, because no default is safe to assume:

- `Learning mode:` in AGENTS.md. Describe levels 0, 1 and 2 in one sentence each,
  then ask. The starter default is 2.
- Every line of the AGENTS.md Environment section. Ask; write "none" where the owner
  has no such access.

Do not backfill explainers for tasks completed before the upgrade. Offer
`/handoff explain <task-id>` for any single item the owner wants written up.

---

## 1.0 (2026-09-06)

First release. Four startup files, templates, ORCHESTRATION.md.
