#!/usr/bin/env python3

import json
from os import environ
import subprocess

WORKSPACE_TOOL_COMMAND = environ.get("WORKSPACE_TOOL_COMMAND")
if WORKSPACE_TOOL_COMMAND is None:
    raise Exception("WORKSPACE_TOOL_COMMAND not set")

WORKSPACE_ICON_PATHS = [
    "icons/edge.png",
    "icons/terminal.png",
    "icons/code.png",
    "icons/winWord.png",
    "icons/mail.png",
    "icons/xbox.png",
]
DEFAULT_WORKSPACE_ICON_PATH = "icons/code.png"


def get_workspaces():
    return json.loads(
        subprocess.check_output([WORKSPACE_TOOL_COMMAND, "get_workspaces"]).decode(
            "utf-8"
        )
    )


def get_active_workspace():
    return int(
        subprocess.check_output(
            [WORKSPACE_TOOL_COMMAND, "get_active_workspace"]
        ).decode("utf-8")
    )


def wrapper_box(slot):
    return f'(eventbox :onscroll "{WORKSPACE_TOOL_COMMAND} scroll_workspace {"{}"}" :class "workspaces" (box :space-evenly false :halign "end" {slot}))'


def workspace_entry(id, is_active=False):
    icon = (
        (
            f'(image :image-width 32 :image-height 32 :path "{WORKSPACE_ICON_PATHS[id-1]}")'
        )
        if id <= len(WORKSPACE_ICON_PATHS) and id > 0
        else f'(label :text "{id}")'
    )

    return f'(box :class "workspace-entry {"active" if is_active else ""}" (eventbox :width 42 :height 42 :onclick "{WORKSPACE_TOOL_COMMAND} change_workspace {id}" {icon}))'


def build_workspace_widget():
    # Workspaces that must be shown, even if they are empty
    workspaces = [{"id": i} for i in range(1, len(WORKSPACE_ICON_PATHS) + 1)]
    current_workspaces = get_workspaces()
    current_workspaces.sort(key=lambda w: w["id"])
    for w in current_workspaces:
        if w["id"] > len(WORKSPACE_ICON_PATHS):
            workspaces.append(w)

    active_workspace_id = get_active_workspace()
    entrys = ""
    for w in workspaces:
        entrys += " "
        entrys += workspace_entry(w["id"], w["id"] == active_workspace_id)

    return wrapper_box(entrys)


if __name__ == "__main__":
    p = subprocess.Popen(
        [WORKSPACE_TOOL_COMMAND, "watch_workspace_updates"],
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
    )
    print(build_workspace_widget(), flush=True)

    for line in p.stdout:
        print(build_workspace_widget(), flush=True)
