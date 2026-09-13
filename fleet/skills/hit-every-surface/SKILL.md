---
name: hit-every-surface
description: Trace one behavior through all applicable entry points, clients, providers, contracts, reverse states, connection modes, tests, and documents. Use for cross-cutting features, frontend behavior with several entry points, multi-client systems, provider adapters, schema changes, or when one fixed path can hide missing work elsewhere.
---

# Hit Every Surface

Do not use the first working path as proof of a complete feature.

## Build The Surface Ledger

1. State the user-visible behavior in one sentence.
2. Find the entry points that can start the behavior.
3. Find each client or platform that provides the behavior.
4. Find each provider or adapter that implements it.
5. Find the contracts that cross a process or network boundary.
6. Find the reverse action and the state that shows the result.
7. Find local, remote, relay, offline, or multi-device modes.
8. Find the tests, user documents, architecture documents, and reference terms.
9. Record each surface in
   [surface-ledger.md](references/surface-ledger.md).

Use code search, callers, routes, commands, settings, keybindings, schemas, and
tests as evidence. Do not infer coverage from names.

## Decide Applicability

Mark each surface as `applies`, `does not apply`, or `unknown`. Give a reason
for each item that does not apply. Resolve each unknown before completion.

## Implement And Verify

1. Change the shared contract first when several consumers depend on it.
2. Update each applicable producer and consumer.
3. Add the reverse path when the feature changes a state.
4. Verify each provider decision, including an explicit unsupported result.
5. Run focused checks for each surface.
6. Run an end-to-end check across the important path.
7. Report the final ledger with evidence.

