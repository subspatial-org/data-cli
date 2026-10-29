# Repositories

## List repositories

```sh
subspatial repo list [--owner OWNER] [--limit N]
```

Prints a table with the columns `REPOSITORY`, `VISIBILITY`, `STATE` and `DEFAULT BRANCH`. Use `--owner` to show one person's or organization's repositories. `--limit` is the most rows to return, and it defaults to 100.

```sh
subspatial repo list --owner subspatial
```

If there are more results, the last line is `Next cursor: VALUE`. Pass that value as `--cursor VALUE` to get the next page.

## Create a repository

```sh
subspatial repo create [--visibility public|private] [--description TEXT] [--default-branch NAME] OWNER/REPO
```

```sh
subspatial repo create --visibility private --description "Raw scans from the spring runs" YOUR-USERNAME/my-data
```

It prints `Created YOUR-USERNAME/my-data (private).` The argument is `OWNER/REPO` only, with no `@ref`.

- `--visibility` is `private` by default. The only other value is `public`.
- `--description` is empty by default.
- `--default-branch` is `main` by default.

## Fork a repository

A fork is your own copy of someone else's repository. You can change it freely and then propose your changes back with a [pull request](collaboration.md).

```sh
subspatial fork --owner OWNER [--name NAME] [--visibility public|private] OWNER/REPO
```

```sh
subspatial fork --owner YOUR-USERNAME subspatial/empiar-11830
```

`--owner` is required: it is who will own the fork. `--name` is the new repository's name, and defaults to the original name. `--visibility` defaults to `public`. It prints `Forked to YOUR-USERNAME/empiar-11830 at main.`, where the last word is the fork's default branch.

## Archive, delete and restore

Public repositories can be archived but not deleted, because other people may rely on them. Private repositories can be deleted, and restored for 30 days afterwards. These commands need a version of `subspatial` that includes them; check `subspatial help`.

### Archive

```sh
subspatial repo archive YOUR-USERNAME/my-data
```

Archiving makes a repository read-only: everyone who could see it still can, and can still download from it, but nobody can commit to it or open pull requests until it is unarchived. It prints `Archived YOUR-USERNAME/my-data. It is now read-only; undo with: subspatial repo unarchive YOUR-USERNAME/my-data`. Any repository can be archived, public or private.

```sh
subspatial repo unarchive YOUR-USERNAME/my-data
```

Makes it writable again and prints `Unarchived YOUR-USERNAME/my-data.`

### Delete

```sh
subspatial repo delete YOUR-USERNAME/my-data
```

`subspatial` asks you to type the full repository name to confirm. Anything else, including an empty line, cancels and leaves the repository alone. Pass `--yes` to skip the question in scripts. It prints `Scheduled YOUR-USERNAME/my-data for deletion. Restore it within the recovery window with: subspatial repo restore YOUR-USERNAME/my-data`.

Only private repositories can be deleted. For a public one, `subspatial` stops with `YOUR-USERNAME/my-data is public, and public repositories can't be deleted. Archive it instead: subspatial repo archive YOUR-USERNAME/my-data`. If you really need it gone, make it private first on the website, then delete it.

### Restore

```sh
subspatial repo restore YOUR-USERNAME/my-data
```

Brings back a deleted repository within 30 days of deleting it, and prints `Restored YOUR-USERNAME/my-data.` After 30 days it is gone for good, and `restore` says the recovery window has expired.
