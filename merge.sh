#!/bin/sh

# git clone xxx

filename="branches.json"
discard="discard.json"
# src="maint"
src="master"
hasDelete=0
# version="version"
while read line; do
	git checkout "$line"
	git merge "$src"
	git reset --soft HEAD^
	while read delete; do
		find . -iname "$revert" -exec git reset {} && git checkout {} \;
		if [ $? -eq 0 ]; then
			 git add "$revert"
			 hasDelete=1
		fi
	done < "$discard"

	git commit -m "merge $src into $line"
	# if [ $hasDelete -eq 1 ]; then
		# # git commit --amend --no-edit
	# fi
	# git commit -m "merge $src into $line"

done < "$filename"
