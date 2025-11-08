"""Audit files for non-UTF-8 code points."""
from pathlib import Path


def audit(directory: str) -> list[str]:
    issues: list[str] = []
    for file_path in Path(directory).rglob("*"):
        if not file_path.is_file():
            continue
        try:
            file_path.read_text(encoding="utf-8")
        except UnicodeDecodeError:
            issues.append(str(file_path))
    return issues


if __name__ == "__main__":
    for issue in audit("."):
        print(issue)
