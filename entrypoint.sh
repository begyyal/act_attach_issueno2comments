#!/bin/bash

token=$1
repos=$2
issue_no=$3
from=${5:-develop}
to=${4:-feature}/$issue_no

if [ -z $token -o -z $repos -o -z $issue_no ]; then
  echo 'Required argument lacks.'
  exit 1
fi

git clone https://${token}@github.com/${repos}.git
cd ./${repos#*/}

git config --global user.email "you@example.com"
git config --global user.name "begyyal-ghost"

git fetch --all
git checkout $to

git log origin/${from}..${to} --oneline |
cut -d " " -f 1 |
tac > ../tmp_target_commits
first_commit=$(cat ../tmp_target_commits | head -n 1)

target_nr=$(git log --oneline | awk '{if($1=="'$first_commit'"){print NR}}')
parent=$(git log --oneline |
cut -d " " -f 1 |
head -n $(($target_nr+1)) | 
tac |
tee ../tmp_targets_of_revision |
head -n 1)

head_ref="./.git/refs/heads/$to"
cat ../tmp_targets_of_revision |
sed '1d' |
while read commit_hash; do

  props=$(git cat-file -p $commit_hash | 
  awk '{if($0==""){flag=1}else if(flag!=1){print $0}}')
  tree=$(echo "$props" | grep ^tree | cut -d " " -f 2)
  author=$(echo "$props" | grep ^author | cut -d " " -f 2-)

  target_flag=$(cat ../tmp_target_commits | grep ^$commit_hash)
  comments=$(git cat-file -p $commit_hash | 
  awk '{if(flag==1){print $0}else if($0==""){flag=1}}' |
  awk '{if(NR==1 && "'$target_flag'"!=""){print "#'$issue_no' " $0}else{print}}')

  git commit-tree $tree -p $parent -m "$comments" > $head_ref
  git commit --amend --author="$author" -C HEAD
  parent=$(cat $head_ref)
done

git push origin HEAD -f

rm -f ../tmp_*
exit 0
