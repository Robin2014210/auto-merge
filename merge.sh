#!/bin/sh

# git clone xxx

filename="branches.json"
discard="discard.json"
# src="maint"
src="master"
# hasDelete=0
# version="version"
hasFind=0
while read line; do
	# git checkout "$src"
	git checkout "$line"
	git merge "$src"
	# git reset --soft HEAD^
	if [ $? -eq 0 ]; then
		continue;
	fi
	conflicts=$(git diff --name-only --diff-filter=U --relative)

	hasFind=0;
	for conflict in $conflicts; do
		while read revert; do
			if [ "$revert" = "$conflict" ]; then
			hasFind=1
			break;
			fi
			
			# find . -iname "$revert" -exec git reset {} && git checkout {} \;
			# if [ $? -eq 0 ]; then
				# git add "$revert"
				# hasDelete=1
			# fi
		done < "$discard"

		if [ $hasFind -eq 1 ]; then
			git reset $conflict
			git checkout $conflict
		else
			echo "conflict with $conflict is not expected!!!"
			exit 1
		fi

	done
	git -c core.editor=/bin/true merge --continue
	# git commit -m "merge $src into $line"
	# if [ $hasDelete -eq 1 ]; then
	# # git commit --amend --no-edit
	# fi
	# git commit -m "merge $src into $line"

done < "$filename"
