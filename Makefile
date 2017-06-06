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
ALLSPHINXOPTS   = -d $(BUILDDIR)/doctrees $(PAPEROPT_$(PAPER)) $(SPHINXOPTS) source

.PHONY: help clean static publish publish-test html

help:
	@echo "Please use \`make <target>' where <target> is one of"
	@echo "  static       build static files"
	@echo "  publish      copy static files to server"

clean:
	rm -rf $(BUILDDIR)/

publish:
	scp -r $(BUILDDIR)/html/* www.acellera.com:~/software.acellera.com/docs/
	scp -r $(BUILDDIR)/static/*  www.acellera.com:~/software.acellera.com/
	ssh www.acellera.com 'chmod -R g+rwX software.acellera.com/'

publish-test:
	ssh www.acellera.com 'mkdir -p ~/software.acellera.com/test'
	scp -r $(BUILDDIR)/html/* www.acellera.com:~/software.acellera.com/test/docs/
	scp -r $(BUILDDIR)/static/*  www.acellera.com:~/software.acellera.com/test/
	ssh www.acellera.com 'chmod -R g+rwX software.acellera.com/test'

static:
	python render_jinja.py ./static_templates/ $(BUILDDIR)/static/
	cp -R ./static_files/* $(BUILDDIR)/static/

html: static
#Get each software source
	$(SPHINXBUILD) -a -E -b html $(ALLSPHINXOPTS) $(BUILDDIR)/html
	@echo
	@echo "Build finished. The HTML pages are in $(BUILDDIR)/html"
