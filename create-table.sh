echo "disable 'foods'" | hbase shell -n
echo "drop 'foods'" | hbase shell -n
echo "create 'foods', 'info', 'nutrition'" | hbase shell -n
cat /Food_Display_Table.xml | hbase shell -n /put_food.rb