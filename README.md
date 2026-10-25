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

Pick the file for your system from the newest release on the [Releases page](https://github.com/subspatial-org/data-cli/releases):

| System | File |
|---|---|
| Linux, Intel/AMD | `subspatial-cli-VERSION-linux-amd64.unsigned.tar.gz` |
| Linux, ARM | `subspatial-cli-VERSION-linux-arm64.unsigned.tar.gz` |
| macOS, Apple silicon (M1 and later) | `subspatial-cli-VERSION-darwin-arm64.unsigned.zip` |
| macOS, Intel | `subspatial-cli-VERSION-darwin-amd64.unsigned.zip` |

### 1. Download and check the file

Download your file and `SHA256SUMS` into the same folder, open a terminal in that folder, and check the file. On Linux:

```sh
sha256sum --check --ignore-missing SHA256SUMS
```

On macOS:

```sh
shasum -a 256 --check --ignore-missing SHA256SUMS
```

Your file must show `OK`. If it shows anything else, don't run it; tell us instead.

### 2. Install it

This puts `subspatial` in `/usr/local/bin`, which is on your PATH already, so the command works straight away in the same terminal. It asks for your password once, for `sudo`.

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

The `xattr -c` line is needed because the build is unsigned. A file downloaded with a browser carries macOS's quarantine flag, and without that line macOS refuses to run `subspatial`: a "“subspatial” Not Opened" window offers **Move to Trash** or **Done**, and the terminal prints `zsh: killed`. If you see that, click **Done** (not Move to Trash), run the `xattr -c` line, and try again.

### 3. Check it runs

```sh
subspatial version
```

It prints the version, for example `subspatial 0.3.0-alpha.2 (darwin/arm64; native_mount=true)`.

<details>
<summary>Installing without <code>sudo</code></summary>

Put the two files in `~/.local/bin` instead, and add that folder to your PATH:

```sh
mkdir -p ~/.local/bin
cp subspatial-cli-*/subspatial subspatial-cli-*/subspatiald ~/.local/bin/
xattr -c ~/.local/bin/subspatial ~/.local/bin/subspatiald   # macOS only
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc     # macOS; on Linux use ~/.bashrc
```

Then open a new terminal before running `subspatial version`.

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
