# Security Rules

## Agent History

- Read only the history that is necessary for the audit.
- Extract patterns and counts. Do not copy full transcripts.
- Remove passwords, tokens, private keys, cookies, and personal identifiers.
- Store a session identifier only when it is necessary to verify a pattern.
- Do not publish the audit without a new review for private data.

## Credentials

- Store a private key in a protected credential file or an agent.
- Do not store a password in a shell alias, a repository, or a command line.
- Do not print a credential to verify that it exists.
- Use a reference to a secret, not the secret value.
- Rotate a credential when a command or log exposed it.

## Fleet Repository

- Do not add raw session exports.
- Do not add environment files.
- Do not add authentication databases or browser profiles.
- Run `./scripts/check.sh` before a commit.

