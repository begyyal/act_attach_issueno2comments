# Overview

This is a Github Action.  
Prepend IssueNo to all comments of unique commit in the feature branch.  

## Premise

- [Action's format including inputs.](https://github.com/begyyal/act_revise_comments/blob/master/action.yml)
- The naming convention for the feature branch is [prefix]/[issue_no].
- Revised commits take over original author, but the committer does not.

## Example

issueNo:1

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
