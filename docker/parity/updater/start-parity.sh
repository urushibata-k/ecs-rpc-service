#!/bin/bash -x

mkdir -p /root/.local
aws s3 sync --delete --region $region s3://$bucket/$s3key/v2.5.10/ /root/.local/
if [ $? -ne 0 ]
then
	echo "aws s3 sync command failed; exiting."
	exit 1
fi
/bin/parity $* &
sleep 10800
pid=`ps -ef |grep bin/parity|grep -v grep|awk '{print $2}'`
kill $pid
sleep 30
aws s3 sync --delete --region $region /root/.local/ s3://$bucket/$s3key/v2.5.10/
