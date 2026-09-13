---
name: anti-slop-code
description: Review AI-written or rapidly written code for low-evidence types, needless wrappers, speculative compatibility, duplicated logic, stale comments, broad fallbacks, and shallow tests. Use when the user asks to remove slop, clean generated code, simplify a patch, review code quality, or harden TypeScript or JavaScript before merge.
---

# Anti-Slop Code Review

Read [review-checklist.md](references/review-checklist.md). Apply only the
checks that match the project and the changed code.

## Process

1. Read the task and the repository conventions.
2. Review the diff before you review the whole repository.
3. Trace each changed value from its source to its consumer.
4. List material findings with file and line evidence.
5. Remove code only when you can explain why it is not necessary.
6. Preserve behavior unless the task requires a behavior change.
7. Run focused tests after each semantic cleanup.
8. Run the wider relevant checks before completion.

## Rules

- Prefer a precise type at the boundary to a cast after the boundary.
- Prefer clear inference to repeated type annotations.
- Do not add `any`, chained assertions, or a broad dictionary to avoid a real contract.
- Do not add a wrapper that only renames a function or performs a cast.
- Do not add speculative fallback or compatibility behavior.
- Do not add an abstraction for one short use without a clear boundary.
- Remove a comment that repeats the code.
- Keep a comment that explains a reason, invariant, or non-obvious contract.
- Prefer one behavior test to many shallow snapshots or smoke tests.
- Do not enable a strict lint rule across a project without checking valid existing patterns.

Report rejected findings when a pattern is valid for this project. Do not make
churn to satisfy a generic style opinion.
