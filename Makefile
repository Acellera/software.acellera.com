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
	rm -rf latest/source/htmd/*
	rm -rf latest/source/parameterize/*
	rm -rf latest/source/acecloud/*
	rm -rf latest/source/aceflow/*
	rm -rf latest/source/acemd/*

publish:
	scp -r $(BUILDDIR)/latest/html/* www.acellera.com:~/software.acellera.com/docs/latest
	scp -r $(BUILDDIR)/stable/html/* www.acellera.com:~/software.acellera.com/docs/stable
	scp -r $(BUILDDIR)/static/*  www.acellera.com:~/software.acellera.com/
	ssh www.acellera.com 'chgrp -R www-htmd software.acellera.com/; chmod -R g+rwX software.acellera.com/'

publish-test:
	ssh www.acellera.com 'mkdir -p ~/software.acellera.com/test'
	scp -r $(BUILDDIR)/latest/html/* www.acellera.com:~/software.acellera.com/test/docs/latest
	scp -r $(BUILDDIR)/stable/html/* www.acellera.com:~/software.acellera.com/test/docs/stable
	scp -r $(BUILDDIR)/static/*  www.acellera.com:~/software.acellera.com/test/
	ssh www.acellera.com 'chmod -R g+rwX software.acellera.com/test'

static:
	python render_jinja.py ./static_templates/ $(BUILDDIR)/static/
	cp -R ./static_files/* $(BUILDDIR)/static/

rst:
	scp -r www.acellera.com:~/software.acellera.com/source/htmd/latest/* latest/source/htmd
	scp -r www.acellera.com:~/software.acellera.com/source/htmd/stable/* stable/source/htmd
	#For others
	scp -r www.acellera.com:~/software.acellera.com/source/parameterize/* latest/source/parameterize
	scp -r www.acellera.com:~/software.acellera.com/source/parameterize/* stable/source/parameterize
	scp -r www.acellera.com:~/software.acellera.com/source/acecloud/* latest/source/acecloud
	scp -r www.acellera.com:~/software.acellera.com/source/acecloud/* stable/source/acecloud
	scp -r www.acellera.com:~/software.acellera.com/source/aceflow/* latest/source/aceflow
	scp -r www.acellera.com:~/software.acellera.com/source/aceflow/* stable/source/aceflow
	scp -r www.acellera.com:~/software.acellera.com/source/acemd/* latest/source/acemd
	scp -r www.acellera.com:~/software.acellera.com/source/acemd/* stable/source/acemd

html: static rst
	$(SPHINXBUILD) -a -E -b html $(ALLSPHINXOPTS) latest/source $(BUILDDIR)/latest/html
	$(SPHINXBUILD) -a -E -b html $(ALLSPHINXOPTS) stable/source $(BUILDDIR)/stable/html
	@echo
	@echo "Build finished. The HTML pages are in $(BUILDDIR)/html"
