# Format Workflow

This GitHub Actions workflow automatically formats code in pull requests to maintain consistent coding styles across the project.

## Overview

The workflow runs on pull requests to the `dev` and `prod` branches. It uses `pre-commit` to apply formatting to SQL, Python, and Terraform files.

## Supported File Types

- SQL (`.sql`)
- Python (`.py`)
- Terraform (`.tf`)

## Workflow Steps

1. Checkout the code
2. Set up Python
3. Install pre-commit
4. Install Terraform
5. Fetch the pre-commit configuration
6. Run pre-commit hooks
7. Commit any changes made by the formatters

## Setup

### Prerequisites

- GitHub repository with GitHub Actions enabled
- Access to the `oslokommune-reg/.github` repository for the pre-commit configuration

### Installation

1. Create a new file in your repository at `.github/workflows/format.yml`
2. Copy the workflow content into this file
3. Commit and push the changes to your repository

## Usage

Once installed, this workflow will automatically run on all pull requests to the `dev` and `prod` branches. It will:

1. Format the code according to the rules defined in the pre-commit configuration
2. Commit any changes made by the formatters
3. Push the formatted code back to the pull request branch


This workflow runs on all dev and prod pull requests on the oslokommune-reg repository.

## Configuration

The pre-commit configuration is fetched from:

```
https://raw.githubusercontent.com/oslokommune-reg/.github/prod/.github/workflows/config/.pre-commit-config.yaml
```

To modify the formatting rules, update the configuration in the `oslokommune-reg/.github` repository.
