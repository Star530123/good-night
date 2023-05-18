build:
	docker-compose build
	docker-compose up -d rails
	docker-compose run --rm rails bundle exec rake db:drop db:create db:seed

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

bash:
	docker-compose exec -u root rails bash

migrate:
	docker-compose exec rails bin/rails db:migrate
	docker-compose exec rails annotate --models

run-test:
	docker-compose exec rails rspec