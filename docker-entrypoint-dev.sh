#!/bin/bash -ex

if [[ -f /var/www/html/index.php ]]; then
	# Run the steps necessary to actually use the repository code.
	cd /var/www/html
	# This first command is also in the upstream entrypoint-script, but it needs to run before the PHP-scripts do, so we also need it here.
	composer --prefer-dist --no-dev --no-interaction --optimize-autoloader install
	# Download external Javascript dependencies.
	bin/install-jsdeps.sh
	# Minify all JS files
	bin/jsshrink.sh
	# Translate elastic's styles to CSS.
	cd skins/elastic
	npx lessc --clean-css="--s1 --advanced" styles/styles.less > styles/styles.min.css
	npx lessc --clean-css="--s1 --advanced" styles/print.less > styles/print.min.css
	npx lessc --clean-css="--s1 --advanced" styles/embed.less > styles/embed.min.css
	cd -
	# Update cache-buster parameters in CSS-URLs.
	bin/updatecss.sh
	# Minify all CSS files.
	bin/cssshrink.sh
fi

exec /docker-entrypoint.sh "$@"
