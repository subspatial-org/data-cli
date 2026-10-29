# Collaboration

Branches, pull requests and releases let several people work on the same repository without overwriting each other. For how references like `OWNER/REPO@BRANCH` work, see [Getting started](getting-started.md#references).

## Branches

```sh
subspatial branch create OWNER/REPO@FROM NAME
```

```sh
subspatial branch create YOUR-USERNAME/my-data@main reprocessed-scans
```

Makes a new branch called `NAME`, starting from `FROM` (a branch or commit). It prints `Created branch NAME at COMMIT-ID.` Then commit to it with `subspatial commit ... YOUR-USERNAME/my-data@reprocessed-scans/PATH`.

## Pull requests

A pull request proposes merging one branch into another so that others can look at it first.

### Create

```sh
subspatial pr create --source OWNER/REPO@BRANCH --title TITLE [--body TEXT] [--draft] OWNER/REPO@TARGET
```

```sh
subspatial pr create --source YOUR-USERNAME/my-data@reprocessed-scans --title "Reprocessed scans" YOUR-USERNAME/my-data@main
```

`--source` is the branch with your changes. It can be in a fork. The last argument is the branch you want to merge into. `--title` and `--source` are required. `--draft` creates it as a draft. It prints `Created pull request #N: TITLE`.

### List

```sh
subspatial pr list [--state STATE] OWNER/REPO
```

Prints `NUMBER`, `STATE`, `SOURCE`, `TARGET` and `TITLE`. `--state` filters by state: `open`, `blocked`, `closed` or `merged`. With no `--state`, all pull requests are listed.

### Diff

```sh
subspatial pr diff OWNER/REPO NUMBER
```

Prints the files the pull request changes: `CHANGE`, `OLD SIZE`, `NEW SIZE` and `PATH`.

### Review

```sh
subspatial pr review --state comment|approve|request_changes [--body TEXT] OWNER/REPO NUMBER
```

```sh
subspatial pr review --state approve --body "Looks right to me" YOUR-USERNAME/my-data 4
```

`--state` is `comment` by default; `approve` and `request_changes` are the other two. It prints `Submitted STATE review.`

### Merge

```sh
subspatial pr merge [-m MESSAGE] [--expected-head COMMIT] OWNER/REPO NUMBER
```

Merges the pull request into its target branch and prints `Merged pull request as COMMIT-ID.` `-m` sets the merge message.

`--expected-head` works as it does for [`commit`](files.md#expected-head-and-conflicts), but it is the head of the **target** branch. If you leave it out, `subspatial` looks up the target branch's head when you run the command. If the target branch has moved on since you passed `--expected-head`, the merge is refused.

If the pull request can't be merged cleanly, the merge is refused and nothing changes on the target branch.

## Releases

A release gives a name and a tag to one version of a repository, so you can point to it later (for example in a paper).

```sh
subspatial release create --tag TAG --name NAME [--description TEXT] OWNER/REPO@REF
subspatial release list OWNER/REPO
```

```sh
subspatial release create --tag v1.0 --name "Data for the paper" YOUR-USERNAME/my-data@main
```

`create` prints `Created release TAG at COMMIT-ID.` `--tag` and `--name` are required. `list` prints `TAG`, `COMMIT` and `NAME`.
