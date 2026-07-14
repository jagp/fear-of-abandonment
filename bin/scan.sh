#!/usr/bin/env sh
# fear-of-abandonment :: report stranded work in the current git repo.
# Read-only. No mutation. Safe to run anywhere.
set -u

if ! git rev-parse --git-dir >/dev/null 2>&1; then
  echo "Not inside a git repository — nothing to scan."
  exit 0
fi

# Pick the integration branch the gitflow way: develop, else main/master, else HEAD.
INT=""
for b in develop main master; do
  if git show-ref --verify --quiet "refs/heads/$b"; then INT="$b"; break; fi
done
[ -z "$INT" ] && INT="$(git rev-parse --abbrev-ref HEAD 2>/dev/null)"

echo "=== claude-session-guardrails :: fear-of-abandonment ==="
echo "Integration branch: $INT"
echo

echo "--- Worktrees (git worktree list) ---"
git worktree list
echo

echo "--- Branches NOT merged into $INT (committed-but-unintegrated work) ---"
NM="$(git branch --no-merged "$INT" --format='%(refname:short)|%(committerdate:relative)' 2>/dev/null)"
if [ -z "$NM" ]; then
  echo "(none — every local branch is already merged into $INT)"
else
  printf '%s\n' "$NM" | while IFS='|' read -r name date; do
    [ -z "$name" ] && continue
    ahead="$(git rev-list --count "$INT..$name" 2>/dev/null)"
    printf '  %-44s %s commit(s) ahead  |  last commit %s\n' "$name" "${ahead:-?}" "$date"
  done
fi
echo

echo "--- Worktrees with UNCOMMITTED changes (SourceTree main-view blind spot) ---"
any=""
for wt in $(git worktree list --porcelain | awk '/^worktree /{print $2}'); do
  [ -d "$wt" ] || continue
  dirty="$(git -C "$wt" status --porcelain 2>/dev/null)"
  if [ -n "$dirty" ]; then
    n="$(printf '%s\n' "$dirty" | grep -c '.')"
    printf '  %s  (%s uncommitted path(s))\n' "$wt" "$n"
    any="yes"
  fi
done
[ -z "$any" ] && echo "(none — no linked worktree has uncommitted changes)"
echo
echo "=== end report ==="
