"""
Unit tests for pyprofstats.py
"""
import sys
import pytest
import tempfile
import pstats
import cProfile
from unittest.mock import patch, MagicMock
from io import StringIO

# Import the module under test
sys.path.insert(0, '/Users/mroberts/work/shell')
import pyprofstats


class TestPyprofstats:
    """Test cases for pyprofstats module."""

    def test_main_with_valid_arguments(self):
        """Test main function with valid arguments."""
        # Create a temporary profile file
        with tempfile.NamedTemporaryFile(suffix='.prof', delete=False) as tmp_file:
            # Create a simple profile
            pr = cProfile.Profile()
            pr.enable()
            # Simple function to profile
            sum([i for i in range(100)])
            pr.disable()
            pr.dump_stats(tmp_file.name)

            # Test the main function
            test_args = ['pyprofstats.py', tmp_file.name, '10']
            with patch.object(sys, 'argv', test_args):
                with patch('sys.stdout', new_callable=StringIO) as mock_stdout:
                    pyprofstats.main()
                    output = mock_stdout.getvalue()
                    assert len(output) > 0  # Should have some output

    def test_main_with_invalid_number_of_arguments(self):
        """Test main function with invalid number of arguments."""
        test_args = ['pyprofstats.py']  # Missing required arguments
        with patch.object(sys, 'argv', test_args):
            with patch('sys.stderr', new_callable=StringIO) as mock_stderr:
                with pytest.raises(SystemExit) as excinfo:
                    pyprofstats.main()
                assert excinfo.value.code == 1
                error_output = mock_stderr.getvalue()
                assert "Usage:" in error_output

    def test_main_with_invalid_number(self):
        """Test main function with invalid number argument."""
        test_args = ['pyprofstats.py', 'dummy.prof', 'not_a_number']
        with patch.object(sys, 'argv', test_args):
            with patch('sys.stderr', new_callable=StringIO) as mock_stderr:
                with pytest.raises(SystemExit) as excinfo:
                    pyprofstats.main()
                assert excinfo.value.code == 1
                error_output = mock_stderr.getvalue()
                assert "not a valid number" in error_output

    def test_main_with_nonexistent_file(self):
        """Test main function with non-existent profile file."""
        test_args = ['pyprofstats.py', 'nonexistent.prof', '10']
        with patch.object(sys, 'argv', test_args):
            with patch('sys.stderr', new_callable=StringIO) as mock_stderr:
                with pytest.raises(SystemExit) as excinfo:
                    pyprofstats.main()
                assert excinfo.value.code == 1
                error_output = mock_stderr.getvalue()
                assert "not found" in error_output

    def test_main_with_corrupted_profile_file(self):
        """Test main function with corrupted profile file."""
        with tempfile.NamedTemporaryFile(suffix='.prof', delete=False) as tmp_file:
            # Write invalid data to the file
            tmp_file.write(b"invalid profile data")

            test_args = ['pyprofstats.py', tmp_file.name, '10']
            with patch.object(sys, 'argv', test_args):
                with patch('sys.stderr', new_callable=StringIO) as mock_stderr:
                    with pytest.raises(SystemExit) as excinfo:
                        pyprofstats.main()
                    assert excinfo.value.code == 1
                    error_output = mock_stderr.getvalue()
                    assert "Error processing profile file" in error_output