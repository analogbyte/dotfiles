eval $(keychain --eval --agents ssh -Q --nogui --quiet id_rsa)
eval $(gpg-agent --quiet --daemon)
# [[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx
