# 概要

GithubAction。  
対象のリポジトリ/featureブランチが持つ固有のコミット全てに対して頭にIssueNoを付与する。  

# 前提

- 本リポジトリをサブモジュールとして追加してプライベートAction化する
- featureブランチの命名規則は [prefix]/[issue_no] で運用する
