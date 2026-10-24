# data: the subspatial command-line client

`data` is the command-line client for [subspatial](https://app.subspatial.io). With it you can browse, download and upload data in subspatial repositories, and work with branches, commits and pull requests from a terminal.

**You need a subspatial account to use it.** subspatial is in a closed alpha, and accounts are by invitation only; without one, `data` can do no more than list what the public website already shows.

This repository holds only the release builds. Downloads are on the [Releases page](https://github.com/subspatial-org/data-cli/releases).

> [!WARNING]
> **This is an unsigned pilot build for the closed alpha.** The binaries are not code-signed, and the macOS builds are not notarized by Apple. Check every download against `SHA256SUMS` (below) before you run it. Signed builds will come later.

## What works in this pilot

| | Linux (amd64, arm64) | macOS (Apple silicon, Intel) |
|---|---|---|
| Sign in, browse, download, upload | Yes | Yes |
| Branches, commits, forks, pull requests, releases | Yes | Yes |
| `data mount` (see a repository as a folder) | **Experimental**: needs FUSE 3 | Not supported in this pilot |

## Install

Pick the file for your system from the [latest release](https://github.com/subspatial-org/data-cli/releases/latest):

| System | File |
|---|---|
| Linux, Intel/AMD | `data-platform-client-VERSION-linux-amd64.unsigned.tar.gz` |
| Linux, ARM | `data-platform-client-VERSION-linux-arm64.unsigned.tar.gz` |
| macOS, Apple silicon (M1 and later) | `data-platform-client-VERSION-darwin-arm64.unsigned.zip` |
| macOS, Intel | `data-platform-client-VERSION-darwin-amd64.unsigned.zip` |

### 1. Download and check the file

Download your file and `SHA256SUMS` into the same folder, then check the file. On Linux:

```sh
sha256sum --check --ignore-missing SHA256SUMS
```

On macOS:

```sh
shasum -a 256 --check --ignore-missing SHA256SUMS
```

Your file must show `OK`. If it shows anything else, don't run it; tell us instead.

### 2. Unpack it and put `data` on your PATH

On Linux:

```sh
tar -xzf data-platform-client-*-linux-*.unsigned.tar.gz
mkdir -p ~/.local/bin
cp data-platform-client-*/data data-platform-client-*/datad ~/.local/bin/
```

On macOS:

```sh
unzip data-platform-client-*-darwin-*.unsigned.zip
mkdir -p ~/.local/bin
cp data-platform-client-*/data data-platform-client-*/datad ~/.local/bin/
xattr -c ~/.local/bin/data ~/.local/bin/datad
```

The last line is needed because the build is unsigned. A file downloaded with a browser carries macOS's quarantine flag, and without that line macOS refuses to run `data`: a "“data” Not Opened" window offers **Move to Trash** or **Done**, and the terminal prints `zsh: killed`. If you see that, click **Done** (not Move to Trash), run the `xattr -c` line, and try again. If `~/.local/bin` isn't on your PATH, add `export PATH="$HOME/.local/bin:$PATH"` to your shell's startup file (`~/.zshrc` on macOS, `~/.bashrc` on most Linux systems), then open a new terminal.

Check it runs:

```sh
data version
```

## Sign in

```sh
data login --api https://app.subspatial.io
```

`data` prints an address and a code. Open the address in a browser where you are signed in to subspatial, check the code matches, and approve. The terminal then says `Logged in to https://app.subspatial.io as <your username>.`

## Use it

Every repository page on subspatial has a **Code** menu with ready-made commands for that repository; copy them from there. Some examples:

```sh
# List what's in a repository
data browse subspatial/empiar-11830@main

# Download a file or folder
data download subspatial/empiar-11830@main/PATH ./local-folder

# Create a private repository of your own and add a file to it
data repo create --visibility private YOUR-USERNAME/my-data
data commit -m "Add the first scan" ./scan-001.mrc YOUR-USERNAME/my-data@main/raw/scan-001.mrc
```

`data commit` uploads the file and publishes it in one step. (`data upload` only stages a file; nothing appears in the repository until it is committed.)

Run `data help` for every command.

### Mounting (Linux only, experimental)

`data mount` shows a repository snapshot as a folder and downloads files only when you open them. It needs FUSE 3 (`fuse3` on Debian/Ubuntu and Fedora). It is experimental in this pilot: if something goes wrong, use `data download` instead, and tell us what happened.

```sh
mkdir -p ~/mnt/empiar
data mount subspatial/empiar-11830@main ~/mnt/empiar
```

`data mount` keeps running while the folder is mounted. Open the folder from another terminal, and when you're done, unmount it from there too:

```sh
data mount unmount ~/mnt/empiar
```

## Feedback and problems

Send bugs, questions and suggestions to the subspatial team through your alpha contact. Include the output of `data version` and the command you ran. Never send your token or the contents of the `data` config folder.

## License

Apache License 2.0; see [LICENSE](LICENSE).
