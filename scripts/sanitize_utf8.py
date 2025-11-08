"""Rewrite files ensuring UTF-8 encoding."""
from pathlib import Path


def sanitize_file(path: Path) -> None:
    data = path.read_text(errors="ignore")
    path.write_text(data, encoding="utf-8")


def main(directory: str) -> None:
    for file_path in Path(directory).rglob("*"):
        if file_path.is_file():
            sanitize_file(file_path)


if __name__ == "__main__":
    main(".")
