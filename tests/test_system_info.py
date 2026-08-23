"""Tests for system_info module."""

import pytest
from src.system_info import get_system_info, _get_ram


class TestGetSystemInfo:
    def test_returns_dict(self):
        info = get_system_info()
        assert isinstance(info, dict)

    def test_has_required_keys(self):
        info = get_system_info()
        expected_keys = {'os', 'python', 'cpu', 'ram', 'hostname'}
        assert set(info.keys()) == expected_keys

    def test_os_is_string(self):
        info = get_system_info()
        assert isinstance(info['os'], str)

    def test_python_is_string(self):
        info = get_system_info()
        assert isinstance(info['python'], str)

    def test_hostname_is_string(self):
        info = get_system_info()
        assert isinstance(info['hostname'], str)

    def test_cpu_is_non_empty_string(self):
        info = get_system_info()
        assert isinstance(info['cpu'], str)
        assert len(info['cpu']) > 0

    def test_os_name_valid(self):
        info = get_system_info()
        assert info['os'] in ('Windows', 'Linux', 'Darwin')

    def test_ram_is_number_or_none(self):
        info = get_system_info()
        ram = info['ram']
        assert ram is None or isinstance(ram, (int, float))

    def test_ram_positive_when_available(self):
        info = get_system_info()
        ram = info['ram']
        if ram is not None:
            assert ram > 0


class TestGetRam:
    def test_returns_number_or_none(self):
        ram = _get_ram()
        assert ram is None or isinstance(ram, (int, float))

    def test_positive_value_when_available(self):
        ram = _get_ram()
        if ram is not None:
            assert ram > 0


class TestMain:
    def test_cli_output_contains_headers(self, capsys):
        from src.system_info import main
        main()
        captured = capsys.readouterr()
        output = captured.out

        assert 'System Information' in output
        assert 'OS:' in output
        assert 'Python:' in output
        assert 'CPU:' in output
        assert 'RAM:' in output
        assert 'Hostname:' in output
