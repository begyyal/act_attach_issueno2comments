# 概要

ワークフロー向けのシェルスクリプトのツール。  
対象のリポジトリ/featureブランチが持つ固有のコミットコメント全てに対して頭にIssueNoを付与する。  
  

## 前提

- featureブランチの命名規則は [prefix]/[issue_no] で運用する

## 引数

1. Gitアクセストークン (再帰する場合はpatを避けること)
2. リポジトリ名 ([owner]/[repository])
3. IssueNo
4. featureブランチのprefix (default:feature) 
5. featureブランチの親ブランチ (default:develop)

## 例

comment2 -> 'second commit'  
comment1 -> 'first commit'  

&nbsp;&nbsp;↓&nbsp;↓&nbsp;↓  
  
comment2 -> '**#1** second commit'  
comment1 -> '**#1** first commit'  
  
