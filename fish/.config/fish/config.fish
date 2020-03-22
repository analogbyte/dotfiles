set -x LANG en_US.UTF-8
set -x TERM xterm

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

function unclean_repos
    for path in (find -name ".git" -type d | grep -v "/.cache/")
        cd $path/..
        git status | grep clean > /dev/null
        if test $status -ne 0
            echo $path/..
        end
        cd -
    end
end

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
end

function ww
    timew week 2019-W(printf "%.2d" $argv[1])-1 to 2019-W(printf "%.2d" (math $argv[1]+1))-1
end

if not set -q VIRTUAL_ENV
    eval (python -m virtualfish)
end

set -x PATH /home/danieln/.cargo/bin /usr/local/bin/ /home/danieln/.gem/ruby/2.4.0/bin /home/danieln/.gem/ruby/2.6.0/bin $PATH

# gpg and ssh agent
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
alias docker_ip="docker inspect --format '{{ .NetworkSettings.IPAddress }}'"
alias merge_pdf="gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -dPDFSETTINGS=/prepress -sOutputFile=merged.pdf"
alias ip='ip -c'
alias dmesg='dmesg -T'
