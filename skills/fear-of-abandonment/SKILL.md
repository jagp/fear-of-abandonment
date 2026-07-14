---
name: fear-of-abandonment
description: Scan the current git repo for stranded agent work — worktrees, branches not merged into the integration branch (develop/main), and worktrees holding uncommitted changes. Use when you suspect work happened in a worktree or background session but never got merged, or to audit before deleting worktrees.
---

# fear-of-abandonment

A read-only audit that surfaces work which may have been left behind — the "I thought this shipped but it isn't live" case.

## What to do

1. Run the scanner:

   ```bash
   sh "${CLAUDE_PLUGIN_ROOT}/bin/scan.sh"
   ```

2. Present the output to the user, calling out findings in this priority order:
   - **Branches not merged into the integration branch** — committed, durable, but never integrated. This is the most likely home of "lost" work.
   - **Worktrees with uncommitted changes** — fragile work that is invisible in SourceTree's main working-copy view.
   - **Existing worktrees** — candidates for cleanup once their branch is confirmed merged.

3. If nothing is stranded, say so plainly.

## Hard rule

This skill is **read-only**. Do not merge, delete, prune, or modify anything. Report what you find and stop. Any remediation is a separate, explicit decision for the user.
