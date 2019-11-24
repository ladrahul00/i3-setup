# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/home/rahullad/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="bira"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
alias zshconfig="mate ~/.zshrc"
alias ohmyzsh="mate ~/.oh-my-zsh"

export GOPATH=$HOME/exp/golang/
export GOROOT=/usr/local/go/
export PATH=$PATH:$GOPATH
export PATH=$PATH:$GOROOT/bin


# -------------------------------------------------
# UNSCRAMBL_CONFIG_START HERE
# -------------------------------------------------

# User specific aliases and functions

function startvnc()
{
    vncserver -geometry 1920x1080
}

function startvnc2()
{
    vncserver -geometry 3840x1080
}

function stopvnc()
{
    vncserver -kill $@
}

function resetcs()
{
    export branchName=`git rev-parse --abbrev-ref HEAD 2> /dev/null`
    if [ "$branchName" != "" ]; then
        export CSCOPE_DB=$HOME/.cscope/$branchName.cscope.out
    fi
}

function gbn()
{
    export branchName=`git rev-parse --abbrev-ref HEAD 2> /dev/null`
    if [ "$branchName" != "" ]; then
        export CSCOPE_DB=$HOME/.cscope/foo$branchName.cscope.out
        echo "|$branchName "
    fi
}

function encrypt()
{
    tar cf $1.tar $1
    if [ "$?" -ne "0" ]; then
        echo "ERROR: failure tar'ring  '$1' -- original file left behind"
        return 1
    fi
    openssl des3 -e -salt -in $1.tar -out $1.crypt
    if [ "$?" -ne "0" ]; then
        echo "ERROR: failure encrypting '$1.tar' -- original and tar file left behind"
        return 1
    fi
    rm -rf $1 $1.tar
}

## decryption
function decrypt()
{
    openssl des3 -d -salt -in $1.crypt -out $1.tar;
    if [ "$?" -ne "0" ]; then
        echo "ERROR: failure decrypting '$1.crypt' -- missing file or incorrect password"
        return 1
    fi
    tar xf $1.tar
    if [ "$?" -ne "0" ]; then
        echo "ERROR: failure tar'ring '$1.tar'"
        return 1
    fi
    rm -rf $1.tar
}

## decryption cat
function cryptcat()
{
    openssl des3 -d -salt -in $1.crypt
}

function run()
{
    local number_of_repetitions=$1
    shift
    for i in `seq $number_of_repetitions`; do
        local timestamp=`date`
        echo "$timestamp --- trial #$i/$number_of_repetitions ------------------------------------------------"
        $@
        if [ $? -ne 0 ]; then
            echo -e "\nERROR: iteration $i of $number_of_repetitions: $@ failed" >&2
            break
        fi
    done
}

function rune()
{
    local number_of_repetitions=$1
    shift
    local expected_error_code=$1
    shift
    for i in `seq $number_of_repetitions`; do
        local timestamp=`date`
        echo "$timestamp --- trial #$i/$number_of_repetitions ------------------------------------------------"
        $@
        if [[ "$?" != "$expected_error_code" ]]; then
            echo -e "\nERROR: iteration $i of $number_of_repetitions: $@ failed with unexpected error code $?" >&2
            break
        fi
    done
}

function runi()
{
    local number_of_repetitions=$1
    shift
    for i in `seq $number_of_repetitions`; do
        local timestamp=`date`
        echo "$timestamp --- trial #$i/$number_of_repetitions ------------------------------------------------"
    done
}

if [[ "$OSTYPE" == "darwin"* ]]; then
    alias ll='ls -la'
else
    alias ll='ls --color=auto -la'
fi

if [[ "$OSTYPE" == "darwin"* ]]; then
    VIMCL="/Applications/MacVim.app/Contents/MacOS/Vim"
elif [[ "$OSTYPE" == "cygwin"* ]]; then
    VIMCL='vim'
else
    VIMCL="gvim"
fi

function gv()
{
    $VIMCL --servername `whoami` -g $@
}

function vi()
{
    $VIMCL $@
}

function rvi()
{
    $VIMCL --servername `whoami` --remote-send ":split<space>$PWD/$@<cr>"
}

function rvii()
{
    $VIMCL --servername $1 --remote-send ":split<space>$PWD/${@:2}<cr>"
}

function phone()
{
    ldapsearch -xLLL -H ldaps://ldap/ -b "dc=unscrambl,dc=com" uid=$@ mobile
}

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# figuring out this host's architecture
arch=$(uname -p)

# setting the build architecture (the default is x86_64, so we omit it as a
# IT_UNSCRAMBL_OS suffix, below)
if [[ "$arch" == "ppc64"* ]]; then
    export IT_UNSCRAMBL_BUILD_ARCH=$arch
else
    export IT_UNSCRAMBL_BUILD_ARCH=""
fi

# actual architecture
export IT_UNSCRAMBL_ARCH=$arch

