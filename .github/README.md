<div align="center">

# shotgun

**Any coding agent picks up where the last one stopped.**

Four plain files in your project hold the plan, the progress and the rules.

[![Release](https://img.shields.io/github/v/release/adamalshoomary/shotgun?label=release&color=2f6b4f)](https://github.com/adamalshoomary/shotgun/releases/latest)
[![Tests](https://img.shields.io/github/actions/workflow/status/adamalshoomary/shotgun/test.yml?label=tests)](https://github.com/adamalshoomary/shotgun/actions/workflows/test.yml)
[![Licence](https://img.shields.io/badge/licence-MIT-718096)](/shotgun/LICENSE)

<a href="https://adamalshoomary.github.io/shotgun/"><img src="/shotgun/site/install-button.svg" alt="Install in Claude Code" height="44"></a>

</div>

```
your-project/
├── AGENTS.md             the rules every agent follows
├── project-purpose.md    what you are building and for whom
├── current-state.md      what works now, and what does not yet
└── improvement-plan.md   the task queue
```

You need Claude Code, Codex or another agent that reads Agent Skills.

## Install

**1. Paste this into Claude Code.** This is the easiest way.

```
Install shotgun from https://github.com/adamalshoomary/shotgun.
```

Claude installs shotgun. Then follow [Use](#use) in a new chat.

**2. Or run one command.** On macOS or Linux, in Terminal:

```bash
curl -fsSL https://github.com/adamalshoomary/shotgun/releases/latest/download/install.sh | sh
```

On Windows, in PowerShell:

```powershell
irm https://github.com/adamalshoomary/shotgun/releases/latest/download/install.ps1 | iex
```

Then go to [Use](#use).

<details>
<summary>Other ways to install</summary>

**With Node.js**, on any system:

```bash
npx skills add adamalshoomary/shotgun -g
```

</details>

## Use

Open a new chat in your project folder. Then run this command:

```
/shotgun setup
```

The agent asks you about the project in a few rounds, then writes the four files. Start every later session with this command:

```
/shotgun continue
```

The agent reads the four files, finishes any task it left half done, and explains the next task before it starts. In Codex, type `$shotgun` in place of `/shotgun`.

Other commands:

- `/shotgun status` shows what is in progress, what is next and what is blocked.
- `/shotgun update` installs a newer shotgun and adds anything new to your project's files. It asks before it changes anything.

## Limits

- The four files stay out of your published repository by default. They reach your other computers only by iCloud, Dropbox or whatever syncs the folder.
- The agent asks a lot of questions before it starts work.
- Agents never commit for you, and never sign your commits with a model's name.

## For agents

If a user asks you to install shotgun from this page, follow these steps.

1. On macOS or Linux, run `curl -fsSL https://github.com/adamalshoomary/shotgun/releases/latest/download/install.sh | sh`.
2. On Windows, run `powershell -NoProfile -Command "irm https://github.com/adamalshoomary/shotgun/releases/latest/download/install.ps1 | iex"`.
3. Tell the user to restart their agent and open a new chat in their project folder.
4. Tell them to type `/shotgun setup`, or `$shotgun setup` in Codex.

## Licence

MIT. See [LICENSE](/shotgun/LICENSE).
