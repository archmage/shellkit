# Kara's fish config file
# Created on 2018-02-12
# Last updated on 2018-02-16

# Global variables!

# Make lscolors hurt less
set -gx LSCOLORS gxfxcxdxbxegedabagacad

# Quotes things

# - quotefile: the source file used for quotes
set -g quotefile /Users/kara/quotes
# - quoterandom: whether to pick a random quote
#                default is "day number" % quotetotal
set -g quoterandom 1

# Set prompt!
function fish_prompt
    # Zodiac symbol!
    set_color 4EDDCE
    zodiac_current

    # Username.
    set_color DD2E26
    printf $USER

    # ...belonging to... 
    set_color B190D1
    printf "~"
    
    # ...this hostname.
    set_color AC00D1
    printf (hostname -s | tr '[:upper:]' '[:lower:]')" "
    
    # Trivial things
    # if math "1 > 0" > /dev/null
    #     set_color 4EDDCE
    #     zodiac_current
    # end
    
    # Location!
    set_color D9D036
    printf $PWD"/ "             # Current path
    # printf (basename $PWD)/   # Current directory

    # Git branch
    set_color 00A900
   
    # Homestuck prompt :)
    set_color 00A900
    printf "\n==> "
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
    set quotecount (eval wc -l < $quotefile)
    set daynum (date +%j)
    set quoteindex (math "$daynum % $quotecount")
    if math "$quoterandom==1" > /dev/null
        set quoteindex (random 1 $quotecount)
    end
    set quotetext (eval sed -n "$quoteindex""p" < $quotefile)
    printf "$quotetext"
end