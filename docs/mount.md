# Mounting

`subspatial mount` shows a repository as a folder on your computer. Files are downloaded only when you open them. It is **Linux only and experimental** in this pilot. If something goes wrong, use [`subspatial download`](files.md#download) instead, and tell us what happened.

You need FUSE 3 (the `fuse3` package on Debian, Ubuntu and Fedora). To check whether your copy of `subspatial` includes mounting, run `subspatial version`; it ends with `native_mount=true` or `native_mount=false`. <!-- TODO(review): README says macOS mounting is not supported in this pilot, but usageText mentions macFUSE. Documented as Linux only to match the README. -->

## Mount

```sh
subspatial mount [--write] OWNER/REPO@REF[/PREFIX] DIRECTORY
```

```sh
mkdir -p ~/mnt/empiar
subspatial mount subspatial/empiar-11830@main ~/mnt/empiar
```

Create `DIRECTORY` first (the example does this with `mkdir -p`). The mount shows one fixed snapshot of the repository: the version `REF` pointed to when you ran the command. It will not change if someone commits afterwards. Add a folder after the ref (`@main/raw`) to mount only that folder. `--include GLOB` (repeatable) limits the files shown.

When it works it prints `Mounted native MODE snapshot COMMIT-ID at DIRECTORY. Keep this process running; use subspatial mount status|commit|unmount from another shell.` `MODE` is `read` or `write`. The command keeps running while the folder is mounted, so use another terminal for the commands below.

By default the mount is read-only. With `--write`, you get a private overlay where your changes are kept on your computer. Nothing is published until you run `subspatial mount commit`.

Other options are in the [command reference](command-reference.md#mount): `--cache`, `--state-dir`, `--device`, `--block-size`, `--cache-capacity`, `--readahead`, `--no-readahead`, `--offline` and `--debug-fuse`.

## Status, commit and unmount

Run these from another terminal. `DIRECTORY` is the mount folder.

```sh
subspatial mount status DIRECTORY
```

Prints `Native mount pinned to COMMIT-ID (MODE).`, then one line per change (the kind of change, a tab, then the path), or `No local changes.`

```sh
subspatial mount commit -m MESSAGE DIRECTORY
```

Publishes the changes in your write overlay as one commit. It prints `Committed mount overlay atomically as COMMIT-ID; the mount is now pinned to that snapshot.` `-m` is required.

```sh
subspatial mount unmount DIRECTORY
```

Prints `Unmount requested for DIRECTORY.` Run `subspatial mount commit` first if you want to keep your changes: changes you haven't committed are never published, and you shouldn't rely on getting them back after unmounting.

## Without the kernel mount: mount sessions

`mount-session` does the same job without FUSE. It downloads a snapshot into an ordinary folder, so it works on macOS and on Linux machines without FUSE. The cost is that it downloads everything up front (use `--include` to limit it).

```sh
subspatial mount-session materialize [--write] [--shared] [--include GLOB ...] [--force] OWNER/REPO@REF[/PREFIX] DIRECTORY
```

```sh
subspatial mount-session materialize --write YOUR-USERNAME/my-data@main ./my-data-local
```

It prints `Materialized N files pinned to COMMIT-ID in MODE mode. This is a POSIX-like userspace snapshot, not a kernel mount.` It refuses a destination that isn't empty unless you pass `--force`. Files are private to you unless you pass `--shared`.

Then work in the folder as usual and use:

```sh
subspatial mount-session status DIRECTORY
subspatial mount-session commit -m MESSAGE DIRECTORY
subspatial refresh DIRECTORY
```

- `status` prints `Workspace OWNER/REPO@REF pinned to COMMIT-ID (MODE).`, then one line per change, or `No local changes.`
- `commit` publishes your changes as one commit and prints `Committed workspace atomically as COMMIT-ID; workspace advanced to the new snapshot.` It needs `--write` at materialize time; a read-only folder is refused with `workspace is read-only`.
- [`refresh`](files.md#refresh) moves the folder to the newest version of the branch. It refuses if you have uncommitted changes.

`mount-session create [--write] OWNER/REPO@REF[/PREFIX]` only asks the server for a session and prints `Created MODE session ID pinned to COMMIT-ID. Materialize it for a POSIX-like userspace snapshot.` You rarely need it.

A materialized folder keeps its bookkeeping in a hidden `.data-platform` folder inside it. Leave it alone: without it, `status`, `commit` and `refresh` can't work.
