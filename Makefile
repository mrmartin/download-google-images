data:
	echo "warning: this will take ~10 hours, and will be launching firefox in the foreground a lot"
	echo "get urls of original images from google image search"
	./get_images_urls.sh
	echo "download these images in parallel"
	./simple_match_downloader.sh
	echo "resize them to 227x227 while keeping aspect ratio and crop the middle 227x227 square, while renaming to keep the google image search order"
	./resize_downloaded_images.sh
	echo "remove animated gifs every frame except first"
	rm `find /media/martin/ssd-ext4/SUN_from_google/* -type f | grep "\-[0-9]" | grep -v "\-0\.jpg"`
	for line in `find /media/martin/ssd-ext4/SUN_from_google/* -type f | grep "\-[0-9]"`; do mv $line `echo $line | sed 's/\-0\.jpg$/\.jpg/g'`; done
	