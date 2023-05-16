build:
	docker-compose build
	docker-compose run --rm rails bundle exec rake db:drop db:create

up:
	docker-compose up -d rails

stop:
	docker-compose stop

restart:
	docker-compose restart

down:
	docker-compose down

console:
	docker-compose exec rails bin/rails console