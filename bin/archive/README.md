# Archive - Experimental Scripts

This directory contains experimental and alternative implementations that are not part of the main workflow.

## Experimental Scripts

### `/experimental/claude-glm-simple`
- **Purpose**: Bare-bones implementation for testing
- **Status**: Superseded by main `claude-glm` script
- **Limitations**: Only takes first argument, no output formatting

### `/experimental/claude-glm-fixed`
- **Purpose**: Intermediate version with better argument handling
- **Status**: Merged into main `claude-glm` script
- **Features**: Multi-argument support, jq output parsing

## Why Archived?

These scripts were development iterations and testing variants. The main `bin/claude-glm` script incorporates the best features from these experiments:
- Proper multi-argument handling (from fixed)
- Clean output formatting with jq (from both)
- Health check validation
- User-friendly error messages

## For Development Use Only

Feel free to reference these for understanding implementation evolution or for debugging purposes, but use the main scripts in `bin/` for actual usage.
