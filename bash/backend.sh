#!/usr/bin/bash

#######use . scriptName.sh instead of ./scriptName.sh

microservice_dir='D:\microservices'


1. Repository Dirctory
echo "########################################################"
cd "$microservice_dir" || return

index=1

for file in *; do
	if [ -d "$file" ]; then
		echo "$index: $file"
		((index++))
	fi
done

echo "########################################################"
echo -n "command: " 
read cmd

case $cmd in
	1) 
		index=1
		for file in *; do
			if [ -d "$file" ]; then
				if [ $index -eq $cmd ]; then
					cd "$file" || return
				fi
				((index++))
			fi
		done
		;;
		*)
        echo "Invalid choice. Exiting."
        exit 1
        ;;
esac

pwd