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
	scp -r $(BUILDDIR)/latest/html/* software.acellera.com:/var/www/software.acellera.com/docs/latest
	scp -r $(BUILDDIR)/static/*  software.acellera.com:/var/www/software.acellera.com/
	#ssh software.acellera.com 'chgrp -R www-htmd /var/www/software.acellera.com/; chmod -R g+rwX /var/www/software.acellera.com/'

publish-test:
	ssh software.acellera.com 'mkdir -p /var/www/software.acellera.com/test'
	scp -r $(BUILDDIR)/latest/html/* software.acellera.com:/var/www/software.acellera.com/test/docs/latest
	scp -r $(BUILDDIR)/static/*  software.acellera.com:/var/www/software.acellera.com/test/
	#ssh software.acellera.com 'chmod -R g+rwX /var/www/software.acellera.com/test'

static:
	python render_jinja.py ./static_templates/ $(BUILDDIR)/static/
	cp -R ./static_files/* $(BUILDDIR)/static/

rst:
	scp -r software.acellera.com:/var/www/software.acellera.com/source/htmd/latest/* latest/source/htmd
	scp -r software.acellera.com:/var/www/software.acellera.com/source/parameterize/* latest/source/parameterize
	scp -r software.acellera.com:/var/www/software.acellera.com/source/aceflow/* latest/source/aceflow
	scp -r software.acellera.com:/var/www/software.acellera.com/source/acemd/* latest/source/acemd
	scp -r software.acellera.com:/var/www/software.acellera.com/source/acemd3/* latest/source/acemd3
	scp -r software.acellera.com:/var/www/software.acellera.com/source/moleculekit/* latest/source/moleculekit
	scp -r software.acellera.com:/var/www/software.acellera.com/source/playmolecule/* latest/source/playmolecule

html: static rst    
	$(SPHINXBUILD) -a -E -b html $(ALLSPHINXOPTS) latest/source $(BUILDDIR)/latest/html
	cp my_searchtools.js build/latest/html/_static/searchtools.js
	@echo
	@echo "Build finished. The HTML pages are in $(BUILDDIR)/latest/html"
