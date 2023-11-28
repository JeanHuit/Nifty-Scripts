# require 'roo'
# require 'geocoder'

# # Load the Excel sheet
# excel = Roo::Excelx.new('geo.xlsx')

# # Assuming the sheet has a column named 'Town' containing town names
# town_column_index = excel.column('DISTRICT').first
# town_names = excel.column(town_column_index)

# # Function to get coordinates for a town
# def get_coordinates(town_name)
#   result = Geocoder.search(town_name).first
#   result.coordinates if result
# end

# # Add latitude and longitude columns to the sheet
# latitude_column_index = excel.column('Latitude').first || excel.last_column + 1
# longitude_column_index = excel.column('Longitude').first || excel.last_column + 2

# excel.set(1, latitude_column_index, 'Latitude')
# excel.set(1, longitude_column_index, 'Longitude')

# # Iterate through each town, get coordinates, and update the sheet
# town_names.each_with_index do |town_name, index|
#   coordinates = get_coordinates(town_name)
#   if coordinates
#     excel.set(index + 2, latitude_column_index, coordinates[0])
#     excel.set(index + 2, longitude_column_index, coordinates[1])
#   else
#     puts "Failed to get coordinates for #{town_name}"
#   end
# end

# # Save the modified Excel sheet
# excel.save


# require 'roo'
# require 'geocoder'

# # Load the Excel sheet
# excel = Roo::Excelx.new('geo.xlsx')

# # Assuming the sheet has a column named 'Town' containing town names
# town_column_index = excel.column('DISTRICT').first
# town_names = excel.column(town_column_index)

# # Function to get coordinates for a town
# def get_coordinates(town_name)
#   result = Geocoder.search(town_name).first
#   result&.coordinates # Use the safe navigation operator &. to avoid nil error
# end

# # Add latitude and longitude columns to the sheet
# latitude_column_index = excel.column('Latitude').first || excel.last_column + 1
# longitude_column_index = excel.column('Longitude').first || excel.last_column + 2

# excel.set(excel.first_row, latitude_column_index, 'Latitude')
# excel.set(excel.first_row, longitude_column_index, 'Longitude')

# # Iterate through each town, get coordinates, and update the sheet
# town_names.each_with_index do |town_name, index|
#   coordinates = get_coordinates(town_name)
#   if coordinates
#     excel.set(index + 2, latitude_column_index, coordinates[0])
#     excel.set(index + 2, longitude_column_index, coordinates[1])
#   else
#     puts "Failed to get coordinates for #{town_name}"
#   end
# end

# # Save the modified Excel sheet
# excel.to_excel('geo2.xlsx')


# require 'axlsx'
# require 'geocoder'

# # Load the Excel sheet
# xlsx = Axlsx::Package.new
# workbook = xlsx.workbook

# # Assuming the sheet has a column named 'Town' containing town names
# town_column_index = 0 # Adjust the index based on your actual column
# town_names = ['Town1', 'Town2', 'Town3'] # Replace with actual town names or load from Excel

# # Function to get coordinates for a town
# def get_coordinates(town_name)
#   result = Geocoder.search(town_name + ', Ghana').first
#   result&.coordinates # Use the safe navigation operator &. to avoid nil error
# end

# # Add latitude and longitude columns to the sheet
# latitude_column_index = 1
# longitude_column_index = 2

# workbook.add_worksheet(name: 'Sheet1') do |sheet|
#   sheet.add_row(['Town', 'Latitude', 'Longitude'])

#   # Iterate through each town, get coordinates, and update the sheet
#   town_names.each do |town_name|
#     coordinates = get_coordinates(town_name)
#     if coordinates
#       sheet.add_row([town_name, coordinates[0], coordinates[1]])
#     else
#       puts "Failed to get coordinates for #{town_name}"
#     end
#   end
# end

# # Save the modified Excel sheet
# xlsx.serialize('path/to/your/updated_excel_file.xlsx')



require 'axlsx'
require 'roo'
require 'geocoder'

# Load the Excel sheet using roo
excel = Roo::Excelx.new('geo.xlsx')

# Assuming the sheet has a column named 'Town' containing town names
town_column_index = excel.column('DISTRICT').first
town_names = excel.column(town_column_index)

# Initialize the Axlsx package
xlsx = Axlsx::Package.new
workbook = xlsx.workbook

# Function to get coordinates for a town
def get_coordinates(town_name)
  result = Geocoder.search(town_name).first
  result&.coordinates # Use the safe navigation operator &. to avoid nil error
end

# Add latitude and longitude columns to the sheet
latitude_column_index = 1
longitude_column_index = 2

# Add a worksheet to the workbook
workbook.add_worksheet(name: 'Sheet1') do |sheet|
  sheet.add_row(['Town', 'Latitude', 'Longitude'])

  # Iterate through each town, get coordinates, and update the sheet
  town_names.each do |town_name|
    coordinates = get_coordinates(town_name)
    if coordinates
      sheet.add_row([town_name, coordinates[0], coordinates[1]])
    else
      puts "Failed to get coordinates for #{town_name}"
    end
  end
end

# Save the modified Excel sheet
xlsx.serialize('geo2.xlsx')
