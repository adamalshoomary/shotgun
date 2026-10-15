#!/usr/bin/env python3
"""Check that an installer left a working copy of shotgun in both skill folders.

CI runs this after install.sh and after install.ps1. It checks the home folder of the user
who runs it. Each skill folder must hold every file in this clone's kit folder, byte for
byte, and nothing else. An old "handoff" copy that names shotgun must be gone, and a
"handoff" skill from anyone else must still be there.

    python shotgun/tools/check_install.py
    python shotgun/tools/check_install.py --old-copies    also check the old handoff folders
"""
import argparse
import sys
from pathlib import Path

CLONE = Path(__file__).resolve().parent.parent / "skills" / "shotgun"
SKILLS = (Path.home() / ".claude" / "skills", Path.home() / ".agents" / "skills")


def files(folder):
    return {p.relative_to(folder).as_posix() for p in folder.rglob("*") if p.is_file() and p.name != ".DS_Store"}


def main():
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument("--old-copies", action="store_true")
    a = ap.parse_args()
    want = files(CLONE)
    for skills in SKILLS:
        kit = skills / "shotgun"
        got = files(kit) if kit.is_dir() else set()
        if want - got:
            sys.exit(f"{kit}: missing {', '.join(sorted(want - got))}")
        if got - want:
            sys.exit(f"{kit}: holds files the kit does not have: {', '.join(sorted(got - want))}")
        differ = [f for f in sorted(want) if (kit / f).read_bytes() != (CLONE / f).read_bytes()]
        if differ:
            sys.exit(f"{kit}: differs from this clone in {', '.join(differ)}")
        version = (kit / "VERSION").read_text(encoding="utf-8").split()[0]
        print(f"ok: {kit} holds shotgun {version}, {len(got)} files")
    if a.old_copies:
        # CI plants shotgun's old copy in ~/.claude and someone else's skill in ~/.agents.
        if (SKILLS[0] / "handoff").exists():
            sys.exit(f"{SKILLS[0] / 'handoff'}: the old shotgun copy is still there")
        if not (SKILLS[1] / "handoff" / "SKILL.md").is_file():
            sys.exit(f"{SKILLS[1] / 'handoff'}: another author's handoff skill was removed")
        print("ok: removed the old shotgun copy and kept the other handoff skill")


if __name__ == "__main__":
    main()
