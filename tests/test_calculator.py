"""Tests for calculator module."""

import pytest
from src.calculator import add, subtract, multiply, divide


class TestAdd:
    def test_positive_numbers(self):
        assert add(2, 3) == 5

    def test_negative_numbers(self):
        assert add(-1, -1) == -2

    def test_zero(self):
        assert add(0, 0) == 0


class TestSubtract:
    def test_positive_numbers(self):
        assert subtract(5, 3) == 2

    def test_negative_result(self):
        assert subtract(3, 5) == -2

    def test_zero(self):
        assert subtract(0, 0) == 0


class TestMultiply:
    def test_positive_numbers(self):
        assert multiply(2, 3) == 6

    def test_negative_numbers(self):
        assert multiply(-2, 3) == -6

    def test_zero(self):
        assert multiply(0, 5) == 0


class TestDivide:
    def test_positive_numbers(self):
        assert divide(6, 3) == 2.0

    def test_negative_result(self):
        assert divide(-6, 3) == -2.0

    def test_divide_by_zero(self):
        with pytest.raises(ZeroDivisionError):
            divide(1, 0)
