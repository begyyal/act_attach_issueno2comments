# Overview

This is a Github Action.  
Prepend a prefix to all comments of unique commits in the branch.  

## Premise

- [Action's format including inputs.](https://github.com/begyyal/act_revise_comments/blob/master/action.yml)

## Attention

- Revised commits take over original author, but the committer does not.
- This action replaces a original commit with a new commit,  
  so duplicate commits, such as when pulling a processed branch to a not processed one.

## Example

prefix -> #1

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
