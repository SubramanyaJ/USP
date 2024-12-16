#!/bin/bash

# 0. Functions section
getpassword(){
  tempfile=`(mktemp) 2>/dev/null` || tempfile=/tmp/test$$
  trap "rm -f $tempfile" 0 $SIG_NONE $SIG_HUP $SIG_INT $SIG_QUIT $SIG_TERM

  dialog --erase-on-exit --title "INPUT BOX" --clear \
    --insecure "$@" \
    --passwordbox "Enter your password for this operation : " 16 51 2> $tempfile

  PASS=$(cat $tempfile)
}

encrypt(){
  openssl aes-256-cbc -salt -a -e -in $FILE -out $FILE.enc -iter 2048 -k $PASS
}

decrypt(){
  openssl aes-256-cbc -salt -a -d -in $FILE -iter 2048 -k $PASS >> "$FILE".dec
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
  dialog --title "About" --erase-on-exit --clear --"$@" \
        --msgbox "Team :\n1. Sarthaka Mitra GB\n2. Shaik Uzair Ahmed\n3. Shashank U\n4. Subramanya J\n" 10 41
  exit 0

else

  # 3. Get the required file
  FILE=$(dialog --erase-on-exit --stdout --title "Choose a file" --fselect ./ 14 48)
  #-- The file chosen is $FILE
  #echo $FILE

  getpassword

  if [ "$CHOICE" == "Encrypt" ]; then
    encrypt
  elif [ "$CHOICE" == "Decrypt" ]; then
    decrypt
  fi
fi

