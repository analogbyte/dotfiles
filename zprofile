if which keychain 2>&1 >/dev/null && [ -f ~/.ssh/id_rsa ]; then
    eval $(keychain --eval --agents ssh -Q --nogui --quiet id_rsa)
fi
if which gpg-agent 2>&1 >/dev/null; then
    eval $(gpg-agent --quiet --daemon)
fi
