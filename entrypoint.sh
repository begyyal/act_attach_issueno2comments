#!/bin/bash

tmp_dir='/tmp/'$(date +%Y%m%d%H%M%S)
mkdir -p $tmp_dir
tmp=${tmp_dir}'/act_'

issue_no=$1
to=${2:-feature/$issue_no}
token=$3
repos=$4
from=$5

user_name=$6
user_mail=$7

if [ -z $token -o -z $repos -o -z $issue_no ]; then
  echo 'Required argument lacks.'
  exit 1
fi

origin=${GITHUB_SERVER_URL:-${GITHUB_URL:-https://github.com}}
git clone ${origin}/${repos}.git
cd ./${repos#*/}

git config --local user.email $user_mail
git config --local user.name $user_name

token64=$(printf "%s""x-access-token:$token" | base64)
git config --local http.${origin}/.extraheader "AUTHORIZATION: basic $token64"

git fetch --all
git checkout $to

git log origin/${from}..${to} --oneline |
cut -d " " -f 1 |
tac > ${tmp}target_commits
first_commit=$(cat ${tmp}target_commits | head -n 1)

target_nr=$(git log --oneline | awk '{if($1=="'$first_commit'"){print NR}}')
parent=$(git log --oneline |
cut -d " " -f 1 |
head -n $(($target_nr+1)) | 
tac |
tee ${tmp}targets_of_revision |
head -n 1)

head_ref="./.git/refs/heads/$to"
attachment='#'$issue_no
started=''

cat ${tmp}targets_of_revision |
sed '1d' |
while read commit_hash; do

  props=$(git cat-file -p $commit_hash | 
  awk '{if($0==""){flag=1}else if(flag!=1){print $0}}')
  tree=$(echo "$props" | grep ^tree | cut -d " " -f 2)
  author=$(echo "$props" | grep ^author | cut -d " " -f 2-)

  comments=$(git cat-file -p $commit_hash | awk '{if(flag==1){print $0}else if($0==""){flag=1}}')
  if [ -z $started ]; then
    started=$(echo "$comments" | awk '{if(NR==1 && $0 !~ /^('$attachment').*$/){print "1"}}')
    [ -z $started ] && continue
  fi

  target_flag=$(cat ${tmp}target_commits | grep ^$commit_hash)
  if [ -n $target_flag ]; then
    comments=$(echo "$comments" | 
    awk '{if(NR==1 && $0 !~ /^('$attachment').*$/){print "'$attachment' " $0}else{print}}')
  fi

  git commit-tree $tree -p $parent -m "$comments" > $head_ref
  git commit --amend --author="$author" -C HEAD --allow-empty
  parent=$(cat $head_ref)
done

git push origin HEAD -f

cd ../
rm -rdf ./${repos#*/}
rm -f ${tmp}*
exit 0
