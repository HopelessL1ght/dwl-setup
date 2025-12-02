#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return



### Aliases ###
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias probe = 'ssh ryan@192.168.0.55'
alias smci = 'sudo make clean install'

# pacman #
alias get='sudo pacman -Sy --needed'
alias upgrade='sudo pacman -Syyu --needed'
alias remove='sudo pacman -Rsc'
alias dwmrl= "cd /home/ryan/winman/rswk-dwm/dwm-setup/dwm"

alias del='sudo rm -ir'
alias ff='fastfetch -l arch_small' #'fastfetch -l arch_small'#C
alias bt='bashtop'
alias pipes='/home/ryan/Documents/pipes.sh'
alias rain='/home/ryan/Documents/rain.sh'
alias cdu='cd ../'


PS1='[\u@\h \W]\$ '

### On start ###
wal -R
clear

source ~/Documents/twoline.sh


# Created by `pipx` on 2024-07-29 09:13:55
export PATH="$PATH:/home/ryan/.local/bin"
