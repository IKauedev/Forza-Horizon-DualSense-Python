"""HidHide presence detection — Windows only.

When HidHide is installed on the system we switch the I/O loop into
persistent mode (no reconnect, no liveness watchdog) so that HidHide
cloaking the device mid-session doesn't tear our HID handle down. We
don't touch HidHide's whitelist — if HidHide is hiding the controller
from us at startup, the user adds the app in HidHide's GUI once.
"""

from __future__ import annotations

import os
import shutil
import sys
from pathlib import Path


def _detect() -> bool:
    if sys.platform != "win32":
        return False
    # User override / convenience: any non-empty path means "yes, present".
    env = os.environ.get("HIDHIDE_CLI")
    if env and Path(env).is_file():
        return True
    if shutil.which("HidHideCLI.exe"):
        return True
    pf = os.environ.get("ProgramFiles", r"C:\Program Files")
    standard = Path(pf) / "Nefarius Software Solutions" / "HidHide" / "x64" / "HidHideCLI.exe"
    return standard.is_file()


_present = _detect()


def is_present() -> bool:
    """True when HidHide is installed. The I/O loop reads this to enable
    persistent mode."""
    return _present
