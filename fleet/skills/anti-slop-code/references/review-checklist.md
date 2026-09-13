# Anti-Slop Review Checklist

## Types And Data

- Does a type come from the real data source or from an assertion?
- Does a broad `object`, `unknown`, dictionary, or optional field hide a known
  contract?
- Does code widen a value and cast it back later?
- Does a wrapper exist only to change the apparent type?
- Does runtime reflection replace a stable typed interface?

## Design

- Does new code duplicate an existing helper or contract?
- Does an abstraction have more ceremony than useful behavior?
- Does the patch add a fallback for a case that cannot occur?
- Does compatibility code preserve behavior that the task removes?
- Can a direct complete design replace several partial layers?

## Tests And Comments

- Does a test prove user behavior or only implementation shape?
- Is a regression test focused on the reported failure?
- Does a comment explain why the code exists?
- Did the patch leave a stale comment, document, or generated artifact?

## Evidence

For each finding, record the path, the behavior risk, the smallest correction,
and the check that proves the correction.

