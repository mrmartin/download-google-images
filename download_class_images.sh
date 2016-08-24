while read query; do 
	wget --user-agent Mozilla "https://www.google.com/search?safe=off&site=&tbm=isch&source=hp&biw=1920&bih=1080&q=${query}&oq=${query}" -O raw_google_search_${query}
	cat raw_google_search_${query} | sed "s/href=/\nhref=/g" | sed "s/href=\"\/url?q=\(.*\)&amp;.*<br>\([0-9].*\) &times; \([0-9].*\) &#8211; [0-9]*.*/martinisgreat\1, \2, \3/g" | grep martinisgreat | sed 's/martinisgreat//g' > page_urls_${query}

	for i in {20..380..20}; do 
		echo $i
		wget --user-agent Mozilla "https://www.google.com/search?safe=off&site=&tbm=isch&source=hp&biw=1920&bih=1080&q=${query}&oq=${query}&start=${i}" -O raw_google_search_${query}

		cat raw_google_search_${query} | sed "s/href=/\nhref=/g" | sed "s/href=\"\/url?q=\(.*\)&amp;.*<br>\([0-9].*\) &times; \([0-9].*\) &#8211; [0-9]*.*/martinisgreat\1, \2, \3/g" | grep martinisgreat | sed 's/martinisgreat//g' >> page_urls_${query}

		sleep 0.2
	done
	sed -i 's/\(+*\)&.*, \([0-9]*\), \([0-9]*\)/\1, \2, \3/g' page_urls_${query}
	echo prepared `wc -l page_urls_airport+terminal` pages for ${query} from google image search

	mkdir ${query}_images

	#echo "http://commons.wikimedia.org/wiki/File:Narita_International_Airport,_Terminal_1,_Departure_Hall_10.JPG" > tmp
	while read url; do
		rm -rf tmp_folder
		mkdir tmp_folder
		
		cd tmp_folder
		pwd
		wget --user-agent Mozilla -T 2 -t 3 -E -H -k -K -p `echo ${url} | sed 's/, .*//g'`

		rm -rf martinisgreat_images
		mkdir martinisgreat_images
		mv `find . -type f | grep -i "\.png$\|\.jpg$\|\.gif$\|\.jpeg$\|\.tiff$\|\.tif$"` martinisgreat_images
		cd ..
		rm -rf martinisgreat_images
		mv tmp_folder/martinisgreat_images .
		#rm -rf tmp_folder

		identify -format "%f %wx%h\n" martinisgreat_images/* > info
		sed 's/.* \([0-9]*\)x\([0-9]*\) .*/\1, \2/g' info > received_sizes
		grep `echo $url | sed "s/.*, \([0-9]*\), \([0-9]*\)/ \1x\2 /g"` info > match
		echo "matched `wc -l match` images by size"
		while read image; do
			cp martinisgreat_images/`echo ${match} | sed "s/ .*//g"` ${query}_images
		done < match
		cp martinisgreat_images/* all_images
	done < page_urls_${query}
	
done < class