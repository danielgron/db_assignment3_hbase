require 'time'
import 'org.apache.hadoop.hbase.client.HTable'
import 'org.apache.hadoop.hbase.client.Put'
import 'javax.xml.stream.XMLStreamConstants'

def jbytes(*args)
    args.map { |arg| arg.to_s.to_java_bytes }
end

factory = javax.xml.stream.XMLInputFactory.newInstance
reader = factory.createXMLStreamReader(java.lang.System.in)
document = nil
buffer = nil
count = 0
table = HTable.new(@hbase.configuration, 'foods')
table.setAutoFlush(false)
while reader.has_next
    type = reader.next
    if type == XMLStreamConstants::START_ELEMENT
        case reader.local_name
        when 'Food_Display_Row' then document = {}
        when /Food_Code|Display_Name|Portion_Default|Portion_Amount|Portion_Display_Name|Factor|Increment|Multiplier|Grains|Multiplier|Whole_Grains|Vegetables|Orange_Vegetables|Drkgreen_Vegetables|Starchy_vegetables|Other_Vegetables|Fruits|Milk|Meats|Soy|Drybeans_Peas|Oils|Solid_Fats|Added_Sugars|Alcohol|Calories|Saturated_Fats/ then buffer = []
        end
    elsif type == XMLStreamConstants::CHARACTERS
        buffer << reader.text unless buffer.nil?
    elsif type == XMLStreamConstants::END_ELEMENT
        case reader.local_name
        when /Food_Code|Display_Name|Portion_Default|Portion_Amount|Portion_Display_Name|Factor|Increment|Multiplier|Grains|Multiplier|Whole_Grains|Vegetables|Orange_Vegetables|Drkgreen_Vegetables|Starchy_vegetables|Other_Vegetables|Fruits|Milk|Meats|Soy|Drybeans_Peas|Oils|Solid_Fats|Added_Sugars|Alcohol|Calories|Saturated_Fats/
            document[reader.local_name] = buffer.join
        when 'Food_Display_Row'
            key = document['Food_Code'].to_java_bytes
            # ts = (Time.parse document['timestamp']).to_i
            p = Put.new(key)
            p.add(*jbytes("info", "Display_Name", document['Display_Name']))
            p.add(*jbytes("info", "Portion_Default", document['Portion_Default']))
            p.add(*jbytes("info", "Portion_Amount", document['Portion_Amount']))
            p.add(*jbytes("info", "Portion_Display_Name", document['Portion_Display_Name']))
            p.add(*jbytes("info", "Factor", document['Factor']))
            p.add(*jbytes("info", "Increment", document['Increment']))
            p.add(*jbytes("info", "Multiplier", document['Multiplier']))
            p.add(*jbytes("nutrition", "Grains", document['Grains']))
            p.add(*jbytes("nutrition", "Whole_Grains", document['Whole_Grains']))
            p.add(*jbytes("nutrition", "Vegetables", document['Vegetables']))
            p.add(*jbytes("nutrition", "Orange_Vegetables", document['Orange_Vegetables']))
            p.add(*jbytes("nutrition", "Drkgreen_Vegetables", document['Drkgreen_Vegetables']))
            p.add(*jbytes("nutrition", "Starchy_vegetables", document['Starchy_vegetables']))
            p.add(*jbytes("nutrition", "Fruits", document['Fruits']))
            p.add(*jbytes("nutrition", "Milk", document['Milk']))
            p.add(*jbytes("nutrition", "Meats", document['Meats']))
            p.add(*jbytes("nutrition", "Soy", document['Soy']))
            p.add(*jbytes("nutrition", "Drybeans_Peas", document['Drybeans_Peas']))
            p.add(*jbytes("nutrition", "Oils", document['Oils']))
            p.add(*jbytes("nutrition", "Solid_Fats", document['Solid_Fats']))
            p.add(*jbytes("nutrition", "Added_Sugars", document['Added_Sugars']))
            p.add(*jbytes("nutrition", "Alcohol", document['Alcohol']))
            p.add(*jbytes("nutrition", "Calories", document['Calories']))
            p.add(*jbytes("nutrition", "Saturated_Fats", document['Saturated_Fats']))
            table.put(p)
            count += 1
            table.flushCommits() if count % 10 == 0
                if count % 50 == 0
                    puts "#{count} records inserted (#{document['Display_Name']})"
                end
            end
        end
    end

    table.flushCommits()
    exit