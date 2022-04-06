# Assignment 3 HBase (... Because why only have one assignment 3 i a course)

Requirements for running:
docker-compose
bash (linux, Git bash or equivilent)

To set up database:
$ bash import-script.sh

Afterwards database can be accessed with:
$ docker exec -it hbase-master hbase shell

To see info about 
hbase> get 'foods', '93101000', 'info', 'nutrition'


scan 'foods', { FILTER => SingleColumnValueFilter.new(Bytes.toBytes('info'), Bytes.toBytes('Display_Name'), CompareFilter::CompareOp.valueOf('EQUAL'),BinaryComparator.new(Bytes.toBytes('Beer or ale')))}


_______

# Row key and Column families

Food_Code has been chosen for row key, as this is unique each code.
Display_Name could have been chosen, but as Food_Code can be assumed to be more static, and we will not typically make queries for individual rows.

For column families info and nutrition has been chosen, with info containing data regarding 