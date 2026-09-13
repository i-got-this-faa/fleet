# Agent Session Audit

Audit date: 2026-08-14

## Purpose

This audit finds the agent mistakes that cause repeated corrections and
frustration. It converts those patterns into preventive rules and skills.

The audit did not copy full transcripts. It used user-message counts, targeted
terms, session metadata, and short manual checks of representative sessions.

## Coverage

### Laptop

| Tool | History reviewed | Direct user inputs | Sessions |
|---|---:|---:|---:|
| Codex | 491 rollout files | 3,529 raw | 490 |
| OMP | History database | 1,187 raw | 239 |
| Grok | 381 history files | 467 | 136 |
| Antigravity (`agy`) | 127 transcripts | 394 | 122 |

The laptop audit excluded known agent prompts from the OMP direct-user counts.
Some Codex subagent rollouts can remain in the raw total.

### Server

| Tool | History reviewed | Direct user inputs | Sessions |
|---|---:|---:|---:|
| Codex | 92 rollout files | 359 raw | 92 threads |
| OMP | History database | 106 prompts | 18 |
| Grok | Logs only | No usable chat history | 0 indexed |
| Antigravity (`agy`) | Not installed | 0 | 0 |

The server OMP files contained many advisor messages. The audit excluded these
messages from the behavior analysis.

## Count Limits

The counts below are lexical signals. They overlap. They are not literal bug
counts. A message can match more than one pattern. Quoted text can also cause a
false match.

## Most Common Failure Patterns

### 1. The Agent Claims Completion Without Real Proof

Laptop signal: 759 messages in 460 sessions.

Server signal: 29 of 72 projected Codex user messages in 12 threads asked for
verification. Raw Codex data also had 33 `check` signals in 24 sessions.

Common failure:

- The source changed, but the live process did not use the change.
- A build passed, but the device, browser, compositor, VM, or service path did
  not run.
- A queued job was reported as a completed job.
- A visual fix was checked in code but not in the complete interaction path.

Preventive control: use `verify-real-behavior`. State the evidence level and
the untested paths.

### 2. The Agent Breaks A Git Or Publication Boundary

Laptop signal: 553 messages in 309 sessions.

Common failure:

- The agent uses the wrong account or identity.
- The agent changes an exact commit message.
- The agent commits after a `do not commit` instruction.
- The agent pushes without permission.
- The agent does not verify the remote head after a push or merge.
- The agent files a pull request from a stale or incorrect diff.

Preventive control: treat identity, commit, push, merge, and publication rules
as hard task requirements. Use `file-a-pr` for pull request work.

### 3. The Agent Changes The Wrong Surface Or Damages Existing Work

Laptop signal: 363 messages in 250 sessions.

Common failure:

- The agent edits the wrong widget or component.
- A narrow texture or style task changes layout behavior.
- A cleanup removes a feature that the user wanted to retain.
- The agent overwrites progress or mixes unrelated changes into the task.

Preventive control: inspect the dirty worktree, state what must remain, and
stage only task files. Use a separate worktree when the user asks for one.

### 4. The Agent Stops At A Partial Result

Laptop signal: 270 messages in 174 sessions.

Common failure:

- The agent stops after a plan or a first patch.
- The agent changes one client but not the other clients or adapters.
- The agent omits tests, documents, generated files, runtime proof, or the
  authorized Git action.
- An interrupted or failed turn is treated as completed work.

Preventive control: define a checkable exit condition. Use
`finish-the-work` and `hit-every-surface` for broad work.

### 5. The Agent Repeats A Failed Action Instead Of Diagnosing It

The server OMP history had 45 tool errors. The largest groups were 19 write
errors and 9 shell errors.

Common failure:

- The agent retries the same path or command without checking the input,
  permission, or current state.
- The agent applies another visible tweak when the original UI failure still
  exists.

Preventive control: inspect the exact failure before a retry. Change the
hypothesis when the evidence rejects it.

## Where Frustration Usually Appears

The laptop data had 161 direct correction signals in 134 sessions. It had 156
profanity or anger signals in 118 sessions. These are upper bounds because a
prompt can contain pasted or quoted text.

The server data had six explicit profanity signals in six Codex sessions. The
server did not show sustained yelling. Uppercase text was not useful because
technical acronyms caused many false matches.

Frustration most often followed one of these events:

1. The visible problem was still present after the agent claimed a fix.
2. The agent changed the wrong UI element or added an unwanted element.
3. The agent regressed correct work outside the requested scope.
4. The agent damaged Git history, used the wrong account, or lost progress.
5. The agent stopped early after a direct request for complete work.
6. The agent ignored a constraint such as `only`, `must`, or `do not`.

The useful signal is the event before the frustration. Fleet rules target that
event. They do not try to classify the user's tone.

## Stable Preferences From The Audit

- Verify the real behavior before you report success.
- Preserve unrelated changes and explicit no-write boundaries.
- Get permission before commit, push, merge, deploy, or publication.
- Use exact user wording for an exact commit message.
- Complete all applicable paths when the request says `everything` or
  `end to end`.
- Inspect actual code, types, paths, process state, and remote state.
- Report failed checks and important untested paths.
- After a correction, apply the corrected constraint to the full affected
  path.

## Privacy And Security Findings

- The laptop `pico` Fish function contains a plain-text login secret in a
  world-readable configuration file.
- Credential-like files under `/home/radhey/cliproxy-auth-files` have mode
  `0644`.
- Many local Codex, OMP, Grok, and Antigravity history files have mode `0644`.
  They can contain prompts, paths, and tool output.
- The server Codex, OMP, and Grok credential files that the audit checked have
  mode `0600`.
- Raw session files on both hosts contain private text and must be treated as
  sensitive data.

Recommended follow-up:

1. Rotate the server login secret.
2. Replace password-based alias login with an SSH key or a secret store.
3. Review the credential-like file permissions and change private files to
   mode `0600` when the owning application permits it.
4. Review the agent-history threat model before a bulk permission change.

This task did not change credentials or file permissions.

