# Archmage's fish config file
# Created on 2018-02-12
# Last updated on 2019-03-19

# Global variables!

# Make lscolors hurt less
set -gx LSCOLORS gxfxcxdxbxegedabagacad

# Quotes things

# - quotefile: the source file used for quotes
set -g quotefile ~/quotes
# - quoterandom: whether to pick a random quote
#                default is "day number" % quotetotal
set -g quoterandom 1

# LSCOLORS nonsense
set -x LS_COLORS "rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=30;41:tw=30:ow=34:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.zst=01;31:*.tzst=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.wim=01;31:*.swm=01;31:*.dwm=01;31:*.esd=01;31:*.jpg=01;35:*.jpeg=01;35:*.mjpg=01;35:*.mjpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:"

# Set prompt!
function fish_prompt
    # powerline-shell --shell bare $status
    # printf "\n"

    set usercolor DD2E26
    set hostcolor AC00D1

    if test -n "$SSH_CLIENT" -o -n "$SSH_TTY"
        set hostcolor 3D7EE5
    end

    # Username.
    set_color -b $usercolor
    set_color FFFFFF
    printf " "$USER" "

    # ...belonging to... 
    set_color $usercolor
    set_color -b $hostcolor
    printf " "
    
    # ...this hostname.
    set_color FFFFFF 
    printf (hostname -s | tr '[:upper:]' '[:lower:]')" "
    
    # More arrows.
    set_color $hostcolor
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
    if test $quoterandom -eq 1
        set quoteindex (random 1 $quotecount)
    end

    # parse quote and source at index using grep
    set quotetext (grep "\".*\"" < $quotefile | sed -n "$quoteindex""p")
    set quotesrc (grep "\-.*" < $quotefile | sed -n "$quoteindex""p")

    # print!
    echo "$quotetext"
    echo "$quotesrc"
end

function reassure
    echo "You are a problem-solver. Your job is to solve problems, and you are good at"
    echo "solving problems. Every obstacle is just a problem to be solved. You can do it!"
end
