#!/bin/bash
# Import or export data?
while true; do
	read -p "Did you want to export or import data? [import/export] " ie
	case $ie in
		import|i* ) command="mongorestore"; state="restore"; break;;
		export|e* ) command="mongodump"; state="dump"; break;;
		* ) echo "Please answer 'import' or 'export'.";;
	esac
done

# Which db?
read -e -p "Which database do you want to $state? [ENTER]: " db
command+=" --db $db";

# Only when restoring
if [ $state == "restore" ]
then
	# Overwrite data?
	while true; do
		read -p "Do you want to overwrite the current data? [y/n] " overwrite
		case $overwrite in
			[Yy]* ) command+=" --drop"; break;;
			[Nn]* ) break;;
			* ) echo "Please answer 'y' or 'n'.";;
		esac
	done
fi

# Only when restoring
if [ $state == "restore" ]
then
	# Set question string
	q="Enter path where import files can be found. [ENTER] "
else
	# Set question string
	q="Enter (optional) path where to export the files. Otherwise current working directory will be used. [ENTER] "
fi

# Read path
read -e -p "$q" path

# When path is defined and state is restore
# Concat path
if [[ $path != "" && $state == "restore" ]]
then
	command+=" $path";
# When path is defined and state is export
# Set parameter and concat path
elif [[ $path != "" && $state == "dump" ]]
then
	command+=" --out $path";
fi

# Execute command
eval $command;
