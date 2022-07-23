.PHONY: all publish

all:
	hugo -D

publish: all
	rsync -r --delete public/ yavin:/srv/www/net.vladh.microblog
