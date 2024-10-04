## ログの収集
### AWS CloudTrail

![CloudTrail to S3](images/cloudtrail-to-s3.jpg)

* 管理イベント
* データイベント

### AWS Config

![Config to S3](images/log-source-config-to-s3.svg)

* Configuration 履歴
* Configuration スナップショット

### Amazon VPC Flow Logs

![VPC flog logs to S3](images/vpc-to-s3.jpg)

### Elastic Load Balancing (ELB)

![elb to S3](images/elb-to-s3.jpg)


### EC2 インスタンス (Amazon Linux 2/2023)

![Amazon Linux 2 to S3](images/al2-to-s3.jpg)

* OS のシステムログ
  * s3_key の初期値: `/[Ll]inux/` (Firehose の出力パスに指定)
* Secure ログ
  * s3_key の初期値: `[Ll]inux.?[Ss]ecure` (Firehose の出力パスに指定)

### RDS (Aurora MySQL互換 / MySQL / MariaDB)

![MySQL to S3](images/mysql-to-s3.jpg)

* 監査ログ (Audit log)
* エラーログ (Error log)
* 一般ログ (General log)
* スロークエリログ (Slow query log)


## 準備
以下のコマンドを実行してS3バケットを作成しておく。

```
account_id=$(aws sts get-caller-identity --query Account --output text)
aws s3api create-bucket \
    --bucket "terraform-state-${account_id}" \
    --region ap-northeast-1 \
    --create-bucket-configuration LocationConstraint=ap-northeast-1
```
