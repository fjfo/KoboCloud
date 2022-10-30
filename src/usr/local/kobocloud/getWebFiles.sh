#!/bin/sh
baseURL="$1"
outDir="$2"

#load config
. $(dirname $0)/config.sh


path="$(echo $baseURL | grep / | cut -d/ -f4-)"
davServer=$(echo $1 | sed -e s,/$path,,g)

echo "baseURL: $baseURL"
echo "davServer: $davServer"

# get directory listing
pageContent=`$CURL -k -L --silent "$baseURL"`
#echo "no support array"
#IFS=';' read -ra array <<< "$pageContent"
#declare -a array=(`echo "$pageContent" |sed 's/;/ /g'`)
#array=`/bin/echo -e "$pageContent" | tr ';' '\n' `

prefix="./"

echo "$pageContent" |
while read item
do
    outFileName=${item#$prefix}; #Remove prefix    
    remotePath="$davServer/$outFileName"
    localFile="$outDir/$outFileName"  
    #echo "remote = $remotePath"
    #echo "local = $localFile"  
    $KC_HOME/getRemoteFile.sh "$remotePath" "$localFile"
    if [ $? -ne 0 ] ; then
        echo "Having problems contacting Web. Try again in a couple of minutes."
        exit
    fi
done  