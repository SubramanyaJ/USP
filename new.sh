#!/bin/bash

# 1. Get the required operation
exec 3>&1
CHOICE=`dialog --erase-on-exit --backtitle "File Encryption/Decryption program" \
	--title "Choose an option" \
	--default-item Encrypt "$@" \
	--menu "" 19 50 6 \
	Encrypt	        "" \
	Decrypt		"" \
	About		"" \
	Exit		"" \
2>&1 1>&3`
returncode=$?
exec 3>&-
#echo $CHOICE

# 2. Transfer control, if-else block
if [ "$CHOICE" == "Exit" ]; then
  exit 0
else
  if [ "$CHOICE" == "Encrypt" ]; then
    echo 1
  elif [ "$CHOICE" == "Decrypt" ]; then
    echo 2
  elif [ "$CHOICE" == "About" ]; then
    echo 3
  fi
fi




# 2. Get the required file
FILE=$(dialog --erase-on-exit --stdout --title "Choose a file" --fselect $HOME/ 14 48)
#-- The file chosen is $FILE
#echo $FILE


