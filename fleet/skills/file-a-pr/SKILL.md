---
name: file-a-pr
description: Verify a branch and open a clear, review-ready pull request that follows repository conventions. Use when the user asks to file, open, create, or prepare a pull request, or asks to turn the current branch into a PR.
---

# File a pull request

## Inspect

1. Read the repository instructions.
2. Check the branch, upstream, worktree, and remote base.
3. Check whether a pull request already exists for the branch.
4. Fetch the remote state when network access is available.
5. Review the diff against the correct remote base.
6. Read recent merged pull requests and commits for title conventions.

Do not file a pull request when the diff does not match the user's goal.

## Verify

1. Run the relevant format, lint, type, test, and build checks.
2. Run the real behavior check when the change needs one.
3. Fetch and rebase onto the latest remote base before opening the pull request.
4. Re-run affected checks after the branch changes.

Do not rewrite a shared or published branch without user authority. If a rebase is not safe, report the conflict and stop before opening the pull request.

## Write

Use a concise title that explains why the change matters. Follow the repository's title style.

Prefer a result over an implementation mechanism:

```text
Bad:  perf(server): negotiate permessage-deflate on the websocket
Good: perf(server): cut websocket frame size by 70% with compression
```

Use a number only when test evidence proves it.

Start the description with the user problem. Then explain the solution and the checks. Do not start with a file list or an implementation inventory.

Use this structure when the repository has no template:

```markdown
## Problem
<short user-visible problem>

## Solution
<short explanation>

## Verification
- <check and result>

## Limits
- <important untested flow, or None>

---
Created by <model> with <agent harness>.
```

Open a real pull request unless the user asks for a draft. If the repository requires an agent disclosure, use its exact format. Otherwise, add the short model and harness note shown above. Read both names from runtime data. Do not guess.

After creation, verify the URL, base, head, commit, draft state, and initial checks.

If the user also asks you to monitor or babysit the pull request, continue with the `babysit-pr` skill.
