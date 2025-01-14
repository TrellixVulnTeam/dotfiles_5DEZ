#!/bin/bash

# some colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

# resource files used by bootstraping
INFO_FILE=$HOME/.config/.bootstrap_info

# constants
OS_UPDATE_INTERVAL_DAYS=5
OS_UPDATE_INTERVAL_SECONDS=$(( ${OS_UPDATE_INTERVAL_DAYS}*24*60*60 ))

function yellow() {
  printf "${YELLOW}$@${NC}\n"
}

function red() {
  printf "${RED}$@${NC}\n"
}

function green() {
  printf "${GREEN}$@${NC}\n"
}

function show_os_info() {
  local os_name=`awk -F= '/^NAME/{print $2}' /etc/os-release 2> /dev/null`
  local version=`awk -F= '/^\<VERSION\>/{print $2}' /etc/os-release 2> /dev/null`
  local sanitized_version=`echo "$version" | tr -d '"'`
  if [[ -n $os_name ]]; then
    echo -e "Operating System: ${GREEN}${os_name} ${sanitized_version}${NC}"
  else
    echo -e "Operating System: ${RED}"Unknown"${NC}"
  fi
}

function update_os() {
  if should_update_os; then
    yellow "Updating packages"
    local cmd=`echo sudo ${update_os_command}`
    echo $cmd
    sh -c "$cmd"
    [[ $? -eq 0 ]] && update_last_update_timestamp
  fi
}

function should_update_os() {
  if [[ ! -f ${INFO_FILE} ]]; then
    # File doesn't exist. Probably the first time doing bootstraping
    cat << EOF > ${INFO_FILE}
last_update: 
repo_site: 
email: 
EOF
    return 0
  fi

  # if the file exists, let's check if we have gone beyond the interval

  # read last_update timestamp

  last_update_timestamp=$(sed -n -E "s/^last_update: (.*)/\1/p" ${INFO_FILE})
  current_timestamp=$(date +%s)

  difference=$((current_timestamp - last_update_timestamp))
  if (( difference > OS_UPDATE_INTERVAL_SECONDS )); then
    # Now get the confirmation
    yellow "You haven't updated the packages in $(( difference / 86400 )) days."
    read -n 1 -p "Continue to update packages [y]: " input
    if [ "${input}" = "y" ] || [ -z ${input} ]; then
      echo
      return 0
    else
      return 1
    fi
  else
    return 1
  fi
}

function update_last_update_timestamp() {
  sed -i -E "s/(^last_update: )(.*)$/\1$(date +%s)/" ${INFO_FILE}
}

function export_install_command() {
  if which dnf &> /dev/null; then
    HAS_DNF=1
    install_command="dnf install"
    update_os_command="dnf update -y"
  elif which apt-get &> /dev/null; then
    HAS_APT=1
    install_command="apt-get install"
    update_os_command="apt-get update -y"
  elif which pacman &> /dev/null; then
    HAS_PACMAN=1
    install_command="pacman --noconfirm -S"
    update_os_command="pacman --noconfirm -Syu"
  fi
  if [[ -n $install_command ]]; then
    echo -e "Install Command: ${GREEN}${install_command}${NC}"
  else
    echo -e "Install Command: ${RED}"Unknown"${NC}"
    exit 1
  fi
}

function probe_os_info() {
  yellow "Probing OS information"
  show_os_info
  export_install_command
  echo
}

function install() {
  local cmd=
  [[ $HAS_PACMAN -eq 1 ]] && cmd=`echo "sudo ${install_command} ${@}"` || cmd=`echo "sudo ${install_command} ${@} -y"`
  echo $cmd
  sh -c "$cmd"
}

function check_dependencies() {
  # We rely on dialog, if this doesn't exist install it first
  yellow "Checking dependencies for bootstraping"
  which dialog &> /dev/null
  if [[ $? -ne 0 ]]; then
    install dialog
  fi
}

function pip_install() {
  local cmd=`echo "pip3 install ${@}"`
  echo $cmd
  sh -c "$cmd"
}

function snap_install() {
  local cmd=`echo "sudo snap install ${@}"`
  echo $cmd
  sh -c "$cmd"
}

function snap_install_classic() {
  local cmd=`echo "sudo snap install ${@} --classic"`
  echo $cmd
  sh -c "$cmd"
}

