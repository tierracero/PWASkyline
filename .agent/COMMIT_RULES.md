# Commit Rules

Git and staging safety rules for PWASkyline.

## Do Not Commit By Default

- Never commit unless the user explicitly asks for a commit.
- Never push unless the user explicitly asks for a push.
- Do not amend, rebase, reset, checkout, stash, or clean unless explicitly requested or required by an approved recovery plan.

## Preserve User Work

- Always inspect git status before writing source files.
- Treat existing modified, staged, or untracked files as user-owned unless this task created them.
- Do not stage unrelated files.
- Do not run commands that regenerate broad outputs unless the task explicitly includes those outputs.

## Staging Scope

If the user asks for a commit:

- Stage only files changed by the approved task.
- Review staged diff before committing.
- Use a concise commit message without agent attribution.
- Do not include generated artifacts unless they are part of the task scope.

## Sensitive Files

Do not expose, commit, or print secrets from:

- Local config files.
- Browser storage dumps.
- Tokens, JWTs, API keys, session keys, and private URLs.
- Local build or Xcode/IDE user state.

## Generated / Local State

Avoid editing unless explicitly scoped:

- `.build/**`
- `.swiftpm/**`
- `WebSources/node_modules/**`
- `DevPublic/**`
- `DistPublic/**`
- `.DS_Store`
- `.vscode/**` unless task is editor configuration.

