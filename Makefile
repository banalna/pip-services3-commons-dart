.PHONY: test generate gendoc docview analyze

test:
	@pub run test ./test

generate:
	@pub run build_runner build

gendoc:
	@dartdoc --no-auto-include-dependencies --no-include-source --show-progress

docview:
	@dhttpd --path doc/api

analyze:
	@dartanalyzer .
