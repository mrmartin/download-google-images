cp /var/www/html/google_images .

#COUNTER=1;
#while read line; do 
#	mkdir `echo $line | sed 's/^.*oq=\(.*\):http.*/\1/g' | sed 's/+/_/g'`
#	echo $line | sed 's/^.*:http/http/g'	
#
#
#	wget --user-agent Mozilla "`echo $line | sed 's/^.*:http/http/g'`" -O `echo $line | sed 's/^.*oq=\(.*\):http.*/\1/g' | sed 's/+/_/g'`/$COUNTER
#	let "COUNTER=$COUNTER+1"
#done < google_images

#parallel:
sed 's/https:\/\/www.google.cz\/search?safe=off&site=&tbm=isch&source=hp&biw=1920&bih=1080&q=\(.*\)&.*:\(http.*$\)/wget --user-agent Mozilla "\2" -nd -P \1\/ /g' google_images | sed 's/\$/\\\$/g' > wget_commands.sh
chmod +x wget_commands.sh