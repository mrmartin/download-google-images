mkdir lists_of_errors
echo "moat+water" > tmp

while read tag; do
	#the character \ needs to be escaped with \\
	find ${tag} -type f | sed 's/\\/\\\\/g' > cur_images
	rm -f lists_of_errors/error_${tag}
	while read im; do
		identify "$im" &>/dev/null; echo "$? $im" >> lists_of_errors/error_${tag};
	done < cur_images
	grep "^1 " lists_of_errors/error_${tag} | sed 's/^1 /rm "/g' | sed 's/$/"/g' > to_delete
	chmod +x to_delete
	echo "in ${tag}, `wc -l to_delete` "
	./to_delete
done < class