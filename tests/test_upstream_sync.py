"""Pytest for the upstream sync test module."""

import sys
from pathlib import Path

# Allow running pytest from the repo root without installing the package.
sys.path.insert(0, str(Path(__file__).resolve().parents[1]))

from src.upstream_sync_test import run_upstream_sync_test


def test_upstream_sync_test_returns_sentinel():
    assert run_upstream_sync_test() == "UPSTREAM_SYNC_EXECUTED"
