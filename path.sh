##!/bin/bash
##
## based on
## [this script](https://stackoverflow.com/questions/31797364/rudimentary-file-explorer-using-dialog-boxes-with-fselect-bash)
## by Anubis Lockward
#
#set -e          # stop on error
#set -u          # stop on undefined variable
#set -o pipefail # stop part of pipeline failing
#
#function fileChooser(){
#  dialog --clear \
#         --title "Please select file with space" \
#         --stdout --fselect "" 14 58
#}
#
#RESULT="$( fileChooser )"
#
#while [ -d "$RESULT" ]
#do
#  cd "$RESULT"
#  RESULT="$( fileChooser )"
#done
#
# Print selection
#realpath "$RESULT"

#!/bin/bash

HEIGHT=10
WIDTH=40
CHOICE_HEIGHT=4
BACKTITLE="Cluster Options"
TITLE="File Encryption/Decrption"
MENU="Options : "

ENV="${ENV:-dev}"

if [ $ENV == "dev" ]; then
    OPTIONS=(1 "Encrypt"
             2 "Decrypt"
             3 "Exit")
#elif [ $ENV == "mode" ]; then
#    OPTIONS=(1 "MODE Option 1"
#             2 "MODE Option 2")
#elif [ $ENV == "prod" ]; then
#    OPTIONS=(1 "PROD Option 1"
#             2 "PROD Option 2")
fi
CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

clear
echo $CHOICE
