
# rebuild broken magento

docker compose exec -u $USER php php -d memory_limit=-1 /srv/magento/bin/magento cache:flush
docker compose exec -u $USER php php -d memory_limit=-1 /srv/magento/bin/magento setup:di:compile
docker compose exec -u $USER php php -d memory_limit=-1 /srv/magento/bin/magento setup:upgrade
docker compose exec -u $USER php php -d memory_limit=-1 /srv/magento/bin/magento cache:flush
docker compose exec -u $USER php php -d memory_limit=-1 /srv/magento/bin/magento setup:di:compile

