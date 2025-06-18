#!/usr/bin/env zsh

function installDependencies() {
  echo "Installing Oh My Zsh..."
  # Install Oh My Zsh
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc

  echo "Cloning Oh My Zsh plugins..."
  # Clone Oh My Zsh plugins
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
  git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

  echo "Enabling Corepack and preparing pnpm..."
  # Enable Corepack and install pnpm
  corepack enable
  corepack prepare pnpm@latest --activate
  
  installNerdFonts # Add this call
  
  echo "👌 Dependencies (including optional font) processed."
}

function configureZsh() {
  echo "Configuring Zsh..."
  echo "  Copying .zshrc to ~/.zshrc"
  cp ./.zshrc ~/.zshrc

  if [ -f "./.p10k.zsh" ]; then
    echo "  Setting up Powerlevel10k configuration (.p10k.zsh)..."
    if [ "$RUNNING_IN_CODESPACES" = "true" ]; then
      echo "    (Codespaces) Overwriting ~/.p10k.zsh with repository version."
      cp ./.p10k.zsh ~/.p10k.zsh
    else
      if [ -f ~/.p10k.zsh ]; then
        echo "    Found existing ~/.p10k.zsh."
        echo "    Backing it up to ~/.p10k.zsh.bak"
        cp ~/.p10k.zsh ~/.p10k.zsh.bak
      fi
      echo "    Copying .p10k.zsh to ~/.p10k.zsh"
      cp ./.p10k.zsh ~/.p10k.zsh
    fi
  else
    echo "  WARNING: .p10k.zsh not found in repository. Skipping Powerlevel10k custom config."
  fi
  echo "👌 Zsh configured successfully."
}

function configureGit() {
  echo "Configuring Git..."
  echo "  Copying .gitconfig to ~/.gitconfig"
  cp ./.gitconfig ~/.gitconfig
  echo "  Copying .gitignore_global to ~/.gitignore_global"
  cp ./.gitignore_global ~/.gitignore_global

  echo "👌 Git configured successfully."
}

function configureVim() {
  echo "Configuring Vim..."
  echo "  Copying .vimrc to ~/.vimrc"
  cp ./.vimrc ~/.vimrc

  echo "👌 Vim configured successfully."
}

function doIt() {
  echo "🚀 Starting dotfiles setup..."
  RUNNING_IN_CODESPACES=${CODESPACES:-false} # Default to false if CODESPACES var isn't set

  if [ "$RUNNING_IN_CODESPACES" = "true" ]; then
    echo "💻 Running in GitHub Codespaces environment (non-interactive)."
  else
    echo "🛠️ Running in local environment."
  fi

  if [ "$1" != "-u" ]; then
      installDependencies;
  fi
  
  configureZsh;
  configureGit;
  configureVim;
  configureVSCode;
  echo "✅ Done. Restart your terminal or source your ~/.zshrc file."
}

