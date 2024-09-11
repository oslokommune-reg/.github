# Format Code Workflow Documentation

This document explains the GitHub Actions workflow for automatically formatting code in pull requests.

## Workflow Overview

The `format-code` workflow is designed to run on pull requests to the `dev`, `main`, and `prod` branches. It uses pre-commit hooks to format code and automatically commits any changes back to the pull request branch.

## Important Note on Personal Access Token

**IMPORTANT:** This workflow uses a Personal Access Token (PAT) stored as `secrets.CODE_FORMATTER_PAT`. This is a personal access token and **cannot be transferred to the organization**. Ensure that the owner of this PAT maintains it and has the necessary permissions.

## Workflow Trigger

```yaml
on:
  pull_request:
    branches: [dev, main, prod]
    types: [opened, synchronize, reopened]
```

The workflow runs when a pull request is opened, synchronized, or reopened against the `dev`, `main`, or `prod` branches.

## Job Configuration

The job runs on the latest Ubuntu runner and requires write permissions for contents, pull requests, and checks.

## Steps Breakdown

1. **Checkout Code**
   ```yaml
   - uses: actions/checkout@v4
     with:
       ref: ${{ github.head_ref }}
       token: ${{ secrets.CODE_FORMATTER_PAT }}
   ```
   This step checks out the code from the pull request branch using the provided PAT.

2. **Set up Python**
   ```yaml
   - name: Set up Python
     uses: actions/setup-python@v4
     with:
       python-version: '3.11'
   ```
   Sets up Python 3.11 for running pre-commit.

3. **Install pre-commit**
   ```yaml
   - name: Install pre-commit
     run: |
       python -m pip install --upgrade pip
       pip install pre-commit
   ```
   Installs the pre-commit tool.

4. **Install Terraform**
   ```yaml
   - name: Install Terraform
     uses: hashicorp/setup-terraform@v3
     with:
       terraform_version: "1.9.4"
   ```
   Installs Terraform version 1.9.4, presumably for Terraform-related pre-commit hooks.

5. **Copy pre-commit config**
   ```yaml
   - name: Copy pre-commit config
     run: |
       mkdir -p .github/workflows
       curl -O https://raw.githubusercontent.com/oslokommune-reg/.github/prod/.github/workflows/config/.pre-commit-config.yaml
   ```
   Fetches the pre-commit configuration file from a specified GitHub repository.

6. **Run pre-commit**
   ```yaml
   - name: Run pre-commit on changed files
     run: |
       if [ "${{ github.event_name }}" == "pull_request" ]; then
         git fetch origin ${{ github.base_ref }}
         pre-commit run --from-ref origin/${{ github.base_ref }} --to-ref HEAD
       else
         pre-commit run --all-files
       fi
     continue-on-error: true
   ```
   Runs pre-commit hooks on changed files in the pull request. If not a pull request, it runs on all files.

7. **Auto-commit changes**
   ```yaml
   - uses: stefanzweifel/git-auto-commit-action@v5
     with:
       commit_message: "Applied formatting"
       branch: ${{ github.head_ref }}
   ```
   Automatically commits any changes made by pre-commit back to the pull request branch.

## Maintenance and Security

1. Regularly review and update the PAT used in this workflow.
2. Ensure the PAT has the minimum necessary permissions.
3. If the owner of the PAT leaves the organization, transfer ownership or create a new PAT.
4. Regularly update the pre-commit hooks and their configurations.
5. Consider using organization-level secrets if possible in the future.

Remember, the security of this workflow depends on the security of the personal access token used. Treat it with the same level of caution as you would any other sensitive credential.
