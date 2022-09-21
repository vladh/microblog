.PHONY: site-dev site-prod publish

site-dev:
	hugo -D

site-prod:
	hugo

publish: site-prod
	rsync -rh --progress --delete --stats public/ yavin:/srv/www/net.vladh.microblog
