cd /media/martin/MartinK3TB/Datasets/SUN397
find . -mindepth 2 -maxdepth 4 -type d > SUN_397_categories
grep -v SUN_6_scenes SUN_397_categories > tmp
rm counts
while read l; do find $l -maxdepth 1 | grep sun_ | wc -l >> counts; done < tmp
paste counts tmp | grep -v "^0" > SUN_397_categories

sed 's/\....//g' SUN_397_categories | sed 's/\t/,/g' > SUN_397_categories_pretty

sed 's/.*\t....//g' SUN_397_categories | sed 's/\/\|_/ /g' > SUN_397_categories_human

cd /media/martin/MartinK3TB/Experiments/download_google_images
cp /media/martin/MartinK3TB/Datasets/SUN397/SUN_397_categories_human .

sed 's/ /+/g' SUN_397_categories_human > class

while read tag; do
	echo "run for ${tag}"
	firefox --new-window "https://www.google.cz/search?safe=off&site=&tbm=isch&source=hp&biw=1920&bih=1080&q=${tag}&oq=${tag}"
	sleep $[ ( $RANDOM % 20 ) + 50 ]s
done < class