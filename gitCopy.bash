#!/bin/bash
# Original source: https://dev.to/deckstar/how-to-git-copy-copying-files-while-keeping-git-history-1c9j

# HOW TO USE:
#
# PSEUDO-CODE TEMPLATE:
# `
# bash ./gitCopy.bash {fileToCopy} {...newFiles}
# `
#
# EXAMPLE:
# Lets say you have a file called Section.tsx. Your section has grown very big
# and you want to split it into into three subsection files, while preserving
# the git history. Your plan is to copy the section file into three new files, in
# a new subfolder called "subsections".
#
# In that case, you would do something like this:
#
# `
# bash ./gitCopy.bash ./components/Section.tsx ./components/subsections/Section1.tsx ./components/subsections/Section2.tsx ./components/subsections/Section3.tsx
# `

GRAY='\033[1;30m'
GREEN='\033[0;32m'
LIGHT_BLUE='\033[1;34m'
RED='\033[0;31m'
NO_COLOR='\033[0m'


fail_and_quit () {
    echo -e "\n${RED}Failed to git copy.${NO_COLOR}"
    exit 0
}

if [ ! \( -f "$1" -a $# -ge 2 \) ]; then
	echo -e "\n${RED}Invalid inputs${NO_COLOR}"

	cat 1>&2 <<-EOF
	Usage: \$0 ORIGINAL copy1 [... copyN]

	Copy ORIGINAL, preserving history for git blame
	New history will have N+3 commits

	EOF
	exit 1
fi

ORIGINAL="$1";

# shift to $2 and start counting arguments from 2
shift;

# Messages
echo -e "\nWill copy ${GRAY}${ORIGINAL}${NO_COLOR} into ${LIGHT_BLUE}+$# files${NO_COLOR}:"

args=("$@")
for i in "${!args[@]}"; do
   echo -e "    $i. ${GRAY}${args[$i]}${NO_COLOR}"
done

echo -e "New history will have ${GREEN}+$(($# + 3)) commits ${NO_COLOR}\n"
# /Messages

NEWLINE=$'\n'
KEEP=$(mkdir -p $(dirname $1) && mktemp ./"$1".XXXXXXXX);
MESSAGE="Copied (with git history):$NEWLINE$NEWLINE$ORIGINAL$NEWLINE$NEWLINE — into: —$NEWLINE$NEWLINE$@"
SPLIT=""

# Remember current commit
ROOT=$(git rev-parse HEAD)

# Check for errors
if [ -z "$ORIGINAL" ]; then
    echo -e "\n${RED}ERROR:${NO_COLOR} Did not get ORIGINAL variable."
    fail_and_quit
elif [ -z "$KEEP" ]; then
    echo -e "\n${RED}ERROR:${NO_COLOR} Did not get KEEP variable."
    fail_and_quit
elif [ -z "$MESSAGE" ]; then
    echo -e "\n${RED}ERROR:${NO_COLOR} Did not get MESSAGE variable."
    fail_and_quit
fi


# Create branch where $2 has $ORIGINAL's history
for f in "$@"; do
    git reset --soft $ROOT
    git checkout $ROOT "$ORIGINAL"
    git mv -f "$ORIGINAL" "$f"
    git commit -n -m "* (create $f)$NEWLINE$NEWLINE$MESSAGE"
    SPLIT="$(git rev-parse HEAD) $SPLIT"
done

# Go back to initial branch and move $ORIGINAL out of the way
git reset --hard HEAD^
git mv "$ORIGINAL" -f "$KEEP"
git commit -n -m "* (keep $ORIGINAL)$NEWLINE$NEWLINE$MESSAGE"

# Merge $2's branch back into the original
git merge $SPLIT -m "* (merge)$NEWLINE$NEWLINE$MESSAGE"
git commit -a -n -m "* (merge)$NEWLINE$NEWLINE$MESSAGE"

# Move $ORIGINAL back where it was
git mv "$KEEP" "$ORIGINAL"
git commit -n -m "$MESSAGE"


# Report
echo -e "\nNew history: ${GRAY}$(git rev-parse --short $ROOT)..$(git rev-parse --short HEAD)${NO_COLOR}"
echo -e "\n${GREEN}Success!${NO_COLOR}\n"
exit 0
