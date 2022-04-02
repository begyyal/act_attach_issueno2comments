#!/bin/bash

tag_name=$1
url="https://github.com/marketplace/actions/give-a-prefix-to-comments"

LF=$'\\n'
text="act_revise_comments updated to ${tag_name}${LF}${url}${LF}"

echo -n "{\"text\":\"${text}\"}"