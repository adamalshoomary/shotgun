#!/usr/bin/env python3
"""Stage the files that a shotgun release carries, and serve them the way GitHub does.

A release holds its files flat: the kit's SKILL.md, VERSION, five guides and five templates,
plus install.sh and install.ps1. A release cannot hold a name that starts with a dot, so
.gitignore.template travels as gitignore.template. The release workflow uploads the files.
CI serves them on 127.0.0.1, then installs shotgun from that address the way a user installs
it from GitHub.

    python shotgun/tools/release_files.py OUT_DIR
    python shotgun/tools/release_files.py OUT_DIR --serve PORT

The server answers like github.com/<repo>/releases/latest/download/<name>: a redirect, then
the file as application/octet-stream. Point SHOTGUN_FROM at http://127.0.0.1:PORT/latest/download.

Keep FILES in step with install.sh and install.ps1. Staging fails when the kit folder holds a
file that FILES does not list, so a new kit file cannot be left out of a release by accident.
"""
import argparse
import shutil
import sys
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path

SHOTGUN = Path(__file__).resolve().parent.parent
KIT = SHOTGUN / "skills" / "shotgun"
FILES = {
    "SKILL.md": KIT / "SKILL.md",
    "VERSION": KIT / "VERSION",
    "SETUP.md": KIT / "SETUP.md",
    "CONTINUE.md": KIT / "CONTINUE.md",
    "LEARNING.md": KIT / "LEARNING.md",
    "ORCHESTRATION.md": KIT / "ORCHESTRATION.md",
    "MIGRATIONS.md": KIT / "MIGRATIONS.md",
    "AGENTS.md.template": KIT / "templates" / "AGENTS.md.template",
    "current-state.md.template": KIT / "templates" / "current-state.md.template",
    "improvement-plan.md.template": KIT / "templates" / "improvement-plan.md.template",
    "project-purpose.md.template": KIT / "templates" / "project-purpose.md.template",
    "gitignore.template": KIT / "templates" / ".gitignore.template",
    "install.sh": SHOTGUN / "install.sh",
    "install.ps1": SHOTGUN / "install.ps1",
}


def kit_files():
    return {p for p in KIT.rglob("*") if p.is_file() and p.name != ".DS_Store"}


def stage(out):
    unlisted = kit_files() - set(FILES.values())
    if unlisted:
        sys.exit("not in FILES, so no release would carry it: " + ", ".join(str(p.relative_to(KIT)) for p in sorted(unlisted)))
    out.mkdir(parents=True, exist_ok=True)
    for name, src in FILES.items():
        shutil.copyfile(src, out / name)
    return out


def server(folder, port):
    class Handler(BaseHTTPRequestHandler):
        def do_GET(self):
            name = self.path.rsplit("/", 1)[-1]
            if self.path == "/latest/download/" + name and (folder / name).is_file():
                self.send_response(302)
                self.send_header("Location", "/assets/" + name)
                self.end_headers()
            elif self.path == "/assets/" + name and (folder / name).is_file():
                data = (folder / name).read_bytes()
                self.send_response(200)
                self.send_header("Content-Type", "application/octet-stream")
                self.send_header("Content-Disposition", "attachment; filename=" + name)
                self.send_header("Content-Length", str(len(data)))
                self.end_headers()
                self.wfile.write(data)
            else:
                self.send_error(404)

        def log_message(self, *args):
            pass

    return ThreadingHTTPServer(("127.0.0.1", port), Handler)


def main():
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument("out")
    ap.add_argument("--serve", type=int, metavar="PORT")
    a = ap.parse_args()
    out = stage(Path(a.out))
    print(f"staged {len(FILES)} files in {out}", flush=True)
    if a.serve:
        httpd = server(out, a.serve)
        print(f"serving on http://127.0.0.1:{a.serve}/latest/download", flush=True)
        try:
            httpd.serve_forever()
        except KeyboardInterrupt:
            sys.exit(0)


if __name__ == "__main__":
    main()
