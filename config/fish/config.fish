function fish_greeting
    set -l quotes \
        "We ride together, we die together. Bad Boys for life!" \
        "Did we just become best friends? Yup!" \
        "Now this is a story all about how my life got flipped-turned upside down." \
        "I'm so excited! I'm so scared!" \
        "It's over 9000!" \
        "I am the hope of the universe. I am the answer to all living things that cry out for peace." \
        "You can't handle the truth!" \
        "I am vengeance, I am the night, I am Batman!" \
        "You know what they say: 'With great power comes great responsibility.'" \
        "To infinity and beyond!"

    set -l quote_count (count $quotes)
    set -l random_index (random 1 $quote_count)
    echo $quotes[$random_index]
end
starship init fish | source

# eza (modern ls replacement) configuration
# Add cargo bin to PATH if not already there
fish_add_path ~/.cargo/bin

# eza aliases
alias ls='eza'
alias ll='eza -l --icons'
alias la='eza -la --icons'
alias lt='eza --tree --level=2 --icons'
alias lta='eza --tree --level=2 -a --icons'

# SSH agent setup
if not pgrep -u (whoami) ssh-agent > /dev/null; 
    eval (ssh-agent -c) 
end
ssh-add --quiet ~/.ssh/Fedora # Add the private SSH key

# chips
if [ -e ~/.config/chips/build.fish ] ; . ~/.config/chips/build.fish ; end
starship init fish | source
export TERMINAL=ghostty
export FILEMANAGER=nautilus
