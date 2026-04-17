# Ungoogled-Chromium-Updater

A small macOS applet plus LaunchAgent that periodically checks whether the [Homebrew cask `ungoogled-chromium`](https://formulae.brew.sh/cask/ungoogled-chromium) has an update, then offers to run `brew upgrade --cask ungoogled-chromium`.

**Why Homebrew for both the check and the install:** the cask may trail upstream GitHub releases. Using `brew outdated` matches what you will actually get from `brew upgrade`, so you are not prompted based on a newer upstream DMG that Homebrew has not shipped yet.

**Repository:** [github.com/gordontucker/Ungoogled-Chromium-Updater](https://github.com/gordontucker/Ungoogled-Chromium-Updater)

## Requirements

- [Homebrew](https://brew.sh) installed (Apple Silicon: `/opt/homebrew`, Intel: `/usr/local` — the script prepends both to `PATH` so LaunchAgents still find `brew`).
- Ungoogled-Chromium managed with that cask (`brew install --cask ungoogled-chromium`), or use the applet’s **Install** offer when the cask is missing.

The applet is architecture-agnostic; Homebrew installs the correct build for your Mac.

## Clone the repo

```
git clone https://github.com/gordontucker/Ungoogled-Chromium-Updater.git
```

## Install the application

```
cd Ungoogled-Chromium-Updater
chmod +x install.sh
./install.sh
```

The install script compiles `Ungoogled-Chromium Updater.applescript` into an `.app` bundle and installs a LaunchAgent that runs the updater every 24 hours.

If you previously installed another fork or an older version of this updater, unload and remove its older LaunchAgent first so you do not end up with two scheduled updaters.

## Usage

When `brew outdated --cask ungoogled-chromium` reports an upgrade, a dialog appears (similar to the screenshots below). Choosing **Update** runs `brew upgrade --cask ungoogled-chromium` in the background. You may see a notification when it finishes.

If the cask is already current, you get a short notification with the version Homebrew reports for the installed cask.

![Update Dialogue](assets/images/update.png)

Older releases of this tool installed from a downloaded DMG and could prompt for an administrator password. The Homebrew-based flow usually does not require that step; if a future cask change needs elevated rights, `brew` will say so in its output.

![Password Dialogue](assets/images/password.png)

![Notification](assets/images/notif.png)

### Note

As with any script sourced from the internet, it is wise to review its contents before executing.
