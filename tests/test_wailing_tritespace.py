"""
Unit tests for wailing_tritespace.py
"""
import sys
import pytest
from io import StringIO
from unittest.mock import patch

# Import the module under test
sys.path.insert(0, '/Users/mroberts/work/shell')
import wailing_tritespace


class TestWailingTritespace:
    """Test cases for wailing_tritespace module."""

    def test_process_whitespace_basic(self):
        """Test basic whitespace processing."""
        input_text = "hello world   \ntest\ttab\n  trailing spaces  \n"
        input_stream = StringIO(input_text)

        with patch('sys.stdout', new_callable=StringIO) as mock_stdout:
            wailing_tritespace.process_whitespace(input_stream)
            output = mock_stdout.getvalue()

            lines = output.splitlines()
            assert lines[0] == "hello world"  # Trailing spaces removed
            assert lines[1] == "test    tab"  # Tab converted to 4 spaces
            assert lines[2] == "  trailing spaces"  # Trailing spaces removed

    def test_process_whitespace_tabs_only(self):
        """Test processing with only tabs."""
        input_text = "\t\t\tthree tabs\n"
        input_stream = StringIO(input_text)

        with patch('sys.stdout', new_callable=StringIO) as mock_stdout:
            wailing_tritespace.process_whitespace(input_stream)
            output = mock_stdout.getvalue()

            lines = output.splitlines()
            assert lines[0] == "            three tabs"  # 3 tabs = 12 spaces

    def test_process_whitespace_trailing_only(self):
        """Test processing with only trailing whitespace."""
        input_text = "no tabs but trailing     \n"
        input_stream = StringIO(input_text)

        with patch('sys.stdout', new_callable=StringIO) as mock_stdout:
            wailing_tritespace.process_whitespace(input_stream)
            output = mock_stdout.getvalue()

            lines = output.splitlines()
            assert lines[0] == "no tabs but trailing"

    def test_process_whitespace_empty_lines(self):
        """Test processing with empty lines."""
        input_text = "line1\n\nline3\n   \n"
        input_stream = StringIO(input_text)

        with patch('sys.stdout', new_callable=StringIO) as mock_stdout:
            wailing_tritespace.process_whitespace(input_stream)
            output = mock_stdout.getvalue()

            lines = output.split('\n')
            assert lines[0] == "line1"
            assert lines[1] == ""  # Empty line stays empty
            assert lines[2] == "line3"
            assert lines[3] == ""  # Whitespace-only line becomes empty

    def test_process_whitespace_mixed_whitespace(self):
        """Test processing with mixed tabs and spaces."""
        input_text = "\t  \tmixed\t  \n"
        input_stream = StringIO(input_text)

        with patch('sys.stdout', new_callable=StringIO) as mock_stdout:
            wailing_tritespace.process_whitespace(input_stream)
            output = mock_stdout.getvalue()

            lines = output.splitlines()
            # Tab -> 4 spaces, then 2 spaces, then tab -> 4 spaces, "mixed"
            # Trailing tab and spaces should be removed
            assert lines[0] == "          mixed"

    def test_process_whitespace_keyboard_interrupt(self):
        """Test handling of KeyboardInterrupt."""
        input_stream = StringIO("test\n")

        # Mock the iteration to raise KeyboardInterrupt
        with patch.object(input_stream, '__iter__', side_effect=KeyboardInterrupt):
            # Should not raise an exception
            wailing_tritespace.process_whitespace(input_stream)

    def test_process_whitespace_broken_pipe(self):
        """Test handling of BrokenPipeError."""
        input_stream = StringIO("test\n")

        with patch('builtins.print', side_effect=BrokenPipeError):
            # Should not raise an exception
            wailing_tritespace.process_whitespace(input_stream)

    def test_main_function(self):
        """Test the main function."""
        test_input = "test\ttab   \n"

        with patch.object(wailing_tritespace, 'process_whitespace') as mock_process:
            wailing_tritespace.main()
            mock_process.assert_called_once()