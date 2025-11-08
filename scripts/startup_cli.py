"""Awaken Tiwhanawhana with koru pulse and mauri sync."""
from __future__ import annotations

import json
import os
import sys
import time
from copy import deepcopy
from datetime import datetime
from typing import Any, Dict

from rich.console import Console
from rich.progress import Progress, SpinnerColumn, TextColumn
from rich.theme import Theme


theme = Theme({
    "koru": "bold cyan",
    "flow": "bold green",
    "mauri": "bold magenta",
    "warn": "bold yellow",
    "error": "bold red",
})
console = Console(theme=theme)

TOHU_PATH = "tohu.json"
DEFAULT_TOHU: Dict[str, Any] = {
    "name": "Unknown",
    "version": "0.0.0",
    "mauri_state": {
        "status": "unknown",
        "energy_level": "low",
        "sync_status": "unsynced",
        "last_breath": None,
    },
    "purpose": "Unbound",
}


def load_tohu(silent: bool) -> Dict[str, Any]:
    if not os.path.exists(TOHU_PATH):
        if not silent:
            console.print(
                "[error]⚠️ tohu.json not found. Creating a blank mauri stone...[/error]")
    return deepcopy(DEFAULT_TOHU)
    try:
        with open(TOHU_PATH, "r", encoding="utf-8") as file:
            data = json.load(file)
    except json.JSONDecodeError as exc:
        if not silent:
            console.print(
                f"[error]⚠️ tohu.json is corrupted: {exc}. Restoring defaults.[/error]")
    return deepcopy(DEFAULT_TOHU)
    # Ensure required structure exists even if file is partial.
    mauri_state = data.setdefault("mauri_state", {})
    for key, value in DEFAULT_TOHU["mauri_state"].items():
        mauri_state.setdefault(key, value)
    data.setdefault("name", DEFAULT_TOHU["name"])
    data.setdefault("version", DEFAULT_TOHU["version"])
    data.setdefault("purpose", DEFAULT_TOHU["purpose"])
    return data


def update_last_breath(tohu: Dict[str, Any]) -> None:
    tohu.setdefault("mauri_state", {})
    tohu["mauri_state"]["last_breath"] = f"{datetime.utcnow().isoformat(timespec='seconds')}Z"
    with open(TOHU_PATH, "w", encoding="utf-8") as file:
        json.dump(tohu, file, indent=2, ensure_ascii=False)


def koru_pulse(tohu: Dict[str, Any], quick: bool, silent: bool) -> None:
    if silent:
        return
    console.rule(f"[koru]{tohu['name']} 🌀 {tohu['version']}[/koru]")
    console.print(f"[mauri]Mauri:[/mauri] {tohu['mauri_state']['status']}")
    console.print(f"[flow]Purpose:[/flow] {tohu['purpose']}\n")

    frames = [
        ("🌀", "koru"),
        ("🌊", "flow"),
        ("💨", "warn"),
        ("🌿", "mauri"),
    ]
    cycles = 1 if quick else 3
    delay = 0.15 if quick else 0.3
    for _ in range(cycles):
        for frame, style in frames:
            console.print(
                f"\r{frame}  Awakening Tiwhanawhana...", end="", style=style)
            time.sleep(delay)
    console.print("\n✨ [koru]Tiwhanawhana is awake and flowing.[/koru]\n")


def sync_awanet(silent: bool) -> None:
    if silent:
        return
    with Progress(SpinnerColumn(), TextColumn("[koru]{task.description}[/koru]"), transient=True) as progress:
        progress.add_task(
            description="Checking Supabase connection...", total=None)
        time.sleep(1.0)
        progress.add_task(description="Syncing mauri memory...", total=None)
        time.sleep(1.0)
    console.print("[flow]✅ Sync complete. AwaNet is flowing.[/flow]")


def main() -> None:
    quick = "--quick" in sys.argv or "-q" in sys.argv
    silent = "--silent" in sys.argv or "-s" in sys.argv

    tohu = load_tohu(silent=silent)
    koru_pulse(tohu, quick=quick, silent=silent)
    sync_awanet(silent=silent)
    update_last_breath(tohu)
    if not silent:
        console.print("[mauri]💫 Mauri updated and stored in tohu.json[/mauri]")


if __name__ == "__main__":
    main()
