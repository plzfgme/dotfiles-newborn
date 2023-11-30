#!/usr/bin/env python3

import json
import subprocess
import sys


SWAYMSG_PATH = "swaymsg"
MAX_WORKSPACES = 10


def get_workspaces_no_print():
    return [
        {"id": int(w["name"]), "active": w["focused"]}
        for w in json.loads(
            subprocess.check_output([SWAYMSG_PATH, "-t", "get_workspaces"]).decode(
                "utf-8"
            )
        )
    ]


def get_workspaces():
    json.dump(
        get_workspaces_no_print(),
        sys.stdout,
    )


def get_active_workspace_no_print():
    return next(w["id"] for w in get_workspaces_no_print() if w["active"])


def get_active_workspace():
    print(get_active_workspace_no_print(), flush=True)


def change_workspace(id):
    subprocess.check_output([SWAYMSG_PATH, f"workspace {id}"])


def scroll_workspace(op):
    current_workspace = get_active_workspace_no_print()
    if op == "up":
        new_workspace = (
            current_workspace - 1 if current_workspace > 1 else MAX_WORKSPACES
        )
    elif op == "down":
        new_workspace = (
            current_workspace + 1 if current_workspace < MAX_WORKSPACES else 1
        )
    else:
        raise Exception("Invalid scroll operation")

    change_workspace(new_workspace)


def watch_workspace_updates():
    p = subprocess.Popen(
        [SWAYMSG_PATH, "-t", "subscribe", "-m", "['workspace']"],
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
    )

    while True:
        buf = ""
        while True:
            buf += p.stdout.readline().decode("utf-8")

            try:
                json.loads(buf)
            except json.JSONDecodeError:
                continue
            else:
                print(flush=True)
                break


if __name__ == "__main__":
    if sys.argv[1] == "get_workspaces":
        json.dumps(get_workspaces())
    elif sys.argv[1] == "get_active_workspace":
        get_active_workspace()
    elif sys.argv[1].startswith("change_workspace"):
        change_workspace(sys.argv[2])
    elif sys.argv[1].startswith("scroll_workspace"):
        scroll_workspace(sys.argv[2])
    elif sys.argv[1] == "watch_workspace_updates":
        watch_workspace_updates()
    else:
        print("Unknown subcommand")
        sys.exit(1)
