if which keychain &> /dev/null && [ -f ~/.ssh/id_danieln ]; then
    eval $(keychain --eval --agents ssh -Q --nogui --quiet id_danieln)
fi
