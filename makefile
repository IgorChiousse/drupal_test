show:
	cat makefile
up:
	docker-compose up -d
build:
	docker-compose build --no-cache
php:
	docker exec -it drupal_dev_kit_php_1 bash
logs:
	docker logs -f drupal_dev_kit_php_1	
stop:
	docker-compose stop
down:
	docker-compose down
	