function change_to_zsh() {
  local result=`$SHELL -c 'echo $ZSH_VERSION'`
  if [[ -z $result ]]; then
    # assuming the shell is not zsh, change it to zsh
    echo "Changing to zsh..."
    if ! grep -q "zsh" /etc/shells; then
      red "Error: zsh not in /etc/shells"
    else
      if [[ $HAS_DNF -eq 1 ]]; then
        # Fedora doesn't have chsh installed
        local cmd=`echo "sudo lchsh -i ${USER}"`
        sh -c "${cmd}"
      else
        local zsh_prg=`which zsh`
        local cmd="chsh --shell ${zsh_prg}"
        eval $cmd
      fi
    fi
  else
    echo "ZSH already selected as the login shell"
  fi
}

function essentials() {
  local essential_pkgs=()
  essential_pkgs+=(zsh)
  essential_pkgs+=(git gitk)
  [[ $HAS_APT -eq 1 ]] && essential_pkgs+=(silversearcher-ag) || essential_pkgs+=(the_silver_searcher)
  essential_pkgs+=(tree)
  [[ $HAS_DNF -eq 1 ]] && essential_pkgs+=(redhat-lsb)
  essential_pkgs+=(htop)
  essential_pkgs+=(wget)
  essential_pkgs+=(curl)
  essential_pkgs+=(xclip)
  essential_pkgs+=(tmux)
  install ${essential_pkgs[*]}
}

function dev_tools() {
  local dev_tools=()
  # more selective ones
  dev_tools+=(boost-devel)
  dev_tools+=(clang)
  dev_tools+=(cmake)
  [[ $HAS_APT -eq 1 ]] && dev_tools+=(exuberant-ctags) || dev_tools+=(ctags)

  sudo dnf groupinstall "Development Tools"

  install ${dev_tools[*]}
}

function arm_cortex_dev_tools() {
  local dev_tools=()
  [[ $HAS_DNF -eq 1 ]] && dev_tools+=(arm-none-eabi-gcc-cs) || dev_tools+=(arm-none-eabi-gcc)
  [[ $HAS_DNF -eq 1 ]] && dev_tools+=(arm-none-eabi-gcc-cs-c++) || dev_tools+=(arm-none-eabi-g++)
  dev_tools+=(arm-none-eabi-gdb)
  dev_tools+=(openocd)

  install ${dev_tools[*]}
}

function arm_linux_dev_tools() {
  local dev_tools=()
  if [[ $HAS_DNF -eq 1 ]]; then
    sudo dnf copr enable lantw44/arm-linux-gnueabihf-toolchain
    dev_tools+=(arm-linux-gnueabihf-binutils)
    dev_tools+=(arm-linux-gnueabihf-gcc)
    dev_tools+=(arm-linux-gnueabihf-glibc)
  else
    dev_tools+=(gcc-arm-linux-gnueabihf)
    dev_tools+=(g++-arm-linux-gnueabih)
  fi

  install ${dev_tools[*]}
}

function python_stuff() {
  local python_stuff=()
  python_stuff+=(python3)
  python_stuff+=(python3-pip)
  python_stuff+=(python3-devel) # for building boost
  python_stuff+=(python3-ipython)
  python_stuff+=(python3-jedi)
  python_stuff+=(python3-neovim)

  install ${python_stuff[*]}
}

function extra_repos() {
  local repos=()
  # more selective ones
  if [[ $HAS_DNF -eq 1 ]]; then
    repos+=(https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$\(rpm -E %fedora\).noarch.rpm)
    repos+=(https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$\(rpm -E %fedora\).noarch.rpm)
    repos+=(fedora-workstation-repositories)

    install ${repos[*]}
    sh -c "sudo dnf config-manager --set-enabled google-chrome"

    pkgs+=(google-chrome-stable)

    install ${pkgs[*]}
  fi
}

# install latest nvim from source code
function nvim_from_sources() {
  # pre_requisites=(ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip)

  echo "  - Cloning neovim..."
  # create tmp directory if not exists
  mkdir -p ~/tmp/neovim
  git clone https://github.com/neovim/neovim.git ~/tmp/neovim
  # switch to stable branch
  echo "  - Switching to stable..."
  cd ~/tmp/neovim && git checkout stable
  echo "  - Building and installing neovim..."
  cd ~/tmp/neovim && sudo make CMAKE_BUILD_TYPE=RelWithDebInfo CMAKE_INSTALL_PREFIX=/usr/local/nvim install
}

