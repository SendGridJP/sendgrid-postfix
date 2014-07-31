sendgrid-postfix
================

SMTPリクエストをSendGridにリレーするPostfixサーバです。  
ほぼデフォルト設定のPostfixに対してsmtp.sendgrid.netに接続する設定だけを加えたものです。  

## 必要条件
git
Docker 1.0

## ファイルの取得
リポジトリからファイルをクローンします。
``` bash
$ git clone https://github.com/SendGridJP/sendgrid-postfix.git
$ cd sendgrid-postfix
```

## 設定変更
### Postfixの設定変更
Postfixの設定ファイルを編集してSendGridの認証情報を設定します。
``` bash
vi files/etc/postfix/main.cf

# 編集箇所
smtp_sasl_password_maps = static:SENDGRID_USERNAME:SENDGRID_PASSWORD
```

### メールアドレス変更
メール送信テストスクリプトのFromとToを編集します。
``` bash
$ vi files/smtp.sh

# 編集箇所
to=recipient@address.com
from=your@address.com
```

## Docker build
Dockerをbuildします。
``` bash
$ ./build.sh
```

## Docker run
コンテナ上でsshdを起動します。  
ポート設定はDocker環境により異なる場合がありますので、適宜修正してください。  
同様の内容はrun.shファイルに記述されています。
``` bash
$ docker run -p 49201:22 -p 49202:25 -t sendgridjp/postfix /usr/sbin/sshd -D &
```

## コンテナにsshで接続
コンテナにsshで接続します。  
接続先IPアドレスやポート番号はDocker環境により異なる場合がありますので、適宜修正してください。  
sshのパスワードはDockerfileに記述されている通り"password"です。  
同様の内容はssh.shファイルに記述されています。  
``` bash
$ ssh root@192.168.59.103 -p 49201
root@192.168.59.103's password:
Last login: Fri Jul 25 21:00:34 2014 from 192.168.59.3
[ root@1aee76c662af:~ ]$
```

## コンテナ上でPostfix起動
コンテナ上でPostfixを起動します。  
``` bash
[ root@1aee76c662af:~ ]$ service postfix start
 * Starting Postfix Mail Transport Agent postfix                          [ OK ]
[ root@1aee76c662af:~ ]$
```

## メール送信のテスト
メール送信スクリプトを実行してテストします。  
最後から2行目にステータスコード250が表示されていれば、送信成功です。  
宛先メールボックスにメールが届いていることを確認してください。  
``` bash
[ root@1aee76c662af:~ ]$ ~/smtp.sh
220 95699cec7d3e ESMTP Postfix (Ubuntu)
250-95699cec7d3e
250-PIPELINING
250-SIZE 10240000
250-VRFY
250-ETRN
250-ENHANCEDSTATUSCODES
250-8BITMIME
250 DSN
250 2.1.0 Ok
250 2.1.5 Ok
354 End data with <CR><LF>.<CR><LF>
250 2.0.0 Ok: queued as 0C42921B
221 2.0.0 Bye
```

## 注意事項
PostfixはlocalhostからのSMTPリクエストのみ受け付けるようになっています。
外部ホストからSMTPリクエストを受け付けるようにするためには、Postfixの設定を変更してください。
