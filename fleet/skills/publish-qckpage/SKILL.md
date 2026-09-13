---
name: publish-qckpage
description: Publish a single-file HTML plan, report, preview, or other document with the qckpage CLI and return its public QckPages link. Use when the user asks to upload HTML, publish an HTML artifact, or share an HTML report.
---

# Publish with QckPages

Use QckPages for HTML that the user needs to open or share.

## Check the file

1. Confirm that the output is one `.html` or `.htm` file.
2. Confirm that the file exists and is complete.
3. Check local asset references. QckPages publishes one file. Inline local
   images, styles, and scripts, or use public URLs.
4. Do not publish credentials, private keys, tokens, or private raw logs.

Do not build the QckPages project for a normal publish. Use the installed
`qckpage` CLI. If the command is missing, stop and report that QckPages CLI
must be installed before publishing. The official Linux installer is:

```bash
curl -fsSL https://github.com/jR4dh3y/qckpages/releases/latest/download/install.sh | bash
```

Run the installer only when the user asks for installation or authorizes it.

## Check login

Run:

```bash
qckpage status
```

If the CLI is not logged in, run `qckpage login`. The CLI opens QckPages so a
human can create or paste an API key. Never put the API key in a command,
shell history, report, or chat message.

## Publish

Choose a short lowercase slug from the document name. Use a more specific slug
when the default slug could replace or confuse an existing page. Check existing
pages with `qckpage list` before reusing a slug.

Publish the file:

```bash
qckpage publish ./plan.html --slug plan-review --title "Plan review"
```

The CLI also accepts the short option form:

```bash
qckpage publish ./report.html -s weekly-report -t "Weekly report"
```

The command prints a `Link:` line after a successful publish. Read that URL
from the command result. Do not invent a URL from the slug.

## Return the result

Return the public link in Markdown:

```markdown
[Open the plan](https://qckpage.jr4.in/plan-review)
```

State the file name and slug. State when the publish command failed. Do not
claim that the page is reachable unless you checked the returned URL.
