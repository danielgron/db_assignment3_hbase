# !/bin/bash
docker-compose -f docker-compose-distributed-local.yml down
docker-compose -f docker-compose-distributed-local.yml up -d
docker cp ./create-table.sh hbase-master:/create-table.sh
docker cp ./put_food.rb hbase-master:/put_food.rb
docker cp ./Food_Display_Table.xml hbase-master:/Food_Display_Table.xml

docker exec hbase-master bash /create-table.sh