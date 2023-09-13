#!/bin/bash

# Colors
RESET="\033[0m"
GREEN="\033[1;32m"
RED="\033[1;31m"
CYAN="\033[1;36m"
BLUE="\033[1;34m"
LOGFILE="install_log.txt"

print_green() {
    echo -e "${GREEN}$1${RESET}"
    echo "$1" >> $LOGFILE
}

print_error() {
    echo -e "${RED}$1${RESET}"
    echo "ERROR: $1" >> $LOGFILE
}

install_package() {
    sudo apt-get install -y $1
    if [ $? -ne 0 ]; then
        print_error "Failed to install package $1"
        exit 1
    fi
}

append_to_zshrc() {
    echo $1 >> ~/.zshrc
    if [ $? -ne 0 ]; then
        print_error "Failed to append to .zshrc"
        exit 1
    fi
}

display_help() {
    echo "Usage: $0 [OPTION]"
    echo "  --help          Display this help and exit."
    echo "  --all           Install all tools without prompting."
    echo "  --default       Run the default installation."
    echo "  -i [TOOL]       Install specific tools. Multiple tools can be specified."
    echo "                  Available tools: manticore, mythril, slither, solgraph, echidna, brownie, certora-cli, foundry, ganache-cli, geth, hardhat, hevm, scribble, truffle, errcheck, go-geiger, golangci-lint, gosec, staticcheck, nancy, unconvert, anchorcli, chainbridge, near-cli, polkadot-js, polygon-cli, "
    exit 1
}

prompt_user() {
    if [[ $INSTALL_ALL == true ]]; then
        return 0
    fi
    echo -ne "${GREEN}"
    read -t 15 -p "$1 (y/n, default is y after 15 seconds)? " choice
    echo -ne "${RESET}"
    case "$choice" in
        y|Y ) return 0;;
        n|N ) return 1;;
        "" ) print_green "No input received within 15 seconds, proceeding with default 'yes' choice."; return 0;;
        * ) print_error "Invalid choice"; exit 1;;
    esac
}


# Initialize variables
INSTALL_ALL=false
INSTALL_SPECIFIC=()

# Parse command-line arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --help) display_help;;
        --all) INSTALL_ALL=true;;
        -i) shift; INSTALL_SPECIFIC=("$@"); break;;
        --default) main; exit 0;; # Run the main function if --default is provided
        *) echo "Unknown parameter passed: $1"; display_help;;
    esac
    shift
done

# If no arguments are provided, display the help menu
if [ "$#" -eq 0 ]; then
    display_help
    exit 1
fi

update_system() {
    print_green "Updating the system..."
    sudo apt-get update
    if [ $? -ne 0 ]; then
        print_error "Failed to update the system"
        exit 1
    fi
}

install_pyenv() {
    if prompt_user "Do you want to install pyenv?"; then
        print_green "Installing pyenv..."
        curl https://pyenv.run | bash
        export PYENV_ROOT="$HOME/.pyenv"
        command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
        eval "$(pyenv init -)"
        git clone https://github.com/pyenv/pyenv-virtualenv.git $(pyenv root)/plugins/pyenv-virtualenv
        append_to_zshrc 'export PYENV_ROOT="$HOME/.pyenv"'
        append_to_zshrc 'export PATH="$PYENV_ROOT/bin:$PATH"'
        append_to_zshrc 'if command -v pyenv 1>/dev/null 2>&1; then'
        append_to_zshrc '  eval "$(pyenv init --path)"'
        append_to_zshrc '  eval "$(pyenv init -)"'
        append_to_zshrc '  eval "$(pyenv virtualenv-init -)"'
        append_to_zshrc 'fi'
        sudo apt-get install -y build-essential zlib1g-dev libffi-dev libssl-dev libbz2-dev libreadline-dev libsqlite3-dev liblzma-dev python-tk
    fi
}

