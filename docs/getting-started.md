# Getting started

This page assumes you have [installed `subspatial` and signed in](../README.md). Check that you are signed in:

```sh
subspatial token status
```

It prints `Token configured for <your username> (token value hidden).` If it says `No token configured.`, see [Authentication](authentication.md).

## References

Most commands take a reference that points at a repository, a version of it, and a file or folder inside it:

```
OWNER/REPO@REF/PATH
```

- `OWNER/REPO` is the repository, for example `subspatial/empiar-11830`.
- `REF` is the version you want: a branch name such as `main`, or a commit. A reference needs `@REF` for most commands.
- `PATH` is a file or folder inside the repository. It is written relative to the top of the repository, with no leading slash. End a folder path with a slash (`raw/`) to mean the folder.

Some commands need less than the full reference, and some need more:

| You write | It means | Used by |
|---|---|---|
| `subspatial/empiar-11830` | A repository | `repo create`, `pr list`, `release list` |
| `subspatial/empiar-11830@main` | A repository at a branch or commit | `browse`, `prefetch`, `mount`, `branch create` |
| `subspatial/empiar-11830@main/raw/scan-001.mrc` | One file | `download`, `commit`, `upload` |

Owner and repository names can contain letters, digits, `-`, `_` and `.`, but cannot start with `-`, `_` or `.`. A ref cannot contain spaces, `@`, backslashes or `..`.

## Find a repository

```sh
subspatial repo list
subspatial repo list --owner subspatial
```

The output is a table of repository, visibility, state and default branch. See [Repositories](repositories.md). Every repository page on the website also has a **Code** menu with ready-made commands.

## Browse

```sh
subspatial browse subspatial/empiar-11830@main
```

This prints a table with the columns `TYPE`, `SIZE`, `CHECKSUM` and `PATH`. To look inside a folder, add it to the reference, ending with a slash:

```sh
subspatial browse subspatial/empiar-11830@main/raw/
```

## Download

```sh
subspatial download subspatial/empiar-11830@main/PATH ./local-file
```

Downloading needs sign-in, even from a public repository. When it finishes it prints `Downloaded PATH to ./local-file (N bytes).` If the download is interrupted, run the same command again and it carries on from where it stopped. See [Files](files.md).

## Create a repository and commit your first file

```sh
subspatial repo create --visibility private YOUR-USERNAME/my-data
subspatial commit -m "Add the first scan" ./scan-001.mrc YOUR-USERNAME/my-data@main/raw/scan-001.mrc
```

The first command prints `Created YOUR-USERNAME/my-data (private).` The second uploads the file and publishes it as a commit in one step, and prints `Committed atomically as COMMIT-ID.` Check it:

```sh
subspatial browse YOUR-USERNAME/my-data@main
```

Repositories are private unless you pass `--visibility public`. The default branch is `main`.

## upload and commit

`subspatial commit` uploads a file and publishes it in one step. Use it when you want a file in the repository.

`subspatial upload` only uploads the file to a staging area. It prints `Uploaded PATH (N bytes); staged handle HANDLE. Commit explicitly to publish.` Nothing appears in the repository until a commit publishes it, and this command line has no separate way to commit a staged file, so you won't normally need `upload`. Use `commit`.

## Next

- [Files](files.md) for downloading whole folders and handling conflicts.
- [Collaboration](collaboration.md) for branches and pull requests.
- [Mounting](mount.md) to see a repository as a folder.
