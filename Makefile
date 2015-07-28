################################################################
####
####	Makefile
####
################################################################

# The default target of this Makefile: all
.PHONY: all clean

# Files to be signed are listed in SIGNED_FILES:
SIGNED_FILES = README.md LICENSE html/*.html

GPG = gpg
# GPG_SIGN_KEY is supplied to "gpg -u", specifying the signing key:
GPG_SIGN_KEY = infcn
# Set GPG_SIGN_ARMORED to be "yes" if armored signature is needed:
GPG_SIGN_ARMORED = no

all:
	if [[ -n "$(SIGNED_FILES)" ]]; then \
	    for file in $(SIGNED_FILES); do \
	        if [[ "$(GPG_SIGN_ARMORED)" == "yes" ]]; then \
		    make $${file}.asc; \
		else \
		    make $${file}.sig; \
		fi; \
	    done; \
	fi

%.asc: %
	@echo "Signature of $< updated? (y/N)"
	@read answer; \
	    if [[ $${answer} == "y" ]]; then \
	        $(GPG) -u $(GPG_SIGN_KEY) -a -b $< ; \
	    fi

%.sig: %
	@echo "Signature of $< updated? (y/N)"
	@read answer; \
	    if [[ $${answer} == "y" ]]; then \
	        $(GPG) -u $(GPG_SIGN_KEY) -b $< ; \
	    fi

clean:
	rm -f `find . -name "?*~"`
