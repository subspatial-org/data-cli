# Command reference

Every command, in the order `subspatial help` lists them. Flags can go before or after the other arguments. `REF` is a branch or commit; see [references](getting-started.md#references). Most commands also take `--json`, which prints the result as JSON instead of the messages shown here.

Failed commands print `subspatial: CODE: MESSAGE (request ID)` to standard error and exit with status 1.

Some flags below (cache, block size and similar tuning options) don't appear in `subspatial help`. The defaults are right for almost everyone.

## version

```sh
subspatial version
```

Prints the version, system and whether mounting is built in, for example `subspatial VERSION (linux/amd64; native_mount=true)`. Takes no arguments. `subspatial --version` does the same.

## login

```sh
subspatial login [--api URL] [--token TOKEN | --username LOCAL_USER]
```

Signs in. With no flags it starts the device code flow. See [Authentication](authentication.md).

| Flag | Default | Meaning |
|---|---|---|
| `--api URL` | the saved site, else `https://app.subspatial.io` | Site to sign in to. It is saved. |
| `--token TOKEN` | none | Use an existing personal token. |
| `--username NAME` | none | Sign in as a local development user. Not with `--token`. |

```sh
subspatial login --api https://app.subspatial.io
```

## token

```sh
subspatial token (set [--stdin] [TOKEN] | status | remove)
```

`set` stores a token, `status` checks the stored one, `remove` deletes it. `--stdin` (default off) reads the token from standard input.

```sh
subspatial token status
```

## repo list

```sh
subspatial repo list [--owner OWNER] [--limit N]
```

| Flag | Default | Meaning |
|---|---|---|
| `--owner OWNER` | all | Only this owner's repositories. |
| `--limit N` | 100 | Most results. |
| `--cursor VALUE` | none | Continue from a `Next cursor`. |
| `--json` | off | JSON output. |

```sh
subspatial repo list --owner subspatial
```

## repo create

```sh
subspatial repo create [--visibility public|private] [--description TEXT] OWNER/REPO
```

| Flag | Default | Meaning |
|---|---|---|
| `--visibility` | `private` | `public` or `private`. |
| `--description TEXT` | empty | Description. |
| `--default-branch NAME` | `main` | Default branch. |
| `--json` | off | JSON output. |

```sh
subspatial repo create --visibility private YOUR-USERNAME/my-data
```

## repo archive, repo unarchive

```sh
subspatial repo archive OWNER/REPO
subspatial repo unarchive OWNER/REPO
```

Makes a repository read-only, or writable again. Flag: `--json` (off). See [Repositories](repositories.md#archive).

```sh
subspatial repo archive YOUR-USERNAME/my-data
```

## repo delete

```sh
subspatial repo delete [--yes] OWNER/REPO
```

Deletes a private repository; it can be restored for 30 days. Public repositories can't be deleted; archive them instead.

| Flag | Default | Meaning |
|---|---|---|
| `--yes` | off | Don't ask you to type the name to confirm. |
| `--json` | off | JSON output. |

```sh
subspatial repo delete YOUR-USERNAME/my-data
```

## repo restore

```sh
subspatial repo restore OWNER/REPO
```

Brings back a deleted repository within 30 days. Flag: `--json` (off).

```sh
subspatial repo restore YOUR-USERNAME/my-data
```

## browse

```sh
subspatial browse [--prefix PATH] OWNER/REPO@REF[/PATH]
```

| Flag | Default | Meaning |
|---|---|---|
| `--prefix PATH` | empty | Only entries under this path. |
| `--limit N` | 1000 | Most results. |
| `--cursor VALUE` | none | Continue from a `Next cursor`. |
| `--json` | off | JSON output. |

```sh
subspatial browse subspatial/empiar-11830@main
```

## upload

```sh
subspatial upload [--expected-head COMMIT] LOCAL OWNER/REPO@BRANCH/PATH
```

| Flag | Default | Meaning |
|---|---|---|
| `--expected-head COMMIT` | the branch's current head | Head the branch must still be at. |
| `--content-type TYPE` | `application/octet-stream` | Content type of the file. |
| `--json` | off | JSON output. |

Stages a file; it is not published until committed. See [Files](files.md#upload).

```sh
subspatial upload ./scan-001.mrc YOUR-USERNAME/my-data@main/raw/scan-001.mrc
```

## download

```sh
subspatial download [--resume] [--shared] OWNER/REPO@REF/PATH LOCAL
```

| Flag | Default | Meaning |
|---|---|---|
| `--resume` | on (`--resume=false` turns it off) | Continue from a `LOCAL.part` file. |
| `--shared` | off | Make the file 0644 and new folders 0755, instead of 0600 and 0700. |
| `--cache DIR` | the `cache` folder in the config folder | Content cache. |
| `--json` | off | JSON output. |

```sh
subspatial download subspatial/empiar-11830@main/PATH ./local-file
```

## branch create

```sh
subspatial branch create OWNER/REPO@FROM NAME
```

Flag: `--json` (off). See [Collaboration](collaboration.md#branches).

```sh
subspatial branch create YOUR-USERNAME/my-data@main reprocessed-scans
```

## commit

```sh
subspatial commit -m MESSAGE [--expected-head COMMIT] LOCAL OWNER/REPO@BRANCH/PATH
```

| Flag | Default | Meaning |
|---|---|---|
| `-m`, `--message` | none (required) | Commit message. |
| `--expected-head COMMIT` | the branch's current head | Head the branch must still be at. |
| `--json` | off | JSON output. |

```sh
subspatial commit -m "Add the first scan" ./scan-001.mrc YOUR-USERNAME/my-data@main/raw/scan-001.mrc
```

## fork

```sh
subspatial fork --owner OWNER [--name NAME] OWNER/REPO
```

| Flag | Default | Meaning |
|---|---|---|
| `--owner OWNER` | none (required) | Owner of the fork. |
| `--name NAME` | the original name | Name of the fork. |
| `--visibility` | `public` | `public` or `private`. |
| `--json` | off | JSON output. |

```sh
subspatial fork --owner YOUR-USERNAME subspatial/empiar-11830
```

## pr create

```sh
subspatial pr create --source OWNER/REPO@BRANCH --title TITLE OWNER/REPO@TARGET
```

| Flag | Default | Meaning |
|---|---|---|
| `--source OWNER/REPO@BRANCH` | none (required) | Branch with your changes. |
| `--title TITLE` | none (required) | Title. |
| `--body TEXT` | empty | Description. |
| `--draft` | off | Create as a draft. |
| `--json` | off | JSON output. |

```sh
subspatial pr create --source YOUR-USERNAME/my-data@reprocessed-scans --title "Reprocessed scans" YOUR-USERNAME/my-data@main
```

## pr list

```sh
subspatial pr list OWNER/REPO
```

Flags: `--state STATE` (empty, no filter), `--json` (off).

```sh
subspatial pr list YOUR-USERNAME/my-data
```

## pr diff

```sh
subspatial pr diff OWNER/REPO NUMBER
```

Flag: `--json` (off). `NUMBER` is a positive whole number.

```sh
subspatial pr diff YOUR-USERNAME/my-data 4
```

## pr review

```sh
subspatial pr review --state comment|approve|request_changes OWNER/REPO NUMBER
```

| Flag | Default | Meaning |
|---|---|---|
| `--state` | `comment` | `comment`, `approve` or `request_changes`. |
| `--body TEXT` | empty | Review text. |
| `--json` | off | JSON output. |

```sh
subspatial pr review --state approve YOUR-USERNAME/my-data 4
```

## pr merge

```sh
subspatial pr merge [-m MESSAGE] [--expected-head COMMIT] OWNER/REPO NUMBER
```

| Flag | Default | Meaning |
|---|---|---|
| `-m MESSAGE` | empty | Merge message. |
| `--expected-head COMMIT` | the target branch's current head | Head the target branch must still be at. |
| `--json` | off | JSON output. |

```sh
subspatial pr merge -m "Merge reprocessed scans" YOUR-USERNAME/my-data 4
```

## release create

```sh
subspatial release create --tag TAG --name NAME OWNER/REPO@REF
```

| Flag | Default | Meaning |
|---|---|---|
| `--tag TAG` | none (required) | Release tag. |
| `--name NAME` | none (required) | Release name. |
| `--description TEXT` | empty | Description. |
| `--json` | off | JSON output. |

```sh
subspatial release create --tag v1.0 --name "Data for the paper" YOUR-USERNAME/my-data@main
```

## release list

```sh
subspatial release list OWNER/REPO
```

Flag: `--json` (off).

```sh
subspatial release list YOUR-USERNAME/my-data
```

## prefetch

```sh
subspatial prefetch [--include GLOB ...] [--shared] OWNER/REPO@REF DIRECTORY
```

| Flag | Default | Meaning |
|---|---|---|
| `--include GLOB` | all files | Only paths matching the glob. Repeatable. `**` is supported. |
| `--shared` | off | Files 0644 and folders 0755, instead of 0600 and 0700. |
| `--concurrency N` | 4 | Parallel transfers. |
| `--cache DIR` | the `cache` folder in the config folder | Content cache. |
| `--block-size BYTES` | 0, meaning 8 MiB | Range-cache block size. |
| `--cache-capacity BYTES` | 0, meaning 8 GiB | Range-cache size. |
| `--readahead N` | 0, meaning 1 | Blocks to read ahead. |
| `--no-readahead` | off | Turn read-ahead off. |
| `--offline` | off | Use only verified cached data. |
| `--json` | off | JSON output. |

```sh
subspatial prefetch --include "raw/*.mrc" subspatial/empiar-11830@main ./empiar-data
```

## mount

```sh
subspatial mount [--write] OWNER/REPO@REF[/PREFIX] DIRECTORY
```

Linux only, experimental. See [Mounting](mount.md).

| Flag | Default | Meaning |
|---|---|---|
| `--write` | off | Private writable overlay. |
| `--include GLOB` | all files | Only paths matching the glob. Repeatable. |
| `--device ID` | empty | Device identifier. |
| `--cache DIR` | the `cache` folder in the config folder | Verified content cache. |
| `--state-dir DIR` | a private folder chosen by `subspatial` | Overlay state folder. |
| `--block-size BYTES` | 0, meaning 8 MiB | Range-cache block size. |
| `--cache-capacity BYTES` | 0, meaning 8 GiB | Range-cache size. |
| `--readahead N` | 0, meaning 1 | Blocks to read ahead. |
| `--no-readahead` | off | Turn read-ahead off. |
| `--offline` | off | Use only verified cached data. |
| `--debug-fuse` | off | Verbose FUSE diagnostics. |

```sh
subspatial mount subspatial/empiar-11830@main ~/mnt/empiar
```

## mount status

```sh
subspatial mount status DIRECTORY
```

Flag: `--json` (off).

```sh
subspatial mount status ~/mnt/empiar
```

## mount commit

```sh
subspatial mount commit -m MESSAGE DIRECTORY
```

Flags: `-m`, `--message` (required), `--json` (off).

```sh
subspatial mount commit -m "Fix the labels" ~/mnt/my-data
```

## mount unmount

```sh
subspatial mount unmount DIRECTORY
```

No flags.

```sh
subspatial mount unmount ~/mnt/empiar
```

## mount-session create

```sh
subspatial mount-session create [--write] OWNER/REPO@REF[/PREFIX]
```

| Flag | Default | Meaning |
|---|---|---|
| `--write` | off | Writable session. |
| `--device ID` | empty | Device identifier. |
| `--json` | off | JSON output. |

```sh
subspatial mount-session create YOUR-USERNAME/my-data@main
```

## mount-session materialize

```sh
subspatial mount-session materialize [--write] [--shared] OWNER/REPO@REF[/PREFIX] DIRECTORY
```

| Flag | Default | Meaning |
|---|---|---|
| `--write` | off | Writable, so changes can be committed. |
| `--shared` | off | Files 0644 and folders 0755, instead of 0600 and 0700. |
| `--force` | off | Allow a destination that is not empty. |
| `--include GLOB` | all files | Only paths matching the glob. Repeatable. |
| `--concurrency N` | 4 | Parallel transfers. |
| `--device ID` | empty | Device identifier. |
| `--json` | off | JSON output. |

```sh
subspatial mount-session materialize --write YOUR-USERNAME/my-data@main ./my-data-local
```

## mount-session status

```sh
subspatial mount-session status DIRECTORY
```

Flag: `--json` (off).

```sh
subspatial mount-session status ./my-data-local
```

## mount-session commit

```sh
subspatial mount-session commit -m MESSAGE DIRECTORY
```

Flags: `-m`, `--message` (required), `--json` (off).

```sh
subspatial mount-session commit -m "Fix the labels" ./my-data-local
```

## refresh

```sh
subspatial refresh DIRECTORY
```

Flag: `--json` (off).

```sh
subspatial refresh ./my-data-local
```
