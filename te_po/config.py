"""
Compatibility layer for old imports.
Routes and older code import from `te_po.config`,
so we forward everything from `te_po.core.config`.
"""

from te_po.core.config import Settings, get_settings, settings

__all__ = ["Settings", "get_settings", "settings"]
