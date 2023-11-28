require 'axlsx'

def generate_excel_file
  # Create a new workbook
  workbook = Axlsx::Package.new.workbook

  # Add headers to the first row
  headers = ['Staff Email', 'Username', 'Password', 'Full Name', 'Phone Number', 'About Me', 'Address', 'Institute', 'Division', 'User Rank', 'Sex', 'DOB']
  workbook.add_worksheet(name: 'Staff List') do |sheet|
    sheet.add_row headers
  end

  # Sample data
  data = [
    ['staff_email@example.com', 'username1', '@csir23rms', 'John Doe', '123456789', 'About John', '123 Main St', 'Institute A', 'Division 1', 'Rank A', 'Male', '1990-01-01'],
    ['staff_email2@example.com', 'username2', '@csir23rms', 'Jane Smith', '987654321', 'About Jane', '456 Elm St', 'Institute B', 'Division 2', 'Rank B', 'Female', '1995-05-05']
  ]

  # Add the sample data to the sheet
  workbook.add_worksheet(name: 'Stafx List') do |sheet|
    data.each do |row|
      sheet.add_row row
    end
  end

  # Save the workbook to a file
  file_path = 'stafx_list.xlsx'
  workbook.use_shared_strings = true
  workbook.serialize(file_path)

  puts "Excel file generated: #{file_path}"
end

# Call the method to generate the Excel file
generate_excel_file
