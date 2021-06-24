#####################################################################
# basic settings {{{
#####################################################################
set -x TERM xterm
set -x LANG en_US.UTF-8
set -x PATH /home/danieln/.cargo/bin /usr/local/bin/ $PATH
set -x EDITOR nvim

set fish_greeting ""

function fish_user_key_bindings
    fish_default_key_bindings -M insert
    fish_vi_key_bindings --no-erase insert
    fzf_key_bindings
end

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

# keychain
if status is-login
   eval (keychain --eval --quiet --agents ssh,gpg id_belwue id_danieln 9B8686A3022A370E)
end
if test -f ~/.keychain/(hostname)-fish
    source ~/.keychain/(hostname)-fish
end
if test -f ~/.keychain/(hostname)-gpg-fish
    source ~/.keychain/(hostname)-gpg-fish
end

# }}}

#####################################################################
# prompt stuff {{{
#####################################################################
set -g __fish_git_prompt_show_informative_status 1

set -g __fish_git_prompt_color_branch magenta
set -g __fish_git_prompt_showupstream "informative"

set -g __fish_git_prompt_color_dirtystate blue
set -g __fish_git_prompt_color_stagedstate yellow
set -g __fish_git_prompt_color_invalidstate red
set -g __fish_git_prompt_color_cleanstate green

function indicate_ranger --description 'Print a indicator when running in ranger'
    set NUM (pstree -s %self | grep -o ranger | wc -l)
    for x in (seq $NUM)
        echo -n "#"
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
    set_color cyan
    if set -q VIRTUAL_ENV
        echo -n "("(basename "$VIRTUAL_ENV")") "
    end
    set_color red
    echo -n (whoami)
    set_color normal
    echo -n "@"(hostname)" "
    set_color green
    echo -n $PWD | sed -e "s|^$HOME|~|"
    set_color normal
    printf '%s' (__fish_git_prompt)
    echo -n ' '
    echo -n (indicate_ranger)
    echo -n '# '
end

function fish_right_prompt
  # display the timestamp on the utmost right.
  set_color 32302f
  echo -n '  ['(date +%H:%M:%S)']'
  set_color normal
end

function fish_mode_prompt
end
# }}}

#####################################################################
# custom commands {{{
#####################################################################
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

alias vim=nvim
alias irc='mosh -p 61293 irc -- tmux a -t 0 -d'
alias r=ranger
alias docker_ip="docker inspect --format '{{ .NetworkSettings.IPAddress }}'"
alias merge_pdf="gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -dPDFSETTINGS=/prepress -sOutputFile=merged.pdf"
alias ip='ip -c'
alias dmesg='dmesg -T'
# }}}

#####################################################################
# ledger stuff {{{
#####################################################################
set -x LEDGER_FILE /home/danieln/finance/hledger.journal
alias hl=hledger
# }}}
