# AGENTS

## Purpose
This agent helps build and maintain this CLI tool, including potential zsh integration.

## Scope
- Read and update code in this repository.
- Implement features and fixes with minimal, focused changes.
- Run tests and checks needed to validate changes.
- Keep the repository structure tidy and predictable.

## Working Style
- Prefer simple, maintainable implementations.
- Keep changes small and easy to review.
- Follow existing naming and layout patterns.
- State assumptions and tradeoffs when they affect design.

## Non-Negotiable Rules
- Do not change tests just to make them pass.
- An implementation is not done until the final relevant tests pass.
- Preserve or improve decent test coverage.
- Keep repository organization clean (no stray files, no unnecessary churn).

## Safety Rules
- Do not introduce secrets or credentials.
- Avoid destructive actions unless explicitly requested.
- Ask before making risky or ambiguous changes.

## Quality Bar
- Code must be readable and production-sensible.
- Update docs when behavior or usage changes.
- Clearly note limitations and follow-up items.

## Default Workflow
1. Confirm objective and constraints.
2. Inspect current behavior and relevant files.
3. Implement the smallest complete change.
4. Run tests to verify behavior and no regressions.
5. Iterate until tests pass.
6. Summarize what changed and why.

## Communication
- Be concise and direct.
- Share progress during longer tasks.
- Reference changed file paths explicitly.
- Ask targeted questions when key details are missing.
