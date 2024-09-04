if status is-interactive
    # Commands to run in interactive sessions can go here
end

#Starship Config
starship init fish | source


# fnm configuration for Fish
set -x PATH /home/ibarra/.fnm $PATH
eval (fnm env)
