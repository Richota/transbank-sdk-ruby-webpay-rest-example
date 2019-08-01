SHELL := /bin/bash

all: build run

run: build
	docker-compose run --service-ports web

build: .built .bundled

.built: Dockerfile
	docker-compose build
	touch .built

.bundled: Gemfile Gemfile.lock
	docker-compose run --rm web bundle
	touch .bundled

stop:
	docker-compose stop

restart: build
	docker-compose restart web

clean: stop
	rm -f tmp/pids/*
	docker-compose rm -f -v bundle_cache
	rm -f .bundled
	docker-compose rm -f
	rm -f .built

logs:
	docker-compose logs