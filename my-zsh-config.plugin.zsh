# According to the Zsh Plugin Standard:
# http://zdharma.org/Zsh-100-Commits-Club/Zsh-Plugin-Standard.html

0="${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}"
0="${${(M)0:#/*}:-$PWD/$0}"

# Then ${0:h} to get plugin's directory

### ZSHOPTIONS ###

# Basic
# beeps are annoying
setopt no_beep
# Allow comments even in interactive shells (especially for Muness)
setopt interactive_comments
# don't warm me about incomming mail
unsetopt mail_warning

# Changing Directories
# why would you type 'cd dir' if you could just type 'dir'?
setopt auto_cd
setopt cdablevars
# this will ignore multiple directories for the stack
setopt pushd_ignored_ups
setopt pushdminus

# Completion
# When completing from the middle of a word, move the cursor to the end of the word
setopt always_to_end
# This will use named dirs when possible
setopt auto_name_dirs
unsetopt listambiguous
# If unset, the cursor is set to the end of the word if completion is started.
# Otherwise it stays there and completion is done from both ends.
setopt complete_in_word
# show completion menu on successive tab press. needs unsetop menu_complete to work
setopt auto_menu
# do not autoselect the first completion entry
unsetopt menu_complete


# History
# Allow multiple terminal sessions to all append to one zsh command history
setopt append_history
# save timestamp of command and duration
setopt extended_history
# Add comamnds as they are typed, don't wait until shell exit
setopt inc_append_history
# when trimming history, lose oldest duplicates first
setopt hist_expire_dups_first
# Do not write events to history that are duplicates of previous events
setopt hist_ignore_dups
setopt hist_ignore_all_dups
# remove command line from history list when first character on the line is a space
setopt hist_ignore_space
# When searching history don't display results already cycled through twice
setopt hist_find_no_dups
# Don't write duplicate entries in the history file.
setopt hist_save_no_dups
# Remove extra blanks from each command line being added to history
setopt hist_reduce_blanks
# don't execute, just expand history
setopt hist_verify
# imports new commands and appends typed commands to history
setopt share_history
setopt hist_no_store

# Prompt
# Enable parameter expansion, command substitution, and arithmetic expansion in the prompt
setopt prompt_subst
# only show the rprompt on the current prompt
#setopt transient_rprompt


# Scripts and Functions
# perform implicit tees or cats when multiple redirections are attempted
setopt multios


# Expansion and Globbing
# treat #, ~, and ^ as part of patterns for filename generation
# I don't know why I never set this before.
setopt extended_glob
# Case insensitive globbing
setopt nocaseglob
# Keep echo "station" > station from clobbering station
setopt noclobber
# If I could disable Ctrl-s completely I would!
setopt noflowcontrol
setopt nohup
# Be Reasonable!
setopt numericglobsort
# 10 second wait if you do something that will delete everything
setopt rmstarwait
# use magic (this is default, but it can't hurt!)
setopt zle

source ${0:h}/aliases.sh
source ${0:h}/functions.sh

# Add zsh hook to update JAVA_HOME
add-zsh-hook precmd asdf_update_java_home
