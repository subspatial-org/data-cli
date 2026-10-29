# Files

For how to write references like `OWNER/REPO@REF/PATH`, see [Getting started](getting-started.md#references).

## Browse

```sh
subspatial browse [--prefix PATH] [--limit N] OWNER/REPO@REF[/PATH]
```

Lists the files and folders in a repository at a branch or commit, as a table: `TYPE`, `SIZE` (bytes), `CHECKSUM` and `PATH`. `--limit` is the most rows to print and defaults to 1000. If there are more, the last line is `Next cursor: VALUE`; pass it as `--cursor VALUE` for the next page.

## Download

```sh
subspatial download [--resume=false] [--shared] OWNER/REPO@REF/PATH LOCAL
```

```sh
subspatial download subspatial/empiar-11830@main/PATH ./local-file
```

Downloads one file. `LOCAL` is where to put it. The reference must include a path. On success it prints `Downloaded PATH to LOCAL (N bytes).` The file is checked against its checksum before it appears at `LOCAL`.

**Resuming.** While a download runs, the data goes into `LOCAL.part`. If the download stops, run the same command again and it carries on from the `.part` file. This is on by default (`--resume` defaults to true). To throw the partial file away and start again, pass `--resume=false`.

**Who can read the file.** Files `subspatial` writes are private to you: mode 0600, and 0700 for any folder it creates. Pass `--shared` to make the file 0644 (and new folders 0755) so other people on the same computer can read it. This matters on shared lab machines and clusters.

`--cache DIR` changes where `subspatial` keeps its download cache. The default is a `cache` folder in the [config folder](authentication.md#where-settings-are-stored).

## Upload

```sh
subspatial upload [--expected-head COMMIT] [--content-type TYPE] LOCAL OWNER/REPO@BRANCH/PATH
```

Uploads a file to a staging area. It does not change the repository. It prints `Uploaded PATH (N bytes); staged handle HANDLE. Commit explicitly to publish.` `--content-type` defaults to `application/octet-stream`. If you don't give `--expected-head`, `subspatial` looks up the branch's current head first. To add a file to a repository, use `commit`.

## Commit

```sh
subspatial commit -m MESSAGE [--expected-head COMMIT] LOCAL OWNER/REPO@BRANCH/PATH
```

```sh
subspatial commit -m "Add the first scan" ./scan-001.mrc YOUR-USERNAME/my-data@main/raw/scan-001.mrc
```

Uploads `LOCAL` and publishes it as one commit to the branch, at `PATH`. If `PATH` already exists, the file is replaced in the new commit; the older version stays in the repository's history. `-m` (or `--message`) is required and cannot be blank. On success it prints `Committed atomically as COMMIT-ID.`

`@BRANCH` must be a branch you can write to. Each commit adds one file.

### `--expected-head` and conflicts

A branch's head is its newest commit. `commit` publishes on top of the head it saw when it started. If you don't pass `--expected-head`, it looks up the head itself at the start of the command. If someone else commits to the branch before yours lands, the server refuses yours so that it cannot silently hide their change. The error has the code `branch_head_changed`.

To be sure you are building on a particular version, pass its commit id with `--expected-head COMMIT`. If the branch has moved on, the commit is refused. Browse the branch again to see what changed, then run your command again.

## Prefetch

```sh
subspatial prefetch [--include GLOB ...] [--shared] OWNER/REPO@REF DIRECTORY
```

```sh
subspatial prefetch --include "raw/*.mrc" subspatial/empiar-11830@main ./empiar-data
```

Downloads many files from a repository into `DIRECTORY` in one go. The reference needs `@REF` and may end in a folder path to download just that folder. `--include` limits what is downloaded to paths matching a glob, and you can repeat it. `**` matches across folders. An empty `--include` value is refused. When it finishes it prints `Prefetched N files (N bytes) into DIRECTORY.`

Other options: `--concurrency N` (parallel transfers, default 4), `--cache DIR`, `--block-size`, `--cache-capacity`, `--readahead`, `--no-readahead`, `--offline` and `--json`. See the [command reference](command-reference.md#prefetch). `--shared` works as it does for `download`.

## File permissions

Everything `subspatial` writes to disk with `download`, `prefetch`, `mount-session materialize` and `refresh` is private by default: files are 0600 and folders are 0700. Add `--shared` to make files 0644 and folders 0755. `refresh` keeps the choice the folder was made with.

## Refresh

```sh
subspatial refresh DIRECTORY
```

If you made a folder with `subspatial mount-session materialize`, `refresh` moves it to the branch's newest version and downloads what changed. It prints `Refreshed pinned snapshot to COMMIT-ID (N files transferred).` It refuses to run if the folder has local changes: `workspace has local changes; commit or revert them before refresh`. See [Mounting](mount.md).
