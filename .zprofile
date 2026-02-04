# ~/.zprofile

# 1. Add mise to the PATH so the 'mise' command is found
export PATH="$HOME/.local/bin:$PATH"

# 2. Activate mise and add its shims to the PATH
eval "$(mise activate zsh --bolt)"