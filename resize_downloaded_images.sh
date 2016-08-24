echo "moat+water" > tmp

rawurldecode() { #from http://stackoverflow.com/questions/296536/urlencode-from-a-bash-script
  # This is perhaps a risky gambit, but since all escape characters must be
  # encoded, we can replace %NN with \xNN and pass the lot to printf -b, which
  # will decode hex for us

  printf -v REPLY '%b' "${1//%/\\x}" # You can either set a return variable (FASTER)

  echo "${REPLY}"  #+or echo the result (EASIER)... or both... :p
}

while read tag; do
	#the character \ needs to be escaped with \\
	#find ${tag} -type f | sed 's/\\/\\\\/g' > cur_images
	#in order to have cur_images sorted in the order of google image search, retrieve it from google_images
	grep "oq=${tag}:http" google_images | sed "s/.*\//${tag}\//g" | sed 's/%5C/\\/g' | sed 's/\\/\\\\/g' | sed 's/%20/ /g' > cur_images
	mkdir /media/martin/ssd-ext4/SUN_from_google/${tag}
	COUNTER=1;
	while read im; do
		echo "${tag}: $COUNTER: $im"
		convert "$im" -resize "227x227^" -gravity center -crop "227x227+0+0" /media/martin/ssd-ext4/SUN_from_google/${tag}/${COUNTER}.jpg
		if [ $? -eq 1 ]; then 
			echo "failed, trying $im with url: `rawurldecode "$im"`"
			convert "`rawurldecode "$im"`" -resize "227x227^" -gravity center -crop "227x227+0+0" /media/martin/ssd-ext4/SUN_from_google/${tag}/${COUNTER}.jpg
		fi
		if [ $? -eq 0 ]; then 
			let "COUNTER=$COUNTER+1"
		fi
	done < cur_images
	echo "done ${tag}"
done < class

