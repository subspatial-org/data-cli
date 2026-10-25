# subspatial: the command-line client

`subspatial` is the command-line client for [subspatial](https://app.subspatial.io). With it you can browse, download and add data in subspatial repositories, and work with branches, commits and pull requests from a terminal.

**You need a subspatial account to use it.** subspatial is in a closed alpha, and accounts are by invitation only; without one, `subspatial` can do no more than list what the public website already shows.

This repository holds only the release builds. Downloads are on the [Releases page](https://github.com/subspatial-org/data-cli/releases).

> [!WARNING]
> **This is an unsigned pilot build for the closed alpha.** The binaries are not code-signed, and the macOS builds are not notarized by Apple. Check every download against `SHA256SUMS` (below) before you run it. Signed builds will come later.

## What works in this pilot

| | Linux (amd64, arm64) | macOS (Apple silicon, Intel) |
|---|---|---|
| Sign in, browse, download, add files | Yes | Yes |
| Branches, commits, forks, pull requests, releases | Yes | Yes |
| `subspatial mount` (see a repository as a folder) | **Experimental**: needs FUSE 3 | Not supported in this pilot |

## Install

**macOS or Linux, one line:**

```sh
curl -fsSL https://raw.githubusercontent.com/subspatial-org/data-cli/main/install.sh | sh
```

The [script](install.sh) picks the build for your system, checks it against the release's `SHA256SUMS`, and installs `subspatial` into `/usr/local/bin`, which is already on your PATH. It may ask for your password once, for `sudo`. Then check it:

```sh
subspatial version
```

**Or with [Homebrew](https://brew.sh):**

```sh
brew install subspatial-org/tap/subspatial
```

Upgrade later with `brew upgrade subspatial`, or by running the install line again.

Neither way triggers macOS's "cannot be verified" block, because a file downloaded with `curl` or Homebrew doesn't get the quarantine flag that a browser adds.

<details>
<summary>Manual install (download the files yourself)</summary>

Pick the file for your system from the newest release on the [Releases page](https://github.com/subspatial-org/data-cli/releases):

| System | File |
|---|---|
| Linux, Intel/AMD | `subspatial-cli-VERSION-linux-amd64.unsigned.tar.gz` |
| Linux, ARM | `subspatial-cli-VERSION-linux-arm64.unsigned.tar.gz` |
| macOS, Apple silicon (M1 and later) | `subspatial-cli-VERSION-darwin-arm64.unsigned.zip` |
| macOS, Intel | `subspatial-cli-VERSION-darwin-amd64.unsigned.zip` |

Download your file and `SHA256SUMS` into the same folder, open a terminal there, and check the file (`sha256sum` on Linux, `shasum -a 256` on macOS). It must show `OK`; if not, don't run it, and tell us.

```sh
shasum -a 256 --check --ignore-missing SHA256SUMS
```

On Linux:

```sh
tar -xzf subspatial-cli-*-linux-*.unsigned.tar.gz
sudo install -m 0755 subspatial-cli-*/subspatial subspatial-cli-*/subspatiald /usr/local/bin/
```

On macOS:

```sh
unzip subspatial-cli-*-darwin-*.unsigned.zip
sudo mkdir -p /usr/local/bin
sudo install -m 0755 subspatial-cli-*/subspatial subspatial-cli-*/subspatiald /usr/local/bin/
sudo xattr -c /usr/local/bin/subspatial /usr/local/bin/subspatiald
```

The `xattr -c` line is needed because the build is unsigned and a browser download carries macOS's quarantine flag. Without it macOS refuses to run `subspatial`: a "“subspatial” Not Opened" window offers **Move to Trash** or **Done**, and the terminal prints `zsh: killed`. If you see that, click **Done** (not Move to Trash), run the `xattr -c` line, and try again.

To install without `sudo`, put the files in `~/.local/bin` instead (`mkdir -p ~/.local/bin && cp subspatial-cli-*/subspatial subspatial-cli-*/subspatiald ~/.local/bin/`), add `export PATH="$HOME/.local/bin:$PATH"` to `~/.zshrc` (macOS) or `~/.bashrc` (Linux), and open a new terminal. The install script does the same with `SUBSPATIAL_INSTALL_DIR=$HOME/.local/bin`.

</details>

## Sign in

```sh
subspatial login --api https://app.subspatial.io
```

`subspatial` prints an address and a code. Open the address in a browser where you are signed in to subspatial, check the code matches, and approve it straight away, because the code expires after a few minutes. The terminal then says `Logged in to https://app.subspatial.io as <your username>.`

## Use it

Every repository page on subspatial has a **Code** menu with ready-made commands for that repository; copy them from there. Some examples:

```sh
# List what's in a repository
subspatial browse subspatial/empiar-11830@main

# Download a file
subspatial download subspatial/empiar-11830@main/PATH ./local-file

# Create a private repository of your own and add a file to it
subspatial repo create --visibility private YOUR-USERNAME/my-data
subspatial commit -m "Add the first scan" ./scan-001.mrc YOUR-USERNAME/my-data@main/raw/scan-001.mrc
```

Downloading needs sign-in, even from a public repository. `subspatial commit` uploads the file and publishes it in one step. (`subspatial upload` only stages a file; nothing appears in the repository until it is committed.)

Run `subspatial help` for every command.

### Mounting (Linux only, experimental)

`subspatial mount` shows a repository snapshot as a folder and downloads files only when you open them. It needs FUSE 3 (`fuse3` on Debian/Ubuntu and Fedora). It is experimental in this pilot: if something goes wrong, use `subspatial download` instead, and tell us what happened.

```sh
mkdir -p ~/mnt/empiar
subspatial mount subspatial/empiar-11830@main ~/mnt/empiar
```

`subspatial mount` keeps running while the folder is mounted. Open the folder from another terminal, and when you're done, unmount it from there too:

```sh
subspatial mount unmount ~/mnt/empiar
```

## Upgrading from 0.3.0-alpha.1

Version 0.3.0-alpha.1 installed the command as `data`. Install the new release as above, then remove the old files: `rm ~/.local/bin/data ~/.local/bin/datad`. Your settings carry over; if `subspatial` says your login has expired, run `subspatial login` again.

## Feedback and problems

Send bugs, questions and suggestions to the subspatial team through your alpha contact. Include the output of `subspatial version` and the command you ran. Never send your token or the contents of the client's config folder.

## License

Apache License 2.0; see [LICENSE](LICENSE).
