# Evidence Levels

Use the highest level that the task needs.

1. Source: the expected code or configuration exists.
2. Static: format, lint, type, or schema checks pass.
3. Component: a focused unit or component test passes.
4. Integration: two or more real components exchange the expected data.
5. Runtime: the live process shows the expected behavior.
6. User path: the real device, browser, client, or remote service completes the
   user flow.

Do not report a lower level as a higher level. Name the highest level that you
observed.

