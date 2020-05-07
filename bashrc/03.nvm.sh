export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

DISABLE_NOTIFIER=true

#####################################

cdnvm() {
    cd "$@";
    nvm_version=$(node $HOME/projects/dev-settings/bashrc/nvm/index.js)

    if [[ "$nvm_version" != "N/A" ]]; then
        nvm use "$nvm_version";
    fi
}

alias cd='cdnvm'