function configureVSCode() {
  echo "Configuring VS Code settings..."
  if [ ! -d ".vscode" ]; then
    echo "🤷 No .vscode directory found in repository. Skipping."
    return
  fi

  if [ "$RUNNING_IN_CODESPACES" = "true" ]; then
    echo "  (Codespaces) Ensuring ~/.vscode exists and copying repository's .vscode contents."
    mkdir -p ~/.vscode
    cp -r .vscode/* ~/.vscode/
  else
    # For local setup, be more careful
    if [ ! -d ~/.vscode ]; then
      echo "  Creating ~/.vscode directory."
      mkdir -p ~/.vscode
    fi

    if [ -f ~/.vscode/settings.json ]; then
      echo "  Found existing ~/.vscode/settings.json. Skipping copy of settings.json to avoid overwrite."
      # Optionally, copy other files from .vscode if they exist and settings.json is the only concern
      # For example, copy extensions.json:
      if [ -f "./.vscode/extensions.json" ]; then
        echo "    Copying .vscode/extensions.json to ~/.vscode/extensions.json"
        cp ./.vscode/extensions.json ~/.vscode/extensions.json
      fi
    else
      echo "  No existing ~/.vscode/settings.json found. Copying repository's .vscode contents."
      cp -r .vscode/* ~/.vscode/
    fi
  fi
  echo "👌 VS Code settings processed."
}

trap 'echo "❌ An error occurred during setup. Please check the output above." && exit 1' ERR

function installNerdFonts() {
  echo "🔠 Attempting to install JetBrainsMono Nerd Font..."

  # Check for required commands
  local missing_commands=()
  for cmd in wget unzip fc-cache; do
    if ! command -v "$cmd" &> /dev/null; then
      missing_commands+=("$cmd")
    fi
  done

  if [ ${#missing_commands[@]} -ne 0 ]; then
    echo "  ⚠️ Missing required commands: ${missing_commands[*]}. Skipping Nerd Font installation."
    return 1
  fi

  # Check OS (rudimentary check for Linux-like systems)
  if [[ "$(uname)" != "Linux" ]]; then
      echo "  ℹ️ Nerd Font installation script is primarily designed for Linux. Skipping on $(uname)."
      return 1 # Or simply return 0 if we don't want to treat non-Linux as an error for the whole script
  fi
  
  local font_dir="$HOME/.local/share/fonts"
  echo "  Creating font directory if it doesn't exist: $font_dir"
  mkdir -p "$font_dir"

  local font_name="JetBrainsMono"
  local zip_file="${font_name}.zip"
  local download_url="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/${zip_file}" # Updated to v3.4.0

  # Check if font is already installed using fc-list
  echo "  Checking if JetBrainsMono Nerd Font is already installed via fc-list..."
  if command -v fc-list &>/dev/null; then
    if fc-list | grep -q "JetBrainsMono Nerd Font"; then # Case-sensitive grep might be needed depending on fc-list output
        echo "  ✔️ JetBrainsMono Nerd Font already detected by fc-list. Skipping download and installation."
        return 0
    else
        echo "  ℹ️ JetBrainsMono Nerd Font not found by fc-list. Proceeding with installation attempt."
    fi
  else
    echo "  ⚠️ fc-list command not found. Cannot check if font is already installed via system database. Will proceed with download if files not found locally."
    # Fallback to the file-based check if fc-list is not available, but after attempting fc-list.
    if [ -f "$font_dir/${font_name}NerdFont-Regular.ttf" ] || [ -f "$font_dir/${font_name} Nerd Font Complete Regular.ttf" ] || [ -f "$font_dir/JetBrains Mono Regular Nerd Font Complete.ttf" ]; then
        echo "  ✔️ JetBrainsMono Nerd Font files found in $font_dir. Skipping download."
        echo "  Running fc-cache -fv to ensure font cache is up to date."
        fc-cache -fv
        return 0
    fi
  fi

  echo "  Downloading JetBrainsMono Nerd Font from $download_url..."
  if wget -P "$font_dir" "$download_url"; then
    echo "  Download complete. Extracting..."
    if unzip -o "$font_dir/$zip_file" -d "$font_dir"; then # -o to overwrite existing files without prompting
      echo "  Extraction complete."
    else
      echo "  ❌ Failed to extract font. Please check for errors."
      # cleanup zip
      rm -f "$font_dir/$zip_file"
      return 1
    fi
    echo "  Removing downloaded zip file: $font_dir/$zip_file"
    rm -f "$font_dir/$zip_file"
    
    echo "  Updating font cache (fc-cache -fv)..."
    fc-cache -fv
    echo "  ✔️ JetBrainsMono Nerd Font installed and cache updated successfully."
  else
    echo "  ❌ Failed to download JetBrainsMono Nerd Font. Skipping."
    return 1
  fi
}

doIt $1;

unset installDependencies doIt configureZsh configureGit configureVim configureVSCode installNerdFonts;