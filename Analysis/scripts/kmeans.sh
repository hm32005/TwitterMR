#!/bin/sh

# create results folder
rslt="/home/hduser/results"
hd_home="/home/hduser"

echo "Creating results dir @" "$rslt"
mkdir $rslt

# copy jar to holding area + move to hdfs
cp "/home/raja/Education/sem 2/DIC/projects/prj2/sampleA.jar" $hd_home
echo "copying jar file to" "$hd_home"

for k in 3 4 5 6
do
	# run the jar for different values of k
	
	hadoop jar sampleA.jar kmeans.MasterControlUnit $k

	# copy reducer output to results
	hdfs dfs -copyToLocal /output/part* $rslt
	hdfs dfs -copyToLocal /conf/centroids $rslt

	#copy output to local folder
	echo "moving to the results folders"
	cd "$rslt"
	echo $PWD
	mkdir "$k"
	mv part* "$k"
	mv centroids "$k"

	# going back to hd_user	
	echo "moving to home hduser home" $hd_home
	cd "$hd_home"
	echo $PWD
done