install_python_with_pyenv() {
    local version=$1
    if prompt_user "Do you want to install Python $version with pyenv?"; then
        print_green "Installing python $version using pyenv..."
        pyenv install $version
        pyenv global $version
    fi
}

install_manticore() {
    local dir_path=$1
    if prompt_user "Do you want to install Manticore?"; then
        print_green "Installing Manticore..."
        cd $dir_path
        pyenv virtualenv virtualenv@manticore
        pyenv activate virtualenv@manticore
        sudo apt-get install -y snapd
        sudo apt-get install -y libboost-all-dev
        sudo systemctl enable --now snapd apparmor
        pip install crytic-compile
        wget https://github.com/ethereum/solidity/releases/download/v0.8.21/solc-static-linux -O solc
        chmod +x solc
        sudo mv solc /usr/bin/solc
        pip install pyyaml
        pip install PrettyTable
        pip install sha3
        pip install -e ".[native]"
        pyenv deactivate
    fi
}

install_mythril() {
    local dir_path=$1
    if prompt_user "Do you want to install Mythril?"; then
        print_green "Installing Mythril..."
        cd $dir_path
        pyenv virtualenv virtualenv@mythril
        pyenv activate virtualenv@mythril
        pip install -r requirements.txt
        pip install mythril
        pyenv deactivate
    fi
}

install_slither() {
    local dir_path=$1
    if prompt_user "Do you want to install Slither?"; then
        print_green "Installing Slither..."
        cd $dir_path
        pyenv virtualenv virtualenv@slither
        pyenv activate virtualenv@slither
        pip install slither-analyzer
        pyenv deactivate
    fi
}

install_nvm_and_node() {
    print_green "Installing nvm and node..."
    wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash
    export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    append_to_zshrc 'export NVM_DIR=~/.nvm'
    append_to_zshrc '[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"'
    nvm install 18.17.1
    nvm use 18.17.1
    npm install --global yarn
    nvm install 16.18.1
    nvm use 16.18.1
    npm install --global yarn
}

install_solgraph() {
    if prompt_user "Do you want to install Solgraph?"; then
        print_green "Installing Solgraph..."
        sudo apt-get install -y graphviz
        npm install -g solgraph
    fi
}

install_echidna() {
    local dir_path=$1
    if prompt_user "Do you want to install ECHIDNA?"; then
        print_green "Installing ECHIDNA..."
        cd $dir_path
        pyenv virtualenv virtualenv@echidna
        pyenv activate virtualenv@echidna
        pip install slither-analyzer
        mkdir echidna-bin
        cd echidna-bin/
        wget https://github.com/crytic/echidna/releases/download/v2.2.1/echidna-2.2.1-Linux.zip
        unzip echidna-2.2.1-Linux.zip
        tar -xvf echidna.tar.gz
        sudo mv echidna /usr/bin/echidna
        pyenv deactivate
    fi
}

install_brownie() {
    local dir_path=$1
    if prompt_user "Do you want to install Brownie?"; then
        print_green "Installing Brownie..."
        cd $dir_path
        pyenv virtualenv virtualenv@brownie
        pyenv activate virtualenv@brownie
        pip install eth-brownie
        pyenv deactivate
    fi
}

install_certora_cli() {
    local dir_path=$1
    if prompt_user "Do you want to install certora-cli?"; then
        print_green "Installing certora-cli..."
        cd $dir_path
        pyenv virtualenv virtualenv@certora-cli
        pyenv activate virtualenv@certora-cli
        pip install solc-select
        sudo apt-get install -y "default-jdk"
        pip install certora-cli
        pyenv deactivate
    fi
}

install_foundry() {
    local dir_path=$1
    if prompt_user "Do you want to install Foundary?"; then
        print_green "Installing Foundary..."
        cd $dir_path
        curl -L https://foundry.paradigm.xyz | bash
        source /home/kali/.zshenv
        foundryup
    fi
}

