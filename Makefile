help: ## Show help message.
	@printf "===Good night helpful command===\n"
	@printf "Usage:\n"
	@printf "  make <target>\n\n"
	@printf "Targets:\n"
	@perl -nle'print $& if m{^[a-zA-Z0-9_-]+:.*?## .*$$}' $(MAKEFILE_LIST) | \
		sort | \
		awk 'BEGIN {FS = ":.*?## "}; \
		{printf "  %-18s %s\n", $$1, $$2}'

build: ## build & initialize project
	docker-compose build
	docker-compose up -d rails
	docker-compose run --rm rails bundle exec rake db:drop db:create db:seed
	make migrate

up: ## create & start good-night service
	docker-compose up -d rails

stop: ## stop good-night service
	docker-compose stop

restart: ## restart good-night service
	docker-compose restart

down: ## stop & remove good-night service
	docker-compose down

console: ## enter rails container's irb
	docker-compose exec rails bin/rails console

bash: ## enter rails container's bash
	docker-compose exec -u root rails bash

migrate: ## migrate rails models & annotate model information
	docker-compose exec rails bin/rails db:migrate
	docker-compose exec rails annotate --models

run-test: ## run rails' tests
	docker-compose exec rails rspec