---
name: verify-real-behavior
description: Prove a change at the nearest real boundary and separate source, static, test, runtime, device, and remote evidence. Use for browser, mobile, compositor, audio, GPU, VM, network, service, integration, rendering, deployment, or other work where a build alone cannot prove behavior.
---

# Verify Real Behavior

Choose the strongest safe check that reaches the behavior the user will use.
Read [evidence-levels.md](references/evidence-levels.md) before you select the
check.

## Process

1. State the exact behavior to prove.
2. Identify the real boundary and the observable result.
3. Discover the current runtime state. Do not use an old device name, process,
   port, or remote head without a new check.
4. Select the smallest test that crosses the boundary.
5. Run the test without replacing an existing user session or destroying data.
6. Capture concise evidence.
7. Compare the result with the expected result.
8. Report the evidence level and each important untested flow.

## Rules

- A source string proves only that the string exists.
- A typecheck proves only the checked type contracts.
- A build proves only that the build completed.
- A unit test proves only the test boundary.
- A hot reload does not prove a new process or boot path.
- A queued remote job does not prove completion.
- A configured device profile does not prove the active data path.
- Do not say `works` without naming the observed result.

If a real check is unsafe or unavailable, stop at the strongest safe evidence.
State the limit directly.

