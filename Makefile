.PHONY: check test
.DEFAULT_GOAL := all

# shellcheck tests
#
scripts = build.sh
check:
	for i in $(scripts) ; do \
		shellcheck $$i ; \
		done

# unit tests
#
tests = shunit2/build.sh
unit:
	for i in $(tests) ; do \
		printf "\n%s:\n" $$i ; \
		bash $$i ; \
		done

all: check unit
