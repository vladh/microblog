.PHONY: all publish

all:
	hugo -D

publish: all
	rsync -rh --progress --delete --stats public/ yavin:/srv/www/net.vladh.microblog
