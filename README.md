# Overview

This is a Github Action.  
Prepend a prefix to all comments of unique commits in the branch, and push it.  

## Premise

- [Action's format including inputs.](https://github.com/begyyal/act_revise_comments/blob/master/action.yml)

## Behavier

- Revised commits take over original author, but the committer does not.
- If execution to the same target is duplicated, comments that is prepended the prefix is skipped processing.

## Attention

- This action replaces a original commit with a new commit,  
  so duplicate commits, such as when pulling a processed branch to a not processed one.

## Example

prefix -> #1  
branch -> feature/1  
from -> develop  

```
7b88082 (HEAD -> feature/1, origin/feature/1) test2  
43f3ab2 test1  
a3d2669 (origin/develop, origin/HEAD, develop) test3  
```

&nbsp;&nbsp;↓&nbsp;↓&nbsp;↓  

```
7b88082 (HEAD -> feature/1, origin/feature/1) #1 test2  
43f3ab2 #1 test1  
a3d2669 (origin/develop, origin/HEAD, develop) test3
```
