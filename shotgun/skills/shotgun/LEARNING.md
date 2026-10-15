# Learning mode

Read this when you are about to write the explanation, and never as startup reading.

## What it is

Learning mode is on or off, recorded in AGENTS.md as `Learning mode: on`.

On: when a queue item reaches done, rewrite the "What just changed and why" section
of current-state.md so it explains that item to the owner, then tell them in one
sentence that it is there. Off: write nothing and say nothing.

One section, rewritten in full every time. It holds the most recent finished item and
nothing before it. No archive, no folder, no link to chase, and nothing accumulating
that the owner has to catch up on.

## Why it is shaped this way

Versions 2.1 through 2.9 wrote a separate file per item and linked it from the queue
in a line the owner did not read. Version 2.6 added a level that asked questions the
moment work ended, and the owner of this project described that as a tax and turned it
off. Both failed for the same reason: they arrived as extra work at the moment
somebody wanted to be finished.

An explanation sitting inside a file the owner already opens costs them nothing to
find. One sentence telling them it is there costs one sentence.

## What to write

Four things, in this order, and stop when they are covered.

**What the item was, in the owner's terms.** Not the task title. What they could not
do before and can do now, or what was wrong and is not.

**Why it was done this way.** The choice that mattered and the one you did not take.
This is the part worth the most and the part agents skip.

**What it cost.** A limit it introduced, a thing it made harder, a decision it locked
in. An explanation with no cost in it reads as an advertisement.

**Where it could bite.** The condition under which this breaks, in one sentence.

## How to write it

**Pitch it at the owner, never at the work.** This is the rule that gets broken. An
owner who cannot read code cannot answer a question phrased as a principle, and cannot
use an explanation phrased as one either. Write about the thing you both watched
happen.

**No term they have not used first.** If the concept needs a name they do not have,
describe it instead. Two extra sentences of plain description beat one correct term
they have to look up.

**Length follows the item.** A one-line fix gets a paragraph. A week of work gets a
page. An explanation longer than the work it describes is a sign you are explaining
your own effort.

**Concrete over general.** A count, a duration, the actual error, the thing that broke.
Somebody reading it in a month should be able to check it against the repository.

**Say what went wrong.** A mistake you made and corrected is the most useful sentence
in the whole section, and it is the one that makes the rest believable.

## What not to do

Do not ask the owner questions at the close of an item. Ask during the work, when an
answer would change what you build. An item that is finished has nothing left to ask
about.

Do not link away. The section is the whole explanation.

Do not keep the old one. The next item overwrites it. Where the owner wants the
history, the queue holds the evidence under each finished task, which is what the
queue is for.
