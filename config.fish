# Kara's fish config file
# Created on 2018-02-12
# Last updated on 2018-02-16

# Global variables!

# Make lscolors hurt less
set -gx LSCOLORS gxfxcxdxbxegedabagacad

# Quotes things

# - quotefile: the source file used for quotes
set -g quotefile ~/quotes
# - quoterandom: whether to pick a random quote
#                default is "day number" % quotetotal
set -g quoterandom 1

# Set prompt!
function fish_prompt
    # powerline-shell --shell bare $status
    # printf "\n"

    # detect SSH
    set -l usercolor DD2E26 # DD2E26
    if test -n "$SSH_CLIENT" -o -n "$SSH_TTY"
        set -l usercolor 3D7EE5 # DD2E26
    end

    # Zodiac symbol!
    set_color -b $usercolor
    set_color FFFFFF
    printf " ""♊︎" 

    # Username.
    set_color -b $usercolor
    printf $USER" "

    # ...belonging to... 
    set_color $usercolor
    set_color -b AC00D1
    printf " "
    
    # ...this hostname.
    set_color FFFFFF 
    printf (hostname -s | tr '[:upper:]' '[:lower:]')" "
    
    # More arrows.
    set_color AC00D1
    set_color -b D9D036
    printf " "

    # get the current dir nicely ... replace $HOME with "~"
    set -l realhome ~
    set -l dir (string replace -r '^'"$realhome"'($|/)' '~$1' $PWD)

    # start with the "full" directory
    set -l pl1 "[$USER] $dir"

    # get the length
    set -l pl1_len (string length $pl1)
    set -l pl1_len (math "$pl1_len+20")

    if test "$pl1_len" -gt "$COLUMNS"
      # too long, use the shortened version of dir instead
      set dir (prompt_pwd)
    end

    # Location!
    set_color -b D9D036
    set_color 000000
    printf $dir" "             # Current path
    # printf (basename $PWD)/   # Current directory

    # Even more arrows.
    set_color --background=normal
    set_color D9D036
    printf " " 

    # Homestuck prompt :)
    set_color 00A900
    printf "\n╚═> "
end

function fish_greeting 
    quote
end 

# This is mathematically incorrect, but whatever.
function zodiac_current
    set monthnum (date +%m)
    set signs "♑︎" "♒︎" "♓︎" "♈︎" "♉︎" "♊︎" "♋︎" "♌︎" "♍︎" "♎︎" "♏︎" "♐︎"
    printf $signs[$monthnum]
end

# For fun!
function zodiac_all
    printf "♈︎ ♉︎ ♊︎ ♋︎ ♌︎ ♍︎ ♎︎ ♏︎ ♐︎ ♑︎ ♒︎ ♓︎"
end

# Get a quote from the quotes file.
function quote
    # grep lines matching ".*" to find quote count
    set quotecount (grep "\".*\"" < $quotefile | wc -l)

    # better scheduled quotes using num of days from epoch
    set secsfromepoch (date +%s)
    set daysfromepoch (math "$secsfromepoch / 86400")
    set quoteindex (math "$daysfromepoch % $quotecount")

    # if $quoteerandom, use a random quote instead
    if math "$quoterandom==1" > /dev/null
        set quoteindex (random 1 $quotecount)
    end

    # parse quote and source at index using grep
    set quotetext (grep "\".*\"" < $quotefile | sed -n "$quoteindex""p")
    set quotesrc (grep "\-.*" < $quotefile | sed -n "$quoteindex""p")

    # print!
    printf "$quotetext\n $quotesrc"
end

function reassure
    echo "You are a problem-solver. Your job is to solve problems, and you are good at"
    echo "solving problems. Every obstacle is just a problem to be solved. You can do it!"
end