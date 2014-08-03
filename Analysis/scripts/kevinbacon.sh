#!/bin/sh
cp /SkyDrive/svn/Twitter/dist/twitter-hashtag.jar /home/hduser/
rm ~/part*
hdfs dfs -rm /input/*
hdfs dfs -copyFromLocal /SkyDrive/svn/Twitter/input/dataPull_clean/* /input
hadoop jar twitter-hashtag.jar kevinbacon.WordCount 1 -Dlog4j.configuration=conf/log4j.properties
hdfs dfs -rm /input/*
hdfs dfs -cp /output/part* /input
hadoop jar twitter-hashtag.jar sortbyvalue.WordCount 1
hdfs dfs -copyToLocal /output/part* ~/
mv ~/part* ~/kevinbacon.txt
cp ~/kevinbacon.txt /SkyDrive/svn/Twitter/output
