########################################################
#          __________________________________          #
#          | _ )  /_\  / __|| || || _ \ / __|          #
#          | _ \ / _ \ \__ \| __ ||   /| (__           #
#          |___//_/ \_\|___/|_||_||_|_\ \___|          #
#                                                      #
########################################################
#
# [ FUNCTIONS ]
#
# extract <file.format>
#   Extract compressed files
#   Formats: tar.bz2, tar.gz, bz2, rar, gz, tar, tbz2, tgz, zip, Z, 7z
# 
# list_largest_files | list_largest_files <1|2|3>
#   List largest files in current directory
#
# e <filename>
#   Edit file with defined $EDITOR and decide automatically to
#   use sudo or not
#
# s | s <command>
#   Sudo last command, or sudo <command>
#
# ifaddr
#  List Network interfaces and its ip4 and ip6 addresses
#
#
# [ ALIASES ]
#  
# cd. |cd.. |cd...
#   cd ../ |cd ../../ |cd ../../../
#
# gh <expression>
#   grep bash history
#
# gp <expression>
#   grep processes
#
# gf <expression>
#   grep find


#-------------------------------#
# GLOBALS                       #
#-------------------------------#
TIME="/bin/date +%H%M%S"
DATE="/bin/date +%Y%m%d"
DTIME="/bin/date +%Y%m%d%H%M%S"
HDT="/bin/date +%Y.%m.%d-%H:%M:%S"
BACKUP_DIR="${HOME}/backup/bash"



#-------------------------------#
# COLORS                        #
#-------------------------------#
case ${TERM} 
in
    xterm-color|*-256color )
        USE_COLORS=1
        ARG_COLOR='auto'  ;;  
    ?* )
        USE_COLORS=0
        ARG_COLOR='never' ;;
esac


if [ "$USE_COLORS" = 1 ] 
then
    ## black background for bright
    ## terminals themes
    bg_black=`tput setab 0`

    ## Some colors
    black=`tput setaf 0`
    white=`tput setaf 231`
    red_1=`tput setaf 9`
    red_2=`tput setaf 196`
    red_3=`tput setaf 202`
    green_1=`tput setaf 118`
    green_2=`tput setaf 119`
    green_3=`tput setaf 120`
    blue_1=`tput setaf 33`
    blue_2=`tput setaf 45`
    blue_3=`tput setaf 51`
    yellow_1=`tput setaf 11`
    yellow_2=`tput setaf 191`
    yellow_3=`tput setaf 192`
    orange_1=`tput setaf 208`
    orange_2=`tput setaf 214`
    purple_1=`tput setaf 99`
    purple_2=`tput setaf 141`
    purple_3=`tput setaf 153`

    ## color escape sequence
    esc="$(tput sgr0)"

    ## load terminal colors
    if [ -f "${HOME}/.dircolors" ]
    then
        eval $(dircolors -b $HOME/.dircolors) 
    fi 
fi



#-------------------------------#
# FUNCTIONS                     #
#-------------------------------#
## Extract archive files
## extract <file.format>
extract(){
    ERR_MSG="could not extract! ( $1 )"

    if [ -f $1 ] 
    then
        case $1 in
            *.tar.bz2 ) tar xjf $1      ;;
            *.tar.gz  ) tar xzf $1      ;;
            *.bz2     ) bunzip2 $1      ;;
            *.rar     ) rar x $1        ;;
            *.gz      ) gunzip $1       ;;
            *.tar     ) tar xf $1       ;;
            *.tbz2    ) tar xjf $1      ;;
            *.tgz     ) tar xzf $1      ;;
            *.zip     ) unzip $1        ;;
            *.Z       ) uncompress $1   ;;
            *.7z      ) 7z x $1         ;;
            *         ) echo $ERR_MSG   ;;
        esac

    else
        echo "is not a valid file! ( $1 )"
    fi 
}


## List largest files in a direcory
## list_largest_files | list_largest_files <1|2|3|...n>
list_largest_files() {
    LINES="${1:-20}"
    du -h -x -s -- * | sort -r -h | head -${LINES} ;}


## sudo or sudo the last command if no argument is specified
s() {
    if [[ $# == 0 ]]
    then
        sudo $(history -p '!!')
    else
        sudo "$@" 
    fi 
}


## edit file with specified editor $EDITOR
## automatically decide to use sudo or not
## args: </path/file>
e() {
    if [ -w "$1" ] 
    then
        $EDITOR $1

    else
        sudo $EDITOR $1 
    fi 
}


# ifconfig was cool, and ip is more cool
# but most of the time, they are to verbose ;)
ifaddr() {
    IFACES=`cat /proc/net/dev |awk '{print $1}' |grep ':' |cut -d ':' -f 1`

    for iface in $IFACES
    do
        IP4_ADDR=`ip addr show dev $iface |grep -w inet |awk '{print $2}'`
        IP6_ADDR=`ip addr show dev $iface |grep -w inet6 |awk '{print $2}'`
        IP_ADDR="$IP4_ADDR $IP6_ADDR"

        REPEAT_IFACE="$iface"

        if echo $IP_ADDR |grep -q '\.\|\:'
        then
            for addr in $IP_ADDR 
            do
                printf "%-15s %s\n" "$REPEAT_IFACE" "$addr"
                REPEAT_IFACE= 
            done 
        fi
        echo
    done 
}     


#-------------------------------#
# HISTORY                       #
#-------------------------------#
shopt -s histappend
HISTSIZE=5000
HISTFILESIZE=5000
HISTCONTROL=ignoredups



#-------------------------------#
# ALIASES                       #
#-------------------------------#
## LS
alias ls="ls --color=${ARG_COLOR}"

## CD
alias cd.='cd ../'
alias cd..='cd ../../'
alias cd...='cd ../../../'

## GREP
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias gh="history |grep"
alias gp="ps aux  |grep"
alias gf="find .  |grep"

# MISC
alias c='clear'
alias h='history'
alias tree='tree --dirsfirst -F'
alias mkdir='mkdir -p -v'


#-------------------------------#
# EXPORTS                       #
#-------------------------------#
PATH='/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:/snap/bin'
export PATH="${PATH}:~/local/bin:~/bin"
export EDITOR=vim
``

#-------------------------------#
# MISC                          #
#-------------------------------#
## check window size after each command
shopt -s checkwinsize

## auto cd into directories
shopt -s autocd



#-------------------------------#
# PROMT                         #
#-------------------------------#
if [ "$USER" = 'root' ] 
then
    PS1_TIME="${bg_black}${white}[${yellow_1}\t${white}]"
    PS1_USER_AT_HOST="[${red_3}\u${white}@${purple_3}\h${white}]"
    PS1_DIR_PATH="[${blue_3}\w${white}]${esc}\n  "

    ## [time][user@host][/dir_path]
    PS1="${PS1_TIME}${PS1_USER_AT_HOST}${PS1_DIR_PATH}"

else
    PS1_TIME="${bg_black}${white}[${yellow_1}\t${white}]"
    PS1_USER_AT_HOST="[${green_1}\u${white}@${purple_3}\h${white}]"
    PS1_DIR_PATH="[${blue_3}\w${white}]${esc}\n  "

    ## [time][user@host][/dir_path]
    PS1="${PS1_TIME}${PS1_USER_AT_HOST}${PS1_DIR_PATH}" 
fi
