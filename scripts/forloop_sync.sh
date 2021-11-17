for x in {1..3} 
do 
	rsync -aAHXv /mnt/b$x /mnt/c$x
done
