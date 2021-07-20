# 概要

GithubAction。  
対象のリポジトリ/featureブランチが持つ固有のコミットコメント全てに対して頭にIssueNoを付与する。  
  

## 前提

- featureブランチの命名規則は [prefix]/[issue_no] で運用する

## 例

comment2 -> 'second commit'  
comment1 -> 'first commit'  

&nbsp;&nbsp;↓&nbsp;↓&nbsp;↓  
  
comment2 -> '**#1** second commit'  
comment1 -> '**#1** first commit'  
  
