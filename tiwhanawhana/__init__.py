# -*- coding: utf-8 -*-
"""Convenience imports for the Tiwhanawhana application package."""

import sys
from importlib import import_module
from types import ModuleType
from typing import Any

__all__ = [
    "backend",
    "get_backend_module",
]

def _load_backend() -> ModuleType:
    module = import_module("backend")
    sys.modules.setdefault(f"{__name__}.backend", module)
    return module


# Lazy proxy exposing backend under tiwhanawhana namespace
class _BackendModule(ModuleType):
    def __getattr__(self, item: str) -> Any:
        module = _load_backend()
        return getattr(module, item)


backend = _BackendModule("tiwhanawhana.backend")
sys.modules["tiwhanawhana.backend"] = backend

def get_backend_module() -> ModuleType:
    """Return the underlying backend package for advanced introspection."""
    return _load_backend()
