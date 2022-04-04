# Overview

Prepend a prefix to comments of commits, and push it.  
There is [push trigger pattern](#Push&#32;trigger&#32;pattern) and [others](#Others) as ways for using.
- [Action's format including inputs.](https://github.com/begyyal/act_revise_comments/blob/master/action.yml)

# How to use

## Push trigger pattern

The target commits are new commits added by the push.  
This pattern only require `prefix` of the input, and ignores `from/to`.  
`branch` and others are as options.

## Others

The target commits are differences between two branches.  
The branches can be set by params `branch/from/to`.

### Example

|input key|value|
|:---|:---|
|prefix|`#1`|
|branch|`feature/1`|
|from|`develop`|
|to|default value (`feature/1`)|


```
7b88082 (HEAD -> feature/1, origin/feature/1) test2  
43f3ab2 test1  
a3d2669 (origin/develop, origin/HEAD, develop) test3  
```

&nbsp;&nbsp;↓&nbsp;↓&nbsp;↓  

```
7f82129 (HEAD -> feature/1, origin/feature/1) #1 test2  
a432557 #1 test1  
a3d2669 (origin/develop, origin/HEAD, develop) test3
```



# Supplement

## Behavier

- Revised commits take over original author, but the committer does not.
- If execution to the same target is duplicated, comments that is prepended the prefix is skipped processing.

## Attention

- This action replaces a original commit with a new commit,  
  so duplicate commits, such as when pulling a processed branch to a not processed one.
