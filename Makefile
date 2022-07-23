.PHONY: all publish

all:
	hugo -D

publish: all
	scp -r public yavin:/srv/www/net.vladh.microblog
