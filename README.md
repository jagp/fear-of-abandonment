# fear-of-abandonment
version: 0.0.1

A read-only Claude Code command that surfaces work which may have been left behind
in a worktree or background session — the "I thought this shipped but it isn't live"
class of problem.

## What it reports

Run `/fear-of-abandonment` (namespaced `/fear-of-abandonment:fear-of-abandonment`),
or invoke `bin/scan.sh` directly. It prints:

1. **All worktrees** (`git worktree list`).
2. **Branches not merged into the integration branch** (develop → main → master →
   HEAD, first that exists) — committed-but-unintegrated work.
3. **Worktrees with uncommitted changes** — the SourceTree main-view blind spot.

## Hard rule

Read-only. It never merges, deletes, or prunes anything. Remediation is always a
separate, explicit human decision.

## Test locally

```bash
claude --plugin-dir ./fear-of-abandonment
/fear-of-abandonment:fear-of-abandonment

# or run the scanner directly in any repo:
sh fear-of-abandonment/bin/scan.sh
```
