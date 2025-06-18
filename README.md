# ✨ Dotfiles for a Modern Development Environment

These dotfiles are configured to set up a productive development environment, with a strong focus on **Node.js development using pnpm** and seamless integration with **GitHub Codespaces** and VS Code.

## Features

*   **Shell Power**:
    *   **Zsh** with **Oh My Zsh** for a powerful and customizable shell experience.
    *   **Powerlevel10k** theme for a visually appealing and informative prompt.
    *   Plugins like `zsh-autosuggestions` and `zsh-syntax-highlighting` for enhanced productivity.
    *   **Automatic Nerd Font Installation**: Attempts to install JetBrainsMono Nerd Font automatically on Linux systems (including Codespaces) if it's not already present. Requires `wget`, `unzip`, and `fontconfig` (for `fc-cache` and `fc-list`).
*   **Node.js Ready**:
    *   **nvm (Node Version Manager)**: Easily switch between Node.js versions. Loaded automatically by `.zshrc`.
    *   **pnpm**: Set up as the primary package manager, enabled via **Corepack**.
    *   Helpful aliases for `pnpm`, `npm`, and `yarn` commands in `.zshrc`.
    *   Default `NODE_ENV` set to `development`.
*   **VS Code Integration (Codespaces & Local)**:
    *   **Shared Settings (`.vscode/settings.json`)**:
        *   Default formatter: Prettier (formats on save).
        *   ESLint integration for linting and fixing.
        *   Default terminal set to `zsh`.
        *   `pnpm` configured as the workspace package manager.
    *   **Recommended Extensions (`.vscode/extensions.json`)**:
        *   Essential extensions for JavaScript/TypeScript, linting/formatting (ESLint, Prettier), testing (Jest), Docker, Git (GitLens), GitHub Copilot, and more.
*   **Git Enhancements**:
    *   Sensible defaults in `.gitconfig` (e.g., `pull.rebase = true`).
    *   A rich set of useful Git aliases.
    *   Global `.gitignore` for common temporary and OS-specific files.

## Installation

The `install.sh` script handles the setup process. It will:
*   Install Oh My Zsh and selected plugins (Powerlevel10k, autosuggestions, syntax highlighting).
*   Enable Corepack and ensure `pnpm` (latest) is available.
*   Includes a default Powerlevel10k configuration (`.p10k.zsh`).
*   Attempts to download and install the JetBrainsMono Nerd Font if you're on Linux and have `wget`, `unzip`, and `fontconfig` (for `fc-cache`/`fc-list`) installed. It will try to detect if the font is already present before downloading.
*   Copy the dotfiles (`.zshrc`, `.gitconfig`, `.p10k.zsh`, etc.) to your home directory.
*   Copy the VS Code settings (`.vscode/`) to `~/.vscode/`.
*   The script is now more verbose, providing feedback on its progress.
*   It detects if it's running in GitHub Codespaces to adjust behavior (e.g., non-interactive).
*   **Conditional Copying for `.p10k.zsh`**:
    *   For local setups, if an existing `~/.p10k.zsh` is found, it will be backed up to `~/.p10k.zsh.bak` before the new configuration is copied.
    *   In GitHub Codespaces, the repository's `.p10k.zsh` will overwrite any existing version in the Codespace home directory to ensure consistency.

### First Time Installation
```zsh
git clone https://github.com/Justinjdaniel/dotfiles.git ~/dotfiles # Clone to ~/dotfiles
cd ~/dotfiles
./install.sh
```
*After installation, restart your terminal or source your `~/.zshrc` file (e.g., `source ~/.zshrc`).*

### Update Already Installed Files
```zsh
cd ~/dotfiles # Or wherever you cloned it
git pull # Get the latest changes
./install.sh -u # The -u flag might be for specific update logic in your script, or just re-runs relevant parts.
```
*Review the `install.sh` script if the `-u` flag has specific behavior you rely on. Currently, it skips dependency installation.*

## VS Code Setup

*   **GitHub Codespaces**: The settings and extensions defined in the `.vscode/` directory of this repository will be automatically applied when you open this repository in a Codespace. The `install.sh` script also copies these to `~/.vscode/` within the Codespace to ensure user-level configurations are aligned if you open a terminal without the workspace context or for general consistency.
*   **Local VS Code**: For local VS Code setups, the `install.sh` script will copy the contents of the repository's `.vscode/` directory to `~/.vscode/`. However, to protect your existing local customizations, if `~/.vscode/settings.json` already exists, it will **not** be overwritten. Other files like `extensions.json` will still be copied if present in the repository. You might need to restart VS Code to see all changes.

## Customization

*   **Zsh & Oh My Zsh**:
    *   Add more plugins: [Oh My Zsh Plugins](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins), [Zsh Users](https://github.com/zsh-users), [Awesome Zsh Plugins](https://github.com/unixorn/awesome-zsh-plugins)
    *   Customize aliases and functions in your `~/.zshrc`.
*   **Powerlevel10k**: A default Powerlevel10k configuration (`.p10k.zsh`) based on the 'Lean' style is included and will be set up by the `install.sh` script. You can further customize your prompt by running `p10k configure` (which will guide you through options and overwrite the existing `~/.p10k.zsh`) or by manually editing your `~/.p10k.zsh` file.
*   **VS Code**: Modify settings in `~/.vscode/settings.json` or directly in the VS Code settings UI.
*   **Fonts**: The `install.sh` script attempts to automatically install **JetBrainsMono Nerd Font** on Linux systems to ensure a great out-of-the-box experience with Powerlevel10k. If you prefer a different Nerd Font or are on a non-Linux system, you can install one manually from resources like [Nerd Fonts](https://www.nerdfonts.com/font-downloads).
