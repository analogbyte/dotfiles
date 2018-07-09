set -x LANG en_US.UTF-8

function my_vi_key_bindings
    fish_vi_key_bindings
    bind -M insert \cl 'clear; commandline -f repaint'
    bind -M insert \e. 'history-token-search-backward'
    bind -M insert \e\[H beginning-of-line
    bind -M insert \e\[F end-of-line
    bind -M insert \ep __fish_paginate
    bind -M insert \el 'echo ''; ls; commandline -f repaint'
    bind -M insert -k dc delete-char
    function __fzf_ctrl_r
        history | fzf +m --tiebreak=index --toggle-sort=ctrl-r | read -l select
        and commandline -rb $select
        commandline -f repaint
    end
    bind -M insert \cr '__fzf_ctrl_r'
    bind -M insert \cf 'fg % ^ /dev/null'
    bind \cz 'fg %'
end
set -g fish_key_bindings my_vi_key_bindings

function sudobangbang --on-event fish_postexec
    abbr !! sudo $argv[1]
end

#function __chdir_hook --on-variable PWD --description 'do stuff on dir change'
#    status --is-command-substitution; and return
#
#    if [ $PWD = "/home/danieln/work/go" ]
#        echo "Setting GOPATH."
#        set -x GOPATH ~/work/go
#    end
#end

set fish_greeting ""

set -g __fish_git_prompt_show_informative_status 1
set -g __fish_git_prompt_hide_untrackedfiles 1

set -g __fish_git_prompt_color_branch magenta
set -g __fish_git_prompt_showupstream "informative"
set -g __fish_git_prompt_char_upstream_ahead "↑"
set -g __fish_git_prompt_char_upstream_behind "↓"
set -g __fish_git_prompt_char_upstream_prefix ""

set -g __fish_git_prompt_char_stagedstate "●"
set -g __fish_git_prompt_char_dirtystate "✚"
set -g __fish_git_prompt_char_untrackedfiles "…"
set -g __fish_git_prompt_char_conflictedstate "✖"
set -g __fish_git_prompt_char_cleanstate "✔"

set -g __fish_git_prompt_color_dirtystate blue
set -g __fish_git_prompt_color_stagedstate yellow
set -g __fish_git_prompt_color_invalidstate red
set -g __fish_git_prompt_color_untrackedfiles $fish_color_normal
set -g __fish_git_prompt_color_cleanstate green

function prompt_long_pwd --description 'Print the current working directory'
    echo $PWD | sed -e "s|^$HOME|~|"
end

function indicate_ranger --description 'Print a indicator when running in ranger'
    set NUM (pstree -s %self | grep -o ranger | wc -l)
    for x in (seq $NUM)
        echo -n ">"
    end
end

function fish_prompt
    set pre_prompt_eval_status $status
    if test $pre_prompt_eval_status -ne 0
        switch $pre_prompt_eval_status
            case 1
                set_color brred
            case '*'
                set_color brgrey
        end
        echo -n $pre_prompt_eval_status' '
    end
    set_color normal
    if set -q VIRTUAL_ENV
        echo -n -s (set_color cyan) "(" (basename "$VIRTUAL_ENV") ")" (set_color normal) " "
    end
    set_color red
    echo -n (whoami)
    set_color normal
    echo -n "@"(hostname)" "
    set_color green
    echo -n (prompt_long_pwd)
    set_color normal
    printf '%s' (__fish_git_prompt)
    echo -n (indicate_ranger)
    echo -n '> '
end

function fish_mode_prompt
end function

function lg
    nvim ~/logbook/(date '+%Y-%m-%d').md ~/notes/*
end function

function ww
    timew week 2018-W(printf "%.2d" $argv[1])-1 to 2018-W(printf "%.2d" (math $argv[1]+1))-1
end function

if not set -q VIRTUAL_ENV
    eval (python -m virtualfish)
end

# source /home/danieln/Code/z-fish/z.fish
source /usr/share/autojump/autojump.fish

set -x PATH /home/danieln/.cargo/bin /usr/local/bin/ /home/danieln/.gem/ruby/2.4.0/bin $PATH

# gpg and ssh agent
# gpgconf --launch gpg-agent
# set -e SSH_AUTH_SOCK
# set -U -x SSH_AUTH_SOCK /run/user/1000/gnupg/S.gpg-agent.ssh
# set -x GPG_TTY (tty)
# eval (gpg-agent --daemon -c --quiet ^ /dev/null)
echo "UPDATESTARTUPTTY" | gpg-connect-agent > /dev/null 2>&1
set -x SSH_AUTH_SOCK $XDG_RUNTIME_DIR/gnupg/S.gpg-agent.ssh

set -x EDITOR nvim

set -x NVIM_TUI_ENABLE_TRUE_COLOR 1
set -x MANWIDTH 100
set -x VAGRANT_DEFAULT_PROVIDER libvirt
set -x LESS_TERMCAP_mb (printf "\033[01;31m")
set -x LESS_TERMCAP_md (printf "\033[01;31m")
set -x LESS_TERMCAP_me (printf "\033[0m")
set -x LESS_TERMCAP_se (printf "\033[0m")
set -x LESS_TERMCAP_so (printf "\033[01;44;33m")
set -x LESS_TERMCAP_ue (printf "\033[0m")
set -x LESS_TERMCAP_us (printf "\033[01;32m")
alias vim=nvim
alias irc='mosh -p 61293 irc -- tmux a -t 0 -d'
alias r=ranger
alias ssh='env TERM=xterm-256color ssh'
alias docker_ip="docker inspect --format '{{ .NetworkSettings.IPAddress }}'"
alias merge_pdf="gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -dPDFSETTINGS=/prepress -sOutputFile=merged.pdf"
# alias startx="startx -- -dpi 96"
alias ip='ip -c'
alias dmesg='dmesg -T'

abbr g=git
