# AWS infrastructure as code by terraform<br>
本スクリプトを実行するだけで AWS の インフラが構築出来ます。<br>

![aws_infla_terraform](https://user-images.githubusercontent.com/62212253/89980068-113e4280-dcac-11ea-874f-845f0cef54e7.png)<br>

# terraform install

1. 下記URL より terraform.exe をダウンロード<br>
    https://www.terraform.io/downloads.html<br>

2. terraform.exe を適当な場所へ配置してパスを通す<br>
    https://qiita.com/miwato/items/b7e66cb087666c3f9583<br>
    https://dev.classmethod.jp/articles/try-terraform-on-windows/<br>
    https://proengineer.internous.co.jp/content/columnfeature/5205<br>

# provider.tf<br>
| key name |  sample | 説明 |
| -------- | -------- | ---- |
| bucket | "aws-aqua-terraform" | terraform 状態を保持するファイルの格納先 |
| key    | "koizumi/develop_1.tfstate" | 上記のファイル名 |
| region | "eu-west-1" | リージョン名 |
| shared_credentials_file | "~/.aws/credentials" | credentials 情報を保持させるファイル名（※1） |
| profile | "koizumi" | 上記の profile 名 |
| required_version | "= 0.12.28" | 変更不可（バージョン差異により失敗する可能性あり） |

※1 ファイル内に記載する書式は以下<br>
[koizumi]<br>
aws_access_key_id = "xxxxxxxxxxxxxxxxxxxx"<br>
aws_secret_access_key = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"<br>

# terraform.tfvars<br>
各変数に適当な値をセットする。<br>
特に以下の項目は必須。<br>

| key name | sample | 説明 |
| ------- | -------- | ------- |
| aws_region | "eu-west-1" | リージョン名 |
| rds_az     | ["eu-west-1a", "eu-west-1b", "eu-west-1c"] | 存在するアベイラビリティゾーン |
| vpc_cidr   | "10.100.0.0/16" | VPC に使用する private ip address |
| allow_ip   | ["xxx.xxx.xxx.xxx/32", "xxx.xxx.xxx.xxx/32"] | EC2 にアクセス可能な ip address を指定|
| tags_owner | "koizumi" | Owner タグの名前 |
| public_key_path | "C:\\Users\\atsus\\.ssh\\aws_work.ppk.pub" | 公開鍵のパス（※2） |

※2 ローカルで公開鍵、秘密鍵を生成してください。<br>
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"<br>

# 使用方法

1. cd C:\xxx\xxx\xxx<br>
    cmd や powershell を起動して、.tf ファイル一式の配置先に移動<br>

2. terraform init<br>
    AWS 用モジュールの取得、xxx.tfstate ファイルの場所（S3）を読み込む<br>

3. terraform plan<br>
    実行計画を確認

4. terraform apply<br>
    リソースの作成開始

5. terraform refresh<br>
    最新の状態を取得（xxx.tfstate を更新）

6. terraform destroy<br>
    リソースの削除

