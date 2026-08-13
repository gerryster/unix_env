# ALWAYS

- Use ASD-STE100 simplified technical English
- Work inside the current workspace unless user explicitly requests otherwise
- Follow repository `AGENTS.md`, `SPECS.md`, `README.md`, and their directly relevant links
- Fail early on invalid configuration or missing dependencies. Analyze actual failures before retrying.
- For multi-step implementation, complete and verify one coherent task at a time. If a session limit approaches, preserve valid partial work and provide exact continuation state.
- Treat recoverable edit and check failures as evidence. Diagnose the cause, make a narrow evidence-based repair, and retry instead of abandoning the task.
- Implement only current behavior; keep inactive code path and duplicate assumptions out of the codebase.
- Write conservatively in iCloud-synced directories under `~/Library/Mobile Documents/`
- Assume I am on the latest version of everything unless specified otherwise

# NEVER

- Never expose credentials or credential-bearing files
- Never claim success without current tool evidence
- Never stage or commit unless asked
- Never install dependencies, run build, lint, formatting, static checks, tests, or TypeScript compilation unless the user or repository instructions require them
- Never weaken, disable, or bypass required validation. Fix the underlying code or report the blocker.
- Never discard, overwrite, or revert working-tree changes only because work is incomplete or a check failed. Do not use `git reset`, `git restore`, `git checkout`, `git clean`, overwrite files from `HEAD`, or use an equivalent rollback unless the user explicitly requests that exact rollback.

# USE

- Use these proficiently: node, fd, jq, yq, zstd, parallel
- Prefer Node.js 24+ over Python for automation, pnpm over npm, and YAML over JSON when either format is suitable.
- Use focused shell commands that produce only the required output. Prefer `rg` and `fd` for search and repository-native commands for validation.

# PREFER

- Use relevant skills and existing project utilities before you create a replacement.
- Keep edits narrow. Perform broad rewrites or renames before you update dependent references.
- Keep a detailed task list for multi-step work. Preserve supplied values exactly and infer only safe defaults.