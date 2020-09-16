#-------------------------------#
# GLOBALS                       #
#-------------------------------#
TIME="/bin/date +%H%M%S"
DATE="/bin/date +%Y%m%d"
DTIME="/bin/date +%Y%m%d%H%M%S"
HDT="/bin/date +%Y.%m.%d-%H:%M:%S"
EDITOR="/usr/bin/vim"
BACKUP_DIR="${HOME}/backup/bash"



#-------------------------------#
# COLORS                        #
#-------------------------------#
case ${TERM} in
    xterm-color|*-256color) USE_COLORS=1
                            ARG_COLOR='auto'  ;;
    ?*                    ) USE_COLORS=0
                            ARG_COLOR='never' ;;
esac

if [ "$USE_COLORS" = 1 ] ;then
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
    if [ -f "${HOME}/.dircolors" ] ;then
        eval $(dircolors -b $HOME/.dircolors) ;fi ;fi



#-------------------------------#
# FUNCTIONS                     #
#-------------------------------#
extract(){
    ERR_MSG="could not extract! ( $1 )"

    if [ -f $1 ] ;then
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
        echo "is not a valid file! ( $1 )" ;fi ;}


file_backup(){
    FN=${FUNCNAME}
    ## CHK: if backup dir exist
    if [ ! -d "${BACKUP_DIR}" ] ;then
        if ! mkdir -p ${BACKUP_DIR} ;then
            echo "${FN} err, could not create backup dir ( ${BACKUP_DIR} )"
            return 1 ;fi ;fi

    ## CHK: if backup dir has write access
    if [ ! -w "${BACKUP_DIR}" ] ;then
        echo "${FN} err, backup dir has no write access! ( ${BACKUP_DIR} )"
        return 1 ;fi

    ## CHK: if file is a directory
    if [ -d "$1" ] ;then
       echo "${FN} err, wont backup entire directory! ( $1 )"
       return 1 ;fi

    ## CHK: permission
    if [ ! -r "$1" ] ;then
        CMD='sudo cp'
    else
        CMD='cp' ;fi 

    ## COPY: file to backup dir
    if ! ${CMD} ${1} ${BACKUP_DIR}/`basename ${1}` ;then
        echo "${FN} err, could not copy file! ( $1 )"
        return 1 ;fi ;}


edit(){
    if [ -z "$1" ] ;then
        $EDITOR 
        return 0 ;fi

    if [ ! -f "$1" ] ;then
        $EDITOR $1 
        return 0 ;fi

    if [ -w "$1" ] ;then
        file_backup $1
        $EDITOR $1

    else
        file_backup $1
        sudo $EDITOR $1 ;fi ;}



#-------------------------------#
# HISTORY                       #
#-------------------------------#
HISTCONTROL=ignoreboth
shopt -s histappend
HISTSIZE=5000
HISTFILESIZE=5000

[ -f ~/.fzf.bash ] && source ~/.fzf.bash


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

## MISC
alias lock='i3lock -i ~/pic/bg/swave01.png'



#-------------------------------#
# EXPORTS                       #
#-------------------------------#
export PATH=~/.local/bin:$PATH
export PATH="${PATH}:${HOME}/bin"



#-------------------------------#
# MISC                          #
#-------------------------------#
## check window size after each command
shopt -s checkwinsize 

## lesspipe
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

## bash completion
if ! shopt -oq posix ;then
  if [ -f /usr/share/bash-completion/bash_completion ] ;then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ] ;then
    . /etc/bash_completion ;fi ;fi



#-------------------------------#
# PROMT                         #
#-------------------------------#
if [ "$USER" = 'root' ] ;then
    PS1_TIME="${bg_black}${white}[${yellow_1}\t${white}]"
    PS1_USER_AT_HOST="[${red_3}\u${white}@${purple_3}\h${white}]"
    PS1_DIR_PATH="[${blue_3}\w${white}]${esc}\n  "

    ## [time][user@host][/dir_path]
    PS1="${PS1_TIME}${PS1_USER_AT_HOST}${PS1_DIR_PATH}"

else
    PS1_TIME="${bg_black}${white}[${yellow_1}\t${white}]"
    PS1_USER_AT_HOST="[${green_3}\u${white}@${purple_3}\h${white}]"
    PS1_DIR_PATH="[${blue_3}\w${white}]${esc}\n  "

    ## [time][user@host][/dir_path]
    PS1="${PS1_TIME}${PS1_USER_AT_HOST}${PS1_DIR_PATH}" ;fi

