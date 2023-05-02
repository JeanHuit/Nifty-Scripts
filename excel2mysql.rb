# require 'roo'
# require 'mysql2'

# # Open the Excel file for reading
# excel = Roo::Excelx.new('q.xlsx')

# # Connect to the MySQL database
# client = Mysql2::Client.new(
#   :host => 'localhost',
#   :username => 'root',
#   :password => 'root',
#   :database => 'technology'
# )

# # Loop through each row in the Excel file and insert the data into the database
# (2..excel.last_row).each do |i|
#   technology = excel.cell(i, 'A')
#   year = excel.cell(i, 'B')
#   attributes = excel.cell(i, 'C')
#   applicability = excel.cell(i, 'D')
#   uses_and_benefits = excel.cell(i, 'E')
#   contact = excel.cell(i, 'F')
#   telephone = excel.cell(i, 'G')
#   email = excel.cell(i, 'H')
#   website = excel.cell(i, 'I')

#   # Insert the data into the database
#   client.query("INSERT INTO processedFoods (Technology, Year, Attributes, Applicability, UsesAndBenefits, Contact, Telephone, Email, Website) VALUES ('#{technology}', '#{year}', '#{attributes}', '#{applicability}', '#{uses_and_benefits}', '#{contact}', '#{telephone}', '#{email}', '#{website}')")
# end

# # Close the database connection
# client.close


# require 'roo' # for reading Excel files
# require 'mysql2' # for interacting with MySQL database

# # Connect to MySQL database
# client = Mysql2::Client.new(
#   host: 'localhost',
#   username: 'root',
#   password: 'root',
#   database: 'technology'
# )

# # Open the Excel file
# xlsx = Roo::Spreadsheet.open('q.xlsx')

# # Select the sheet containing the data
# sheet = xlsx.sheet('CROP VARIETIES')
# begin
# # Loop through each row of data
# sheet.each_row_streaming do |row|
#   # Get the values of each cell
#   technology = row[0].value
#   categories = row[1].value
#   year = row[2].value
#   attributes = row[3].value
#   seedcolour = row[4].value
#   maturity_in_days = row[5].value
#   potential_yield_ton_per_ha = row[6].value
#   applicability = row[7].value
#   benefits = row[8].value
#   contact = row[9].value
#   telephone = row[10].value
#   email = row[11].value
#   websiteFax = row[12].value

#   # Insert the data into the MySQL table
#   client.query("INSERT INTO cropVarieties (Technology, Categories, Year, Attributes, Seedcolour, Maturity_in_days, Potential_yield_ton_per_ha, Applicability, Benefits, Contact, Telephone, Email, WebsiteFax) VALUES ('#{technology}', '#{categories}', '#{year}', '#{attributes}', '#{seedcolour}', '#{maturity_in_days}', '#{potential_yield_ton_per_ha}', '#{applicability}', '#{benefits}','#{contact}','#{telephone}','#{email}','#{websiteFax}')")
# rescue NoMethodError => e

# end
# end

# client.close

require 'roo'
require 'mysql2'

# Connect to MySQL database
client = Mysql2::Client.new(
  host: 'localhost',
  username: 'root',
  password: 'root',
  database: 'technology'
)

# Open Excel file
xlsx = Roo::Spreadsheet.open('q.xlsx')

# Iterate over rows in the Excel file
xlsx.each_row_streaming do |row|
  # Extract data from each column
  technology = row[0]&.value
  year = row[1]&.value
  attributes = row[2]&.value
  applicability = row[3]&.value
  uses = row[4]&.value
  contact = row[5]&.value
  telephone = row[6]&.value
  email = row[7]&.value
  gps = row[8]&.value
  category = row[9]&.value

  # Insert data into MySQL database
  
  client.query("INSERT INTO otherTechnologies (Technology, Year, Attributes, Applicability, Uses, Contact, Telephone, Email, GPS, Category) VALUES ('#{technology}', '#{year}', '#{attributes}', '#{applicability}', '#{uses}', '#{contact}', '#{telephone}', '#{email}', '#{gps}', '#{category}')")
end
