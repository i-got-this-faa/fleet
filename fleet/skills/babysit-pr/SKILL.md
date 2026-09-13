---
name: babysit-pr
description: Wait for every AI code reviewer on an existing pull request to finish for the current head commit, then verify their findings and fix the valid ones. Use when the user asks to babysit, watch, or monitor a pull request with one or more AI reviewers.
---

# Babysit a pull request

Wait for all AI reviewers. Then fix their valid findings. Do not merge the pull
request unless the user asks.

## Find the reviewers

1. Read the repository instructions and pull request.
2. Record the current head commit.
3. Find each AI reviewer from review checks, status checks, review comments,
   and prior runs on the pull request.
4. Record each reviewer as pending or complete for the current head commit.

Do not ask the user to name a reviewer when the pull request shows that
information.

## Wait for all reviewers

Poll the pull request with the available monitoring mechanism. Wait until each
AI reviewer has completed for the same head commit.

Do not edit the code when one reviewer finishes and another reviewer is still
running. A partial review set causes repeated work and conflicting fixes.

If the head commit changes while you wait, discard the old baseline. Find the
reviewers and wait again for the new head commit.

## Fix the findings

After all reviewers finish:

1. Collect every unresolved finding for the current head commit.
2. Combine duplicate findings.
3. Read the cited source and the minimum related code.
4. Reproduce a reported problem when a focused check is available.
5. Fix each finding that the source supports.
6. Dismiss a false positive with a short written reason.
7. Run the focused checks and the wider relevant checks.
8. Review the exact diff.
9. Push only the scoped fixes.

A request to babysit a pull request permits scoped fixes and pushes to that
pull request branch. It does not permit unrelated changes or a merge.

## Repeat after a push

A push creates a new head commit. Wait for every AI reviewer to complete again.
Then process only findings for the new head commit.

Finish when all AI reviewers have completed for the latest head and no valid
finding remains. Stay quiet while nothing changes. Do not post filler comments.
