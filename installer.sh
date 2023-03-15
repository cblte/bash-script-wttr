#!/bin/bash
#author : Amirreza Firoozi
#author : Carsten Brueggenolte
#installer of wttr
#update 1.30: changed installation dir to $HOME/.local/bin and removed sudo because it is really not needed
#update 1.54: added check for whether $HOME/.local/bin is on the PATH
#update 1.55: fixed various issues with the script and updated some text

#Define target dir
target_dir="$HOME/.local/bin"

clear
echo -e "\nWelcome to the 'wttr' script installer\n------------------------------------\n"
echo -e "We will install 'wttr' to '$target_dir'"
read -n 1 -s -r -p "Press any key to continue or CTRL+C to exit."
echo -e "\n"

# Check if the target directory exists and create it if not
if [ ! -d "$target_dir" ]; then
  echo -e "Directory does not exist, creating it ..."
  mkdir -p "$target_dir" || {
    echo "Error: Failed to create directory $target_dir. Exiting."
    exit 1
  }
fi

# Copy the file to the target directory
echo -e "Copying file ..."
cp -R "wttr" "$target_dir" 2>/dev/null
st_0=$?

# Make the file executable
echo -e "Giving permission ..."
chmod +x "$target_dir/wttr" 2>/dev/null
st_1=$?

# Check if the target directory is in the PATH variable
if [[ ":$PATH:" != *":$target_dir:"* ]]; then
  # Add the target directory to the PATH variable
  echo "Your PATH is missing $target_dir, adding it ...\n"
  if [[ $SHELL == "/bin/bash" || $SHELL == "/usr/bin/bash" ]]; then
    echo "export PATH=$target_dir:$PATH" >>$HOME/.bashrc
    source "$HOME/.bashrc"
    echo "Added $target_dir to PATH and .bashrc"
  elif [[ $SHELL == "/bin/zsh" || $SHELL == "/usr/bin/zsh" ]]; then
    echo "export PATH=$target_dir:$PATH" >>$HOME/.zshrc
    source "$HOME/.zshrc"
    echo "Added $target_dir to PATH and .zshrc"
  elif [[ $SHELL == "/bin/fish" || $SHELL == "/usr/bin/fish" ]]; then
    fish_add_path $target_dir
    echo "Added $target_dir to the PATH and fish shell environment."
  else
    echo -e "Your shell wasn't either bash, zsh, or fish. Please add $target_dir to your PATH.\n"
    st_2=0
  fi
else
  st_2=$?
  echo -e "Your PATH is correctly set. Continuing ..."
fi

if [[ $st_0 == 0 && $st_1 == 0 ]]; then
  echo -e "\nCongratulations!\nInstallation has just completed \n------------------------------------\n"
  wttr -h
  wttr -v
else
  echo -e "\nThere were some problems while installing :("
  echo -e "Installation failed. Could either not copy to $target_dir or could not make it executable."
  echo -e "\nPlease copy the 'wttr' script by yourself to a location on your PATH variable"
  echo -e "and execute 'chmod +x wttr' to make t executable."
fi
