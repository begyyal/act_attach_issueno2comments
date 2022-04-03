# Overview

Prepend a prefix to comments of commits which are differences between two branches.  
And push it to a target.  
The branches can be set by params `branch/from/to` as below, and example is [here](#Example).
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

*`to` is set to `branch`(`feature/1`) as default value.

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
