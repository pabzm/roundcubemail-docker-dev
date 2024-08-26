#!/bin/bash -ex

if [[ -f /var/www/html/index.php ]]; then
	# Run the steps necessary to actually use the repository code.
	cd /var/www/html
	# This first command is also in the upstream entrypoint-script, but it needs to run before the PHP-scripts do, so we also need it here.
	composer --prefer-dist --no-dev --no-interaction --optimize-autoloader install
	# Download external Javascript dependencies.
	bin/install-jsdeps.sh
	# Translate elastic's styles to CSS.
	make css-elastic
	# Update cache-buster parameters in CSS-URLs.
	bin/updatecss.sh
fi

exec /docker-entrypoint.sh "$@"
