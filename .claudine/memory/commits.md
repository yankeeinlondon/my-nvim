# Commits — Lessons Learned

Permanent memory of non-obvious things discovered while making commits. Append
new entries to the bottom; never delete existing ones.

## The canonical commit command (never `-m "..."`)

Commit bodies routinely contain backticks (`` `::end-block` ``), `$`, and other
shell metacharacters. Inside a double-quoted `-m "..."` string the shell evaluates
those (backticks are command substitution even within double quotes), which
corrupts the message and makes tooling try to `git add` the extracted tokens as
pathspecs (`fatal: pathspec '::end-block' did not match any files`).

**Always feed the message on stdin via a single-quoted heredoc:**

```text
git commit --only -F - -- path1 path2 <<'COMMIT_MSG'
refactor(scope): summary line under 72 chars

- bullet describing what changed
- bullet describing why

COMMIT_MSG
```

- The `'COMMIT_MSG'` delimiter MUST be single-quoted — that is what disables
  expansion. An unquoted `COMMIT_MSG` still expands `$`/backticks.
- `-F -` reads the message from stdin.
- `-- path1 path2` pathspecs restrict the commit to the assigned files.
- `--only` commits ONLY the listed paths and leaves all other staged changes
  staged (it does not sweep in unrelated staged files).

## Renames require BOTH old and new pathspecs with `--only`

For a staged rename `A -> B`, `git commit --only -- B` alone records only the
addition at `B` and leaves `A` in place — the rename is broken (both paths end up
existing). To record a rename correctly, pass **both** the old and new pathspecs:

```text
git commit --only -F - -- archive/new_name old_name <<'COMMIT_MSG'
...
COMMIT_MSG
```

Passing both sides lets git pair the delete + add as a rename (shows as
`{old => new}/file` with `100% rename` in `--stat`).

## Deletions work fine with `--only`

`git commit --only -- deleted_path` correctly commits a staged deletion even
though there is no working-tree file to re-stage. No need to fall back to a plain
`git commit` (which WOULD sweep in every other staged file). Prefer `--only`.

## In parallel/multi-agent commit sessions, do NOT trust `git log -1` / HEAD

When several agents commit against the same worktree concurrently, another
agent's commit can land between your `git commit` and your `git log -1`/`status`
verification, so `HEAD` shows THEIR commit, not yours. This is expected, not
corruption.

- Capture the SHA from your `git commit` command's own stdout.
- Verify YOUR commit with `git show <sha>` or `git log -n N --oneline`, not
  `git log -1`.

## Lock contention is expected and non-fatal

Parallel `git commit`s can fail with
`fatal: Unable to create '.git/index.lock': File exists.` (or a
`refs/heads/<branch>.lock` variant). Git's locks are fail-fast, not a queue.
Wait 1–3 seconds and retry the exact same command. Up to 5 retries with short
backoff before giving up.

## Always review the actual `git diff --cached` before writing the message

A human/agent-supplied change summary is a hint, not the truth. Repeatedly, the
real diff surfaced behavior changes the summary missed (e.g. a removed
`require`, an added `autocomplete = false`, a `tabstop`/`shiftwidth` asymmetry,
a renamed theme string) or claimed a removal that didn't happen (e.g. a `:Format`
command that was actually kept). Trust the diff; mention real behavior deltas in
the commit body rather than silently omitting them.

## Do NOT unstage/restage to group commits

Trying to group commits by unstaging one set, committing, then restaging the rest
risks corruption in an actively-edited repo (developers may stage/unstage while
you work). Instead commit each group explicitly via `git commit --only -- <paths>`
with disjoint pathsets. Never `git reset`.
