---
name: finish-the-work
description: Carry a broad, interrupted, or multi-stage task from the current state to a checkable result. Use when the user says finish this, complete everything, do not stop until done, resume the work, pick up this session, or when implementation, validation, documentation, and Git actions must stay aligned.
---

# Finish The Work

Define a checkable exit condition. Continue until the condition is true or a real authority boundary blocks the work.

## Start Or Resume

1. Read all applicable instructions.
2. Inspect the worktree, branch, diff, recent commits, and remote state.
3. Read existing plans, task lists, logs, and handoff notes.
4. Verify inherited completion claims. Do not repeat completed work without a reason.
5. Write a short completion ledger. Use
   [completion-record.md](references/completion-record.md).

## Execute

1. Order the work by dependency.
2. Complete one coherent part at a time.
3. Run a focused check after each risky foundation change.
4. Keep the ledger current.
5. Use independent workers only for separate work with clear ownership.
6. Give each worker a goal, scope, context, acceptance checks, forbidden actions, and report format.
7. Review every worker result and diff before integration.

## Stop Conditions

Stop only when one of these conditions is true:

- The exit condition is true and the evidence exists.
- A permission, credential, product decision, or external system blocks the next required action.
- The user stops or changes the task.

Do not stop because the work is long, a first test passed, or a partial patch looks useful.

## Finish

1. Run the full relevant validation set.
2. Verify the real runtime boundary when it applies.
3. Update affected documents and generated artifacts.
4. Inspect the final diff and worktree state.
5. Perform only the Git actions that the user authorized.
6. Verify the remote head after a push or merge.
7. Report completed items, evidence, and untested limits.

If work must pause, save the current branch, head, completed items, checks, blocker, and first resume action. Do not claim completion.
