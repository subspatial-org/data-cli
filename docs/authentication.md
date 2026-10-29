# Authentication

## Sign in

```sh
subspatial login --api https://app.subspatial.io
```

`subspatial` prints something like this:

```
Open ADDRESS
Enter code: CODE
Waiting for authorization…
```

Open the address in a browser where you are signed in to subspatial, check that the code matches, and approve it straight away. The code expires after a few minutes; if it does, the command stops with `device authorization expired` and you can run it again. When it is approved, the terminal prints `Logged in to https://app.subspatial.io as YOUR-USERNAME.`

### Which site

Log in to the site you were invited to. Alpha testers use `https://app.subspatial.io`. If you were invited to the development site, use `--api https://dev.subspatial.io`. `--api` is remembered, so you only need it the first time (or when you switch sites). Without it, and with no earlier login, `subspatial` uses `http://127.0.0.1:8080`, which is only right for a developer running subspatial on their own computer.

If the browser ends on a page saying subspatial is in a closed alpha, that site has no invitation for the account you signed in with. See the [main README](../README.md#sign-in).

### Other ways to log in

- `subspatial login --token TOKEN` signs in with a personal token you already have, and checks it works first. Create one on the website under **Settings** → **Tokens** (https://app.subspatial.io/settings/tokens). Prefer `subspatial login` where you can: its logins renew themselves, and you never handle the token.
- `subspatial login --username NAME` is for a locally running development copy of subspatial. You can't use it with `--token`.

## Tokens

```sh
subspatial token status
subspatial token set [--stdin] [TOKEN]
subspatial token remove
```

- `status` prints `Token configured for YOUR-USERNAME (token value hidden).`, or `No token configured.` If the token is stored but the server rejects it, it prints `token is configured but invalid:` and the reason.
- `set` stores a token you give it. It prints `Token stored with owner-only file permissions.` Prefer `--stdin`, which reads the token from the first line of standard input, so it does not end up in your shell history or in the process list: `printf '%s\n' "$TOKEN" | subspatial token set --stdin`. You cannot give both `--stdin` and a `TOKEN` argument.
- `remove` deletes the stored credentials and prints `Stored token removed.` It is also how you sign out.

**Never paste a token into a chat, an email, an issue or a bug report.** Anyone who has it can act as you. If you think one has leaked, run `subspatial token remove` and tell your alpha contact.

## Where settings are stored

`subspatial` keeps two files in a private folder (owner-only, mode 0700) called `data-platform` inside your user config folder:

- On Linux, usually `~/.config/data-platform/`.
- On macOS, `~/Library/Application Support/data-platform/`.

`config.json` holds the site address and the cache location. `credentials.json` holds your login and is readable only by you (mode 0600). `subspatial` refuses to read these files if their permissions are looser. The download cache is in a `cache` folder next to them. Never send anyone the contents of this folder.

## When a login expires

If a command fails with `Your login to https://app.subspatial.io has expired or was revoked. Run: subspatial login`, or `The token for https://app.subspatial.io is invalid, expired or revoked. Run: subspatial login`, run `subspatial login` again. Your stored credentials are left in place until you do. A second line `(request ID)` may follow; include it if you report the problem.

Logins from `subspatial login` renew themselves quietly while they are still valid, so you don't need to sign in every time.
