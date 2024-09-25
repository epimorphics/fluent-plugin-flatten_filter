.PHONY: auth clean gem publish test

NAME?=fluent-plugin-flatten_filter
OWNER?=epimorphics
VERSION?=$(shell cat VERSION)
PAT?=$(shell read -p 'Github access token:' TOKEN; echo $$TOKEN)

AUTH=${HOME}/.gem/credentials
GEM=${NAME}-${VERSION}.gem
GPR=https://rubygems.pkg.github.com/${OWNER}
SPEC=${NAME}.gemspec

${AUTH}:
	@mkdir -p ${HOME}/.gem
	@echo '---' > ${AUTH}
	@echo ':github: Bearer ${PAT}' >> ${AUTH}
	@chmod 0600 ${AUTH}

${GEM}: ${SPEC} VERSION
	gem build ${SPEC}

all: publish

auth: ${AUTH}

build: gem

clean:
	@rm -rf ${GEM}

gem: ${GEM}
	@echo ${GEM}

publish: ${AUTH} ${GEM}
	@echo Publishing package ${NAME}:${VERSION} to ${OWNER} ...
	@gem push --key github --host ${GPR} ${GEM}
	@echo Done.

realclean: clean
	@rm -rf ${AUTH}

tags:
	@echo version=${VERSION}

test:
	@bundle exec rspec

vars:
	@echo "GEM"	= ${GEM}
	@echo "GPR"	= ${GPR}
	@echo "NAME = ${NAME}"
	@echo "OWNER = ${OWNER}"
	@echo "SPEC = ${SPEC}"
	@echo "VERSION = ${VERSION}"
