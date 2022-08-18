.PHONY: all publish

all:
	hugo

publish: all
	rsync -rh --progress --delete --stats public/ yavin:/srv/www/net.vladh.microblog
