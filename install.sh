#!/bin/bash

#引数の数をチェック
if [ $# -ne 1 ]; then
    echo "第1引数にアプリケーション名を入力してください" 1>&2
    exit 1
fi

#Docker環境を作成
docker-compose build
docker-compose up -d

#composerをインストール
cd data/htdocs
curl -s https://getcomposer.org/installer | php

#cakephp4をインストール
docker exec -it cakephp4-docker_phpfpm_1 sh -c "yes | php composer.phar create-project --prefer-dist cakephp/app=4.* $1"

#nginxのルートを設定
sed -i -e "s/APP_NAME/$1/g" ../nginx/conf/conf.d/default.conf

#再起動
docker-compose restart

#リポジトリのgitを削除
rm -rf ../../.git
cd $1
git init

exit 0
