---
name: share-with-fbs
description: Upload videos, screenshots, images, PDFs, logs, and other files with the fbs CLI and return a shareable link. Use when the user asks an agent to attach, send, upload, or share a local file or generated artifact.
---

# Share with FBS

Use FBS for files that the user needs to download or open.

## Check the file

1. Find the exact local file path.
2. Confirm that it is a regular file and that its size is reasonable.
3. Check that it does not contain a password, token, private key, or private
   chat transcript.
4. Preserve the original file. Upload it as a copy.

Use the installed `fbs` command. If it is missing, report that FBS CLI must be
installed. The source project is `/home/radhey/code/fbs/fbs-cli`; do not build
or install it during a normal share unless the user asks.

## Check login

Run:

```bash
fbs status
```

If the CLI is not authenticated, run `fbs login` in a terminal. It reads the
Bearer and SigV4 credentials without echo and saves them with user-only file
permissions. Never print, copy, or pass those credentials in a command.

FBS also accepts these environment variables for an ephemeral session:
`FBS_URL`, `FBS_TOKEN`, `FBS_SIGV4_ACCESS_KEY`, and `FBS_SIGV4_SECRET_KEY`.
Never include their values in a report or chat message.

## Upload a file

Use the `uploads` bucket unless the user gives another bucket. Use a clear key
when the default file name is not enough.

For a normal user-facing link, request the maximum signed lifetime of seven
days:

```bash
url="$(fbs upload ./video.mp4 --bucket uploads --expires 604800)"
```

FBS writes progress to stderr and writes only the URL to stdout. This makes
the command safe to capture in `url`. It detects the content type from the
file name. Override it only when detection is wrong:

```bash
url="$(fbs upload ./screen.webm --content-type video/webm --expires 604800)"
```

Use `--json` when the agent also needs the bucket, key, or expiry time. Do not
assume that the installed CLI supports permanent links. Check
`fbs upload --help` and `fbs link --help` first if the user asks for one.

## Link an existing object

Generate a new seven-day link without uploading again:

```bash
url="$(fbs link reports/plan.pdf --bucket uploads --expires 604800)"
```

Use `fbs list uploads --prefix reports/` when the object key is unknown.

## Return the result

Return a Markdown link with the file name:

```markdown
[Download the video](https://fbs.example/download)
```

State the link lifetime. Do not paste credentials or unrelated command output.
If the upload fails, report the error and do not provide a made-up link.