function snaps() {
  snap_pkgs=(snapd)
  install ${snap_pkgs[*]}
  sh -c "sudo systemctl enable --now snapd.socket"
  sh -c "sudo ln -s /var/lib/snapd/snap /snap"

  # Now install the most essential snaps
  echo " - Install snap core"
  snap_core=(core)
  snap_install ${snap_core[*]}

  echo " - Installing snap-store"
  snaps=(snap-store)
  for s in "${snaps[@]}"; do
    snap_install ${s}
  done

  snaps_classic=()
  snaps_classic+=(clion)
  snaps_classic+=(code)
  for s in "${snaps_classic[@]}"; do
    snap_install_classic ${s}
  done
}

function setup_github_personal_ssh() {
  ssh_key_file="${HOME}/.ssh/id_github_personal"
  if [[ ! -f ${ssh_key_file} ]]; then
    yellow "Setting up ssh keys ${ssh_key_file}"
    green "Generatig ed25519 key with no passphrase"
    cmd="ssh-keygen -N '' -t ed25519 -C \"github, personal(${USER})\" -f ${ssh_key_file}"
    eval ${cmd}
    eval "$(ssh-agent -s)" && green "ssh agent started" || return 2
    eval ssh-add ${ssh_key_file} && \
      green "ssh keys added\nCopy & paste the following key to Github\n\n" || \
      return 2
    eval cat ${ssh_key_file}.pub
    echo
  else
    yellow "Not setting up ssh keys since ${ssh_key_file} already exists..."
    eval "$(ssh-agent -s)" && green "ssh agent started" || return 2
    eval ssh-add ${ssh_key_file}
    return 1
  fi
  return 0
}

function check_if_auth_ok() {
  ssh -T git@github.com 2>&1 | grep -q "successfully authenticated"
  return $?
}

function setup_configs() {
  url='git@github.com:amilaperera/dotfiles'
  if [[ ${BYPASS_SSH} -eq 1 ]]; then
    url='https://github.com/amilaperera/dotfiles'
  fi
  if [[ ! -d "$HOME/.dotfiles" ]]; then
    green "Cloning dotfiles"
    git clone ${url} ~/.dotfiles
  else
    yellow "$HOME/.dotfiles directory already exists"
  fi
  echo
  if [[ $HAS_APT -eq 1 ]]; then
    # Doesn't seem to get snap bin directory by default
    cd ~/.dotfiles/scripts && PATH=$PATH:/snap/bin python3 setup_env.py -e zsh nvim misc tmux_sessions
  else
    if [[ ${BYPASS_SSH} -eq 1 ]]; then
      cd ~/.dotfiles/scripts && python3 setup_env.py --nossh --env zsh nvim misc tmux_sessions
    else
      cd ~/.dotfiles/scripts && python3 setup_env.py -e zsh nvim misc tmux_sessions
    fi
  fi
}

function setup_configs_if_auth_ok() {
  yellow "Check if the user can be validated with the ssh keys..."
  if check_if_auth_ok; then
    green "Authentication successful with GitHub"
    setup_configs
  fi
}

# Function wrapper to install packages
function install_packages() {
  yellow "Installing ${@}..."
  ${@}
  echo
}

########################################
# main
########################################
probe_os_info
check_dependencies
update_os

cmd=(dialog --separate-output --checklist "Select Options:" 22 76 16)
options=(
  1 "Essential packages (zsh, tmux, git, curl etc.)"           on
  2 "Development tools"                                        off
  3 "Snaps"                                                    off
  4 "Python stuff"                                             off
  5 "Extra repositories"                                       off
  6 "Install Neovim latest from sources"                       off
  7 "Setup github SSH"                                         off
  8 "Setup personal configs(zsh,tmux,neovim etc.)"             off
)

choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
clear

for choice in $choices; do
  case $choice in
    1)
      install_packages essentials
      ;;
    2)
      install_packages dev_tools
      ;;
    3)
      install_packages snaps
      ;;
    4)
      install_packages python_stuff
      ;;
    5)
      install_packages extra_repos
      ;;
    6)
      install_packages nvim_from_sources
      ;;
    7)
      if setup_github_personal_ssh; then
        # wait until the user wishes to continue
        read -n 1 -p "Press [c] to continue with setup or any other key to abort: " input
        [[ "$input" != "c" ]] && break
      fi
      ;;
    8)
      setup_configs_if_auth_ok
      ;;
  esac
done

green "Bye...."

unset HAS_DNF HAS_APT HAS_PACMAN RED YELLOW GREEN NC install_command
unset INFO_FILE OS_UPDATE_INTERVAL_DAYS OS_UPDATE_INTERVAL_SECONDS
unset -f yellow red green
unset -f install

