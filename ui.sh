#!/bin/bash
DIALOG=${DIALOG=dialog}
SSHKEY=$1
function case-dialog {
case $choix in
'Add')          add;;
'Reset')        cp db.sqlite.clean db.sqlite && start_menu;; # yeah this won't be available for everyone
'Remove')       confirm-remove;;
'List')         list;;
'Get')          get;;
'Edit')         exit;;
'About')        exit;;
'Exit')		clear; exit;;
esac
}

function add {
echo "\$SSHKEY is" $SSHKEY
existantkey=$(sqlite3 db.sqlite "SELECT * FROM keys WHERE key=='$SSHKEY';")

if [[ $existantkey != "" ]]; then
dialog --title "SKS - Add your key" --msgbox "Your key is already in the database." 5 40
else
name=$(dialog --title "SKS - Add your key" --inputbox "What is your name?" 8 40 3>&1 1>&2 2>&3 3>&-)
echo $name
echo "Adding you key to the database..."
sqlite3 db.sqlite <<EOF
INSERT INTO keys(pseudo,key) VALUES('$name','$SSHKEY');
EOF
fi
start_menu
} 

function confirm-remove {
existantkey=$(sqlite3 db.sqlite "SELECT * FROM keys WHERE key=='$SSHKEY';")

if [[ $existantkey == "" ]]; then
dialog --title "SKS - Add your key" --msgbox "Your key is not in the database." 5 40
start_menu
else
dialog --backtitle "SKS - Remove your key" --yesno "Are you sure you want to delete your key from the database?" 7 60
case $? in
   0) remove;;
   1) start_menu;;
   255) start_menu;;
esac
fi
}

function remove {
sqlite3 db.sqlite <<EOF
DELETE FROM keys WHERE key=='$SSHKEY';
select * from keys;
EOF
dialog --title "SKS - Remove your key" --msgbox "Your key has been removed from the database." 6 40
start_menu
}

function list {
keys=$(sqlite3 db.sqlite "select * from keys;")
dialog --title "SKS - List keys" --msgbox "$keys" 20 90
start_menu
}

function get {
echo "Whose key do you want?"
name=$(dialog --title "SKS - Get specific user's keys" --inputbox "Whose key do you want??" 8 40 3>&1 1>&2 2>&3 3>&-)
keys=$(sqlite3 db.sqlite "SELECT * FROM keys WHERE pseudo LIKE '$name';")
dialog --title "SKS - Get specific user's keys" --msgbox "$keys" 20 90
start_menu
}

#$DIALOG --title "SKS - Key" --clear \
#	--yesno "Your key is here : check it the first time you connect.\n$1" 20 51
#
#case $? in
#	1)	exit 1;;
#	255)	exit 1;;
#esac

function start_menu {
fichtemp=`tempfile 2>/dev/null` || fichtemp=/tmp/test$$
trap "rm -f $fichtemp" 0 1 2 5 15
$DIALOG --clear --title "SKS - Manage" \
	--menu "Hello, what do you want to do ?" 20 51 10 \
	 "Add" "Add your key to SKS" \
	 "Reset" "Reset the database" \
	 "Remove" "Remove your key" \
	 "List" "List keys" \
 	 "Get" "Get specific user's key(s)" \
	 "Edit" "Edit your key (name, contact)" \
	 "About" "What's SKS ?" \
	 "Exit" "Exit SKS" 2> $fichtemp
valret=$?
choix=`cat $fichtemp`
echo $valret $choix
case $valret in
0)	case-dialog;;
1)	echo "Appuyé sur Annuler.";;
255)	echo "Appuyé sur Echap.";;
esac
}

start_menu