install_ganache_cli() {
    local dir_path=$1
    if prompt_user "Do you want to install Ganache?"; then
        print_green "Installing Ganache..."
        cd $dir_path
        npm install ganache --global
    fi
}

install_geth() {
    local dir_path=$1
    if prompt_user "Do you want to install Geth?"; then
        print_green "Installing Geth..."
        cd $dir_path
        tar -xvf geth-linux-amd64-1.12.2-bed84606.tar.gz
        cd geth-linux-amd64-1.12.2-bed84606
        sudo mv geth /usr/bin/.
    fi
}

install_hardhat() {
    local dir_path=$1
    if prompt_user "Do you want to install Hardhat?"; then
        print_green "Installing Hardhat..."
        cd $dir_path
        chmod +x install.sh
        ./install.sh
    fi
}

install_hevm() {
    local dir_path=$1
    if prompt_user "Do you want to install HEVM?"; then
        print_green "Installing HEVM..."
        cd $dir_path
        chmod +x hevm-x86_64-linux
        ./hevm-x86_64-linux --help
    fi
}

install_scribble() {
    local dir_path=$1
    if prompt_user "Do you want to install Scribble?"; then
        print_green "Installing Scribble..."
        cd $dir_path
        npm install -g eth-scribble
    fi
}

install_truffle() {
    local dir_path=$1
    if prompt_user "Do you want to install Truffle?"; then
        print_green "Installing Truffle..."
        cd $dir_path
        chmod +x install.sh
        nvm use 18.17.1
        ./install.sh
        nvm use 16.18.1
    fi
}

install_errcheck() {
    local dir_path=$1
    if prompt_user "Do you want to install ErrCheck?"; then
        print_green "Installing ErrCheck..."
        cd $dir_path
        sudo apt-get install -y golang-go snapd
        sudo snap install errcheck
        export PATH=$PATH:/snap/bin
    fi
}


install_go-geiger() {
    local dir_path=$1
    if prompt_user "Do you want to install Go-Geiger?"; then
        print_green "Installing Go-Geiger..."
        cd $dir_path
        sudo apt-get install -y "golang-go"
        go build
        sudo mv go-geiger /usr/bin
        go-geiger
    fi
}

install_golangci-lint() {
    local dir_path=$1
    if prompt_user "Do you want to install Golangci-lint?"; then
        print_green "Installing Golangci-lint..."
        cd $dir_path
        sudo apt-get install -y "golang-go"
        curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s v1.54.2
        mv bin/golangci-lint /usr/bin/golangci-lint
        golangci-lint
    fi
}



install_gosec() {
    local dir_path=$1
    if prompt_user "Do you want to install GoSec?"; then
        print_green "Installing GoSec..."
        cd $dir_path
        sudo apt-get install -y "golang-go"
        curl -sfL https://raw.githubusercontent.com/securego/gosec/master/install.sh | sh -s vX.Y.Z
        mv bin/gosec /usr/bin/gosec
        gosec --help
    fi
}


install_static-check() {
    local dir_path=$1
    if prompt_user "Do you want to install staticcheck by Go-tools?"; then
        print_green "Installing staticcheck by Go-tools..."
        cd $dir_path
        sudo apt-get install -y "golang-go"
        wget https://github.com/dominikh/go-tools/releases/download/2023.1.5/staticcheck_linux_amd64.tar.gz
        tar -xvf staticcheck_linux_amd64.tar.gz
        sudo mv staticcheck/staticcheck /usr/bin/staticcheck
        staticcheck --help
    fi
}

install_docker() {
    print_green "Installing Docker..."
    update_system
    printf '%s\n' "deb https://download.docker.com/linux/debian bullseye stable" | sudo tee /etc/apt/sources.list.d/docker-ce.list
    curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/docker-ce-archive-keyring.gpg
    update_system
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io
    sudo groupadd docker
    sudo usermod -aG docker ${USER}
    docker --help
}


