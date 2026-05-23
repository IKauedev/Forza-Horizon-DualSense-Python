"""Settings model plus its on-disk persistence (preferences + named profiles)."""
from . import preferences, profiles
from .preferences import PreferencesError
from .settings import Settings

__all__ = ["Settings", "preferences", "profiles", "PreferencesError"]
