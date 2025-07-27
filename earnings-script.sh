#! /bin/bash

# Variables
DIR=$( cd "$( dirname "earnings-script.sh" )" && pwd )


# Check if run as root
if [ "$EUID" -ne 0 ]
        then echo "Please run this script as root"
        exit
fi

# Set inputs
echo "What is the node's name?"
read node
echo "What is your node's database location? (example. /mnt/<nodename>/storage)"
read path

# Stop Storj node
echo "stopping $node"
docker stop $node

# Copy database files loop
for n in `cat db-files.txt`; do
        echo "copying $n"
        cp $path/$n $DIR
done
echo "copy complete"

# Restart Storj node
echo "restarting $node"
docker start $node

# Run earnings script off the copied files
python3 $DIR/earnings.py

# Remove database files
rm $DIR/*.db
