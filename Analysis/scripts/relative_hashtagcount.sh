#!/bin/sh
cp /SkyDrive/svn/Twitter/dist/twitter-hashtag.jar /home/hduser/
rm ~/part*
hdfs dfs -rm /input/*
hdfs dfs -copyFromLocal /SkyDrive/svn/Twitter/input/dataPull_clean/* /input
hadoop jar twitter-hashtag.jar relative_hashtagcount.RelativeHashTagCountDriver 1
hdfs dfs -rm /input/*
hdfs dfs -cp /output/part* /input
hadoop jar twitter-hashtag.jar sortbyvalue.SortDriver 1
hdfs dfs -copyToLocal /output/part* ~/
mv ~/part* ~/relative_hashtagcount.txt
cp ~/relative_hashtagcount.txt /SkyDrive/svn/Twitter/output
