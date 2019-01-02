#!/bin/bash
DIALOG=${DIALOG=dialog}
SSHKEY=$1

function add {
echo "\$SSHKEY is" $SSHKEY
echo "What's your name?"
read name
echo "Adding you key to the database..."
#bash sqlite.sh $name 'olol mdr jpp'
sqlite3 db.sqlite <<EOF
INSERT INTO keys(pseudo,key) VALUES('$name','$SSHKEY');
select * from keys;
EOF

} 

function case-dialog {
case $choix in
'Add')		add;;
'Reset')	cp db.sqlite.clean db.sqlite;;
'Remove')	remove;;
'Edit')		exit;;
'List')		list;;
'About')	exit;;
esac
}

function remove {
echo removing your key
sqlite3 db.sqlite <<EOF
DELETE FROM keys WHERE key LIKE '$SSHKEY';
select * from keys;
EOF
}

function list {
sqlite3 db.sqlite <<EOF
select * from keys;
EOF
}

#$DIALOG --title "SKS - Key" --clear \
#	--yesno "Your key is here : check it the first time you connect.\n$1" 20 51
#
#case $? in
#	1)	exit 1;;
#	255)	exit 1;;
#esac

fichtemp=`tempfile 2>/dev/null` || fichtemp=/tmp/test$$
trap "rm -f $fichtemp" 0 1 2 5 15
$DIALOG --clear --title "SKS - Manage" \
	--menu "Hello, what do you want to do ?" 20 51 10 \
	 "Add" "Add your key to SKS" \
	 "Reset" "Reset the database" \
	 "Remove" "Remove your key" \
	 "List" "List keys" \
 	 "Edit" "Edit your key (name, contact)" \
	 "About" "What's SKS ?" 2> $fichtemp
valret=$?
choix=`cat $fichtemp`
echo $valret $choix
case $valret in
0)	case-dialog;;
1)	echo "Appuyé sur Annuler.";;
255)	echo "Appuyé sur Echap.";;
esac
