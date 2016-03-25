function prepend_command
    set -l prepend $argv[1]
    if test -z "$prepend"
        echo "prepend_command needs one argument."
        return 1
    end
    set -l cmd (commandline)
    if test -z "$cmd"
        commandline -r $history[1]
    end
    set -l old_cursor (commandline -C)
    commandline -C 0
    commandline -i "$prepend "
    commandline -C (math $old_cursor + (echo $prepend | wc -c))
end

function my_vi_key_bindings
    fish_vi_key_bindings
    bind -M insert \cl 'clear; commandline -f repaint'
    bind -M insert \e. 'history-token-search-backward'
    bind -M insert \es 'prepend_command sudo'
    bind -M insert \e\[H beginning-of-line
    bind -M insert \e\[F end-of-line
    bind -M insert \ep __fish_paginate
    bind -M insert \el 'ls; commandline -f repaint'
end
set -g fish_key_bindings my_vi_key_bindings

function sudo
    if test "$argv" = !!
        eval command sudo $history[1]
    else
        command sudo $argv
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

function fish_prompt
    if set -q VIRTUAL_ENV
        echo -n -s (set_color cyan) "(" (basename "$VIRTUAL_ENV") ")" (set_color normal) " "
    end
    set_color --bold red
    echo -n (whoami)
    set_color normal
    echo -n "@"(hostname)" "
    set_color --bold white
    echo -n (prompt_long_pwd)
    set_color normal
    printf '%s ' (__fish_git_prompt)
    echo -n '% '
end

eval (python -m virtualfish)

# source /home/danieln/Code/z-fish/z.fish
source /etc/profile.d/autojump.fish

if [ $TERM = "xterm-termite" ];
    set -x GPG_TTY (tty)
    gpg-connect-agent /bye
end

set -x NVIM_TUI_ENABLE_TRUE_COLOR 1
set -x NVIM_TUI_ENABLE_CURSOR_SHAPE 1
set -x MANWIDTH 100
set -x VAGRANT_DEFAULT_PROVIDER libvirt
alias vim=nvim
alias ssh='env TERM=xterm-256color ssh'
alias startx="startx -- -dpi 96"
abbr g=git
