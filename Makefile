# Makefile for Sphinx documentation
#

# You can set these variables from the command line.
SPHINXOPTS    =
SPHINXBUILD   = sphinx-build
PAPER         =
BUILDDIR      = build

# Internal variables.
PAPEROPT_a4     = -D latex_paper_size=a4
PAPEROPT_letter = -D latex_paper_size=letter
ALLSPHINXOPTS   = -d $(BUILDDIR)/doctrees $(PAPEROPT_$(PAPER)) $(SPHINXOPTS)

.PHONY: help clean static publish publish-test html rst

help:
	@echo "Please use \`make <target>' where <target> is one of"
	@echo "  static       build static files"
	@echo "  publish      copy static files to server"

clean:
	rm -rf $(BUILDDIR)/
	for release in latest; do \
		for software in aceflow acemd acemd3 acemd3newdoc htmd moleculekit parameterize; do \
			find $$release/source/$$software -mindepth 1 ! -name ".gitignore" -delete; \
		done \
	done

publish:
	scp -r $(BUILDDIR)/latest/html/* software.acellera.com:/var/www/software/docs/latest
	scp -r $(BUILDDIR)/static/*  software.acellera.com:/var/www/software/
	#ssh software.acellera.com 'chgrp -R www-htmd /var/www/software/; chmod -R g+rwX /var/www/software/'

publish-test:
	ssh software.acellera.com 'mkdir -p /var/www/software/test'
	scp -r $(BUILDDIR)/latest/html/* software.acellera.com:/var/www/software/test/docs/latest
	scp -r $(BUILDDIR)/static/*  software.acellera.com:/var/www/software/test/
	#ssh software.acellera.com 'chmod -R g+rwX /var/www/software/test'

static:
	python render_jinja.py ./static_templates/ $(BUILDDIR)/static/
	cp -R ./static_files/* $(BUILDDIR)/static/

rst:
	scp -r software.acellera.com:/var/www/software/source/htmd/latest/* latest/source/htmd
	scp -r software.acellera.com:/var/www/software/source/parameterize/* latest/source/parameterize
	scp -r software.acellera.com:/var/www/software/source/aceflow/* latest/source/aceflow
	scp -r software.acellera.com:/var/www/software/source/acemd/* latest/source/acemd
	scp -r software.acellera.com:/var/www/software/source/acemd3/* latest/source/acemd3
	scp -r software.acellera.com:/var/www/software/source/moleculekit/* latest/source/moleculekit

html: static rst   
	$(SPHINXBUILD) -a -E -b html $(ALLSPHINXOPTS) latest/source $(BUILDDIR)/latest/html
	@echo
	@echo "Build finished. The HTML pages are in $(BUILDDIR)/latest/html"
