# VNTrading Virtual Environment

This virtual environment contains offline packages required for Vietnamese trading data fetching, including:

- vnstock and related Vietnamese market packages
- Other packages that may not be available on standard PyPI

## Usage

To activate this environment:

```bash
source VNTrading_env/bin/activate
```

## Note

This virtual environment is included in the repository because it contains local/offline packages that cannot be easily installed from standard package repositories.

If you're setting up on a new machine, you may need to:
1. Ensure Python 3.12 is installed
2. Activate this environment
3. Test that all packages work correctly

## Packages Included

See `requirements.txt` in the root directory for the main package list.
