build:
	docker-compose build
	docker-compose run --rm rails bundle exec rake db:drop db:create

up:
	docker-compose up -d rails