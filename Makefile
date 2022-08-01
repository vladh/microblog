.PHONY: all publish

all:
	hugo -D

publish: all
	rsync --progress -r --delete public/ yavin:/srv/www/net.vladh.microblog
