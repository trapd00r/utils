
# rebuild broken magento

docker compose exec php php -d memory_limit=-1 /srv/magento/bin/magento cache:flush
docker compose exec php php -d memory_limit=-1 /srv/magento/bin/magento setup:di:compile
docker compose exec php php -d memory_limit=-1 /srv/magento/bin/magento setup:upgrade
docker compose exec php php -d memory_limit=-1 /srv/magento/bin/magento cache:flush
docker compose exec php php -d memory_limit=-1 /srv/magento/bin/magento setup:di:compile

