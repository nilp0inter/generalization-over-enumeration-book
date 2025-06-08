# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Jupyter Book project about property-based testing in Python using Hypothesis. The book explores mathematical ideas for more powerful Python testing, focusing on generalization over enumeration.

## Development Environment

This project uses Nix flakes for reproducible development environments:

- **Default shell (HTML only)**: `nix develop`
- **PDF-enabled shell**: `nix develop .#pdf`

The development environment includes:
- Python 3.11 with Jupyter Book, Hypothesis, JupyterLab, and scientific libraries
- Git and Make utilities
- LaTeX (in PDF shell) for PDF generation

## Build Commands

- **Build HTML book**: `nix develop --command jupyter-book build .`
- **Build PDF book**: `nix develop .#pdf --command jupyter-book build . --builder pdflatex`
- **Build with warnings as errors**: `nix develop --command jupyter-book build . --builder html --warningiserror`
- **Start JupyterLab**: `nix develop --command jupyter-lab`

## Book Structure

- `_config.yml`: Jupyter Book configuration
- `_toc.yml`: Table of contents defining book structure
- `intro.md`: Book introduction page
- `chapter*.md`: Individual chapter files with executable code cells
- `_build/`: Generated book output (HTML and PDF)

## Code Execution

The book uses `execute_notebooks: force` in `_config.yml`, meaning all code cells are executed during build. Code cells use MyST markdown format with `{code-cell} python` blocks.

## Test Function Pattern

**CRITICAL**: The book contains pytest and Hypothesis test functions that must be executed to demonstrate their behavior. Every test function definition MUST be followed by a separate code cell that executes the test:

```markdown
# Define the test function
```{code-cell} python
def test_example():
    assert 1 + 1 == 2
```

# Execute the test function
```{code-cell} python
:tags: [hide-input, hide-output]

test_example()
```
```

This pattern is essential because:
- The source files are Jupyter Book chapters, not proper pytest test files
- Tests must be explicitly executed to show results and catch failures during build
- Use `:tags: [hide-input, hide-output]` to hide the execution cell from readers
- Build will fail if any test function fails when executed

When writing or modifying chapters, always include the execution cell after every test function definition.

## CI/CD

The project uses GitHub Actions with parallel HTML and PDF builds. The HTML build deploys to GitHub Pages on the main branch. Build failures show test execution logs from `_build/**/*.err.log` files.