#!/bin/bash

tmp_dir='/tmp/'$(date +%Y%m%d%H%M%S)
mkdir -p $tmp_dir
tmp=${tmp_dir}'/act_'

prefix="$1"
target=$2
token=$3
repos=$4
from=$5
to=${6:-$target}

user_name=$7
user_mail=$8
[ -z "$9" ] && cushion=' ' || cushion=''

if [ -z "$prefix" ]; then
  echo 'Required argument lacks.'
  exit 1
fi

function end(){
  cd ../
  rm -rdf ./${repos#*/}
  rm -f ${tmp}*
  exit $1
}

git config --global user.email $user_mail
git config --global user.name $user_name

token64=$(printf "%s""x-access-token:$token" | base64)
origin=${GITHUB_SERVER_URL:-${GITHUB_URL:-https://github.com}}
git config --global http.${origin}/.extraheader "AUTHORIZATION: basic $token64"

git clone ${origin}/${repos}.git
[ $? != 0 ] && end 1 || :
cd ./${repos#*/}

if [ "$GITHUB_EVENT_NAME" = "push" ]; then
  target=${target:-$GITHUB_REF_NAME}
elif [ "$GITHUB_EVENT_NAME" = "pull_request" ]; then
  target=${target:-$GITHUB_HEAD_REF}
fi

git fetch --all
git checkout $target

if [ "$GITHUB_EVENT_NAME" = "push" ]; then
  /shjp "$GITHUB_EVENT_PATH" -t commits | 
  /shjp -t id
else
  git log origin/${from}..origin/${to} --pretty=oneline |
  cut -d " " -f 1 |
  tac
fi > ${tmp}target_commits
[ $? != 0 ] && end 1 || :

first_commit=$(cat ${tmp}target_commits | head -n 1)
if [ -z "$first_commit" ]; then
  echo 'The target commits of the processing dont exist.'
  end 0
fi

target_nr=$(git log --pretty=oneline | awk '{if($1=="'$first_commit'"){print NR}}')
if [ -z "$target_nr" ]; then
  echo 'The target commits of the processing dont exist in the target branch.'
  end 0
fi

parent=$(git log --pretty=oneline |
cut -d " " -f 1 |
head -n $(($target_nr+1)) | 
tac |
tee ${tmp}targets_of_revision |
head -n 1)

head_ref="./.git/refs/heads/$target"
started=''

cat ${tmp}targets_of_revision |
sed '1d' |
while read commit_hash; do

  props=$(git cat-file -p $commit_hash | awk '{if($0==""){flag=1}else if(flag!=1){print $0}}')
  tree=$(echo "$props" | grep ^tree | cut -d " " -f 2)
  author=$(echo "$props" | grep ^author | cut -d " " -f 2-)

  comments=$(git cat-file -p $commit_hash | awk '{if(flag==1){print $0}else if($0==""){flag=1}}')
  if [ -z $started ]; then
    started=$(echo "$comments" | awk '{if(NR==1 && $0 !~ /^('$prefix').*$/){print "1"}}')
    [ -z $started ] && continue || :
  fi

  target_flag=$(cat ${tmp}target_commits | grep ^$commit_hash)
  if [ -n $target_flag ]; then
    comments=$(echo "$comments" | 
    awk -v prefix="${prefix}${cushion}" '{if(NR==1 && $0 !~ /^('$prefix').*$/){print prefix $0}else{print}}')
  fi

  git commit-tree $tree -p $parent -m "$comments" > $head_ref
  git reset --hard HEAD
  git commit --amend --author="$author" -C HEAD --allow-empty
  parent=$(cat $head_ref)
done

if [ $? != 0 ]; then
  echo 'Error occurred.'
  end 1
fi

git push origin HEAD -f

end 0