# figuring what OS we have
if [ -f /etc/redhat-release ]; then
    redhat_release=$(rpm -q --qf "%{VERSION}" $(rpm -q --whatprovides redhat-release))
    if [[ "$redhat_release" == "7"* ]]; then
        export IT_UNSCRAMBL_OS="rhel07"$IT_UNSCRAMBL_BUILD_ARCH
    else
        export IT_UNSCRAMBL_OS="centos0605"$IT_UNSCRAMBL_BUILD_ARCH
    fi
else
    version=$(lsb_release -sr)
    if [[ "$version" == "18.04" ]]; then
        export IT_UNSCRAMBL_OS="ub18"$IT_UNSCRAMBL_BUILD_ARCH
    elif [[ "$version" == "16.04" ]]; then
        export IT_UNSCRAMBL_OS="ub16"$IT_UNSCRAMBL_BUILD_ARCH
    else
        export IT_UNSCRAMBL_OS="ub1404"$IT_UNSCRAMBL_BUILD_ARCH
    fi
fi

alias chrome='/opt/google/chrome/google-chrome &'
alias llm='ls --color=auto -la | less -r'
alias restartkwin="kwin --replace > /dev/null 2>&1 &"
alias term='terminator &'
alias vi='gv'
alias v='vim'

# making sure core files are created
ulimit -c unlimited

# Unscrambl Drive's Java
if [[ "$IT_UNSCRAMBL_OS" == "rhel07ppc64"* ]]; then
    export IT_UNSCRAMBL_JDK_PATH=/opt/unscrambl/drive/ppc64le/ibm-java-sdk-8.0-5.26
    export IT_NODEJS_PATH=/opt/unscrambl/drive/ppc64le/node-8.14.0-npm-6.9.0/bin
else
    export IT_UNSCRAMBL_JDK_PATH=/opt/unscrambl/drive/x86_64/jdk-1.8.0_152
    export IT_NODEJS_PATH=/opt/unscrambl/drive/x86_64/node-8.14.0-npm-6.9.0/bin
fi
export IT_UNSCRAMBL_JDK_BIN_PATH=$IT_UNSCRAMBL_JDK_PATH/bin
export JAVA_HOME=${JAVA_HOME:-$IT_UNSCRAMBL_JDK_PATH}

# flushing history after every command and re-reading it
export PROMPT_COMMAND='history -a; history -r'

# for tools that require an editor
export EDITOR=vim

# increasing the default size of Bash's history
export HISTSIZE=15000
export HISTTIMEFORMAT="%F %T "

# when running in an environment where an Unscrambl product is being built/executed (in which case UNSCRAMBL_PRODUCT is
# defined and non-zero), certain components of the PATH (e.g., Node.js, Java, and Python) must not be altered since they
# are, in many cases, invoked by the Bash's shebang feature, which will in most cases use whatever is in the PATH - this
# is something that can create very subtle bugs, since a different version of those runners might be used. The branch
# below ensures that whatever non-compliant settings needed by the user are not used when in an Unscrambl
# build/production environment
if [[ -z ${UNSCRAMBL_PRODUCT:-} ]]; then
    export PATH=/opt/unscrambl/drive/$IT_UNSCRAMBL_OS/git-2.14.1/bin:$IT_NODEJS_PATH:$IT_UNSCRAMBL_JDK_BIN_PATH:$PATH
    if [[ "$IT_UNSCRAMBL_OS" == "rhel07ppc64"* ]]; then
        PATH=/opt/at8.0/bin:/opt/at8.0/sbin:$PATH
    fi
fi
export PATH=$PATH:/home/rahullad/bin

# ---------------------
# Bakchodi Aliases
# ---------------------
alias please='sudo'

# ---------------------
# Default Python Version
# ---------------------
alias python=python3


# ---------------------
# Unscrambl Aliases
# ---------------------
alias smstart='$UNSCRAMBL_HOME/bin/services_manager stop;$UNSCRAMBL_HOME/bin/services_manager start'
alias smstop='$UNSCRAMBL_HOME/bin/services_manager stop'
alias smcheck='$UNSCRAMBL_HOME/bin/services_manager check'
alias devenv='./dev_env_bootstrapper/dev_environment_setter'
alias office='~/.screenlayout/office_layout.sh;~/i3-setup/springboard-connect.sh'
alias gohome='~/.screenlayout/base_layout.sh'
alias solroot='cd $UNSCRAMBL_SOLUTION_ROOT/'
alias chailogs='cd $UNSCRAMBL_HOME/../../../instance_home/$UNSCRAMBL_SOLUTION/service_management/core_services/bot_service/logs/'
alias sollogs='cd $UNSCRAMBL_HOME/../../../instance_home/$UNSCRAMBL_SOLUTION/service_management/query_bots/'
alias vpnconnect='nmcli con up id vpn-pune -a'
alias vpndown='nmcli con down id vpn-pune'
alias postman='nohup /home/rahullad/Downloads/Postman/Postman -o /home/rahullad/Downloads/Postman/postman-logs.out &'
alias flash='smstop;make install'
alias shit='make pristine;make clean-npm-cache;make install'
alias btconnect='echo -e "connect C7:63:77:00:63:3D" | bluetoothctl'
alias btdown='echo -e "disconnect" | bluetoothctl'