install_nancy() {
    local dir_path=$1
    if prompt_user "Do you want to install Nancy?"; then
        print_green "Installing Nancy..."
        cd $dir_path
        sudo apt-get update
        sudo apt-get install -y "golang-go"
        print_green "Installing goreleaser..."
        wget https://github.com/goreleaser/goreleaser/releases/download/v1.20.0/goreleaser_Linux_x86_64.tar.gz
        tar -xvf goreleaser_Linux_x86_64.tar.gz
        sudo mv goreleaser /usr/bin/goreleaser
        goreleaser release --skip-publish --snapshot --clean
        docker images
        go build
        sudo mv nancy /usr/bin/nancy
        nancy --help
    fi
}

install_unconvert() {
    local dir_path=$1
    if prompt_user "Do you want to install Unconvert?"; then
        print_green "Installing Unconvert..."
        cd $dir_path
        sudo apt-get update
        sudo apt-get install -y "golang-go"
        go install github.com/mdempsky/unconvert@latest
        go build
        sudo mv unconvert /usr/bin
        unconvert --help
    fi
}

install_anchorcli() {
    local dir_path=$1
    if prompt_user "Do you want to install Anchorcli?"; then
        print_green "Installing Anchorcli..."
        cd $dir_path
        sudo apt-get update
        sudo apt-get install -y "golang-go"
        print_green "Installing terrad - terra node and adding it to /usr/bin ..."
        wget https://github.com/classic-terra/core/releases/download/v2.2.0/terra_2.2.0_Linux_x86_64.tar.gz
        tar -xvf terra_2.2.0_Linux_x86_64.tar.gz
        sudo mv terrad /usr/bin/terrad
        terrad --help
        nvm use 16.18.1
        npm install -g @anchor-protocol/anchorcli
        anchorcli --help
    fi
}

install_chainbridge() {
    local dir_path=$1
    if prompt_user "Do you want to install ChainBridge?"; then
        print_green "Installing ChainBidge..."
        cd $dir_path
        sudo apt-get update
        sudo apt-get install -y golang-go git clang curl libssl-dev llvm libudev-dev make protobuf-compiler
        print_green "Installing dependencies Rustup, Substrate..."
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
        source $HOME/.cargo/env
        rustc --version
        rustup default stable
        rustup update
        rustup update nightly
        rustup target add wasm32-unknown-unknown --toolchain nightly
        rustup show
        rustup +nightly show
        print_green "Building Chainbridge ..."
        make build
        sudo mv build/chainbridge /usr/bin/chainbridge
        chainbridge --help
    fi
}

install_near-cli() {
    local dir_path=$1
    if prompt_user "Do you want to install Near-cli?"; then
        print_green "Installing Near-cli..."
        cd $dir_path
        nvm use 16.18.1
        print_green "Installing terrad - terra node and adding it to /usr/bin ..."
        npm install -g near-cli
    fi
}


install_polkadot-js() {
    local dir_path=$1
    if prompt_user "Do you want to install Polkadotjs?"; then
        print_green "Installing Polkadotjs..."
        cd $dir_path
        nvm use 16.18.1
        sudo rm -r yarn.lock
        yarn install
    fi
}


install_polygon-cli() {
    local dir_path=$1
    if prompt_user "Do you want to install Polygon-CLI?"; then
        print_green "Installing Polygon-CLI..."
        cd $dir_path
        sudo apt-get install -y "golang-go"
        sudo apt-get install bison
        bash < <(curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer)
        source /home/kali/.gvm/scripts/gvma
        gvm install go1.20
        gvm use go1.20
        sudo apt-get install -y make jq bc protobuf-compiler
        cd $dir_path
        make install
        sudo mv ~/go/bin/polycli /usr/bin/polycli
        polycli
    fi
}



