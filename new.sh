#!/bin/bash

# 0. Functions section
getpassword(){
  tempfile=`(mktemp) 2>/dev/null` || tempfile=/tmp/test$$
  trap "rm -f $tempfile" 0 $SIG_NONE $SIG_HUP $SIG_INT $SIG_QUIT $SIG_TERM

  dialog --erase-on-exit --title "INPUT BOX" --clear \
    --insecure "$@" \
    --passwordbox "Enter your password for this operation : " 16 51 2> $tempfile

  PASS=$(cat $tempfile)
  echo $PASS
}

encrypt(){
#  openssl enc -aes-256-cbc -salt -in file.txt -out file.enc -k password
  getpassword
}

decrypt(){
  echo de
}

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

elif [ "$CHOICE" == "About" ]; then
  echo 1

else

  # 3. Get the required file
  FILE=$(dialog --erase-on-exit --stdout --title "Choose a file" --fselect $HOME/ 14 48)
  #-- The file chosen is $FILE
  #echo $FILE

  if [ "$CHOICE" == "Encrypt" ]; then
    encrypt
  elif [ "$CHOICE" == "Decrypt" ]; then
    decrypt
  fi
fi