main() {
    echo "Starting installation process..." > $LOGFILE
    update_system
    install_pyenv
    install_python_with_pyenv "3.8.18"
    install_nvm_and_node
    install_docker

    if [[ $INSTALL_ALL == true ]] || [[ -z $INSTALL_SPECIFIC ]] || [[ " ${INSTALL_SPECIFIC[@]} " =~ " manticore " ]]; then
        install_manticore "/home/kali/tools/Automated-EVM-tools/manticore"
    fi
    if [[ $INSTALL_ALL == true ]] || [[ -z $INSTALL_SPECIFIC ]] || [[ " ${INSTALL_SPECIFIC[@]} " =~ " mythril " ]]; then
        install_mythril "/home/kali/tools/Automated-EVM-tools/mythril"
    fi
    if [[ $INSTALL_ALL == true ]] || [[ -z $INSTALL_SPECIFIC ]] || [[ " ${INSTALL_SPECIFIC[@]} " =~ " slither " ]]; then
        install_slither "/home/kali/tools/Automated-EVM-tools/slither"
    fi
    if [[ $INSTALL_ALL == true ]] || [[ -z $INSTALL_SPECIFIC ]] || [[ " ${INSTALL_SPECIFIC[@]} " =~ " solgraph " ]]; then
        install_solgraph
    fi
    if [[ $INSTALL_ALL == true ]] || [[ -z $INSTALL_SPECIFIC ]] || [[ " ${INSTALL_SPECIFIC[@]} " =~ " echidna " ]]; then
        install_echidna "/home/kali/tools/EVM-Fuzzers/echidna"
    fi
    if [[ $INSTALL_ALL == true ]] || [[ -z $INSTALL_SPECIFIC ]] || [[ " ${INSTALL_SPECIFIC[@]} " =~ " brownie " ]]; then
        install_brownie "/home/kali/tools/EVM-Tools/brownie"
    fi
    if [[ $INSTALL_ALL == true ]] || [[ -z $INSTALL_SPECIFIC ]] || [[ " ${INSTALL_SPECIFIC[@]} " =~ " certora-cli " ]]; then
        install_certora_cli "/home/kali/tools/EVM-Tools/certora-cli"
    fi
    if [[ $INSTALL_ALL == true ]] || [[ -z $INSTALL_SPECIFIC ]] || [[ " ${INSTALL_SPECIFIC[@]} " =~ " foundry " ]]; then
        install_foundry "/home/kali/tools/EVM-Tools/foundry"
    fi
    if [[ $INSTALL_ALL == true ]] || [[ -z $INSTALL_SPECIFIC ]] || [[ " ${INSTALL_SPECIFIC[@]} " =~ " ganache-cli " ]]; then
        install_ganache_cli "/home/kali/tools/EVM-Tools/Ganache-cli"
    fi
    if [[ $INSTALL_ALL == true ]] || [[ -z $INSTALL_SPECIFIC ]] || [[ " ${INSTALL_SPECIFIC[@]} " =~ " geth " ]]; then
        install_geth "/home/kali/tools/EVM-Tools/go-ethereum/"
    fi
    if [[ $INSTALL_ALL == true ]] || [[ -z $INSTALL_SPECIFIC ]] || [[ " ${INSTALL_SPECIFIC[@]} " =~ " hardhat " ]]; then
        install_hardhat "/home/kali/tools/EVM-Tools/Hardhat/"
    fi
    if [[ $INSTALL_ALL == true ]] || [[ -z $INSTALL_SPECIFIC ]] || [[ " ${INSTALL_SPECIFIC[@]} " =~ " hevm " ]]; then
        install_hevm "/home/kali/tools/EVM-Tools/hevm"
    fi
    if [[ $INSTALL_ALL == true ]] || [[ -z $INSTALL_SPECIFIC ]] || [[ " ${INSTALL_SPECIFIC[@]} " =~ " scribble " ]]; then
        install_scribble "/home/kali/tools/EVM-Tools/scribble"
    fi
    if [[ $INSTALL_ALL == true ]] || [[ -z $INSTALL_SPECIFIC ]] || [[ " ${INSTALL_SPECIFIC[@]} " =~ " truffle " ]]; then
        install_truffle "/home/kali/tools/EVM-Tools/Truffle"
    fi
    if [[ $INSTALL_ALL == true ]] || [[ -z $INSTALL_SPECIFIC ]] || [[ " ${INSTALL_SPECIFIC[@]} " =~ " errcheck " ]]; then
        install_errcheck "/home/kali/tools/Go-Tools/errcheck"
    fi
    if [[ $INSTALL_ALL == true ]] || [[ -z $INSTALL_SPECIFIC ]] || [[ " ${INSTALL_SPECIFIC[@]} " =~ " go-geiger " ]]; then
        install_go-geiger "/home/kali/tools/Go-Tools/go-geiger"
    fi
    if [[ $INSTALL_ALL == true ]] || [[ -z $INSTALL_SPECIFIC ]] || [[ " ${INSTALL_SPECIFIC[@]} " =~ " golangci-lint " ]]; then
        install_errcheck "/home/kali/tools/Go-Tools/golangci-lint"
    fi
    if [[ $INSTALL_ALL == true ]] || [[ -z $INSTALL_SPECIFIC ]] || [[ " ${INSTALL_SPECIFIC[@]} " =~ " gosec " ]]; then
        install_errcheck "/home/kali/tools/Go-Tools/gosec"
    fi
    if [[ $INSTALL_ALL == true ]] || [[ -z $INSTALL_SPECIFIC ]] || [[ " ${INSTALL_SPECIFIC[@]} " =~ " staticcheck " ]]; then
        install_static-check "/home/kali/tools/Go-Tools/go-tools"
    fi
    if [[ $INSTALL_ALL == true ]] || [[ -z $INSTALL_SPECIFIC ]] || [[ " ${INSTALL_SPECIFIC[@]} " =~ " nancy " ]]; then
        install_nancy "/home/kali/tools/Go-Tools/nancy"
    fi
    if [[ $INSTALL_ALL == true ]] || [[ -z $INSTALL_SPECIFIC ]] || [[ " ${INSTALL_SPECIFIC[@]} " =~ " unconvert " ]]; then
        install_unconvert "/home/kali/tools/Go-Tools/unconvert"
    fi
    if [[ $INSTALL_ALL == true ]] || [[ -z $INSTALL_SPECIFIC ]] || [[ " ${INSTALL_SPECIFIC[@]} " =~ " anchorcli " ]]; then
        install_anchorcli "/home/kali/tools/Protocol-Tools/anchorcli"
    fi
    if [[ $INSTALL_ALL == true ]] || [[ -z $INSTALL_SPECIFIC ]] || [[ " ${INSTALL_SPECIFIC[@]} " =~ " chainbridge " ]]; then
        install_chainbridge "/home/kali/tools/Protocol-Tools/ChainBridge"
    fi
    if [[ $INSTALL_ALL == true ]] || [[ -z $INSTALL_SPECIFIC ]] || [[ " ${INSTALL_SPECIFIC[@]} " =~ " near-cli " ]]; then
        install_near-cli "/home/kali/tools/Protocol-Tools/near-cli"
    fi
    if [[ $INSTALL_ALL == true ]] || [[ -z $INSTALL_SPECIFIC ]] || [[ " ${INSTALL_SPECIFIC[@]} " =~ " polkadot-js " ]]; then
        install_polkadot-js "/home/kali/tools/Protocol-Tools/polkadot-js/apps"
    fi
    if [[ $INSTALL_ALL == true ]] || [[ -z $INSTALL_SPECIFIC ]] || [[ " ${INSTALL_SPECIFIC[@]} " =~ " polygon-cli " ]]; then
        install_polygon-cli "/home/kali/tools/Protocol-Tools/polygon-cli"
    fi
}

main
