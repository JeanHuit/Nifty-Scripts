# require 'csv'

# # Array to store all the file names
# files_to_merge = ['malicious_phish.csv', 'Benign_list_big_final.csv','DefacementSitesURLFiltered.csv','Malware_dataset.csv','phishing_dataset.csv','spam_dataset.csv']

# # Name of the output file
# output_file_name = "merged_file.csv"

# # Open the output file for writing
# CSV.open(output_file_name, "wb") do |csv_out|
#   files_to_merge.each do |file_name|
#     # Open each input file for reading
#     CSV.foreach(file_name, headers: true) do |row|
#       # Write the row to the output file
#       csv_out << row
#     end
#   end
# end

# puts "Merged file saved as #{output_file_name}"


require 'csv'

# Array to store headers from all CSV files
headers = []

# Array to store all rows from all CSV files
rows = []

# Loop through each CSV file to read its contents
Dir.glob("*.csv").each do |file|
  begin
    # Read contents of CSV file into a 2D array
    data = CSV.read(file)

    # Store headers from first CSV file
    if headers.empty?
      headers = data.first
    end

    # Store all rows from all CSV files
    rows += data[1..-1]
  rescue CSV::MalformedCSVError => e
    puts "Error: #{e.message}"
    puts "Skipping file: #{file}"
  end
end

# Write contents of all CSV files to a new CSV file
CSV.open("merged.csv", "wb") do |csv|
  # Write headers to new CSV file
  csv << headers

  # Write rows to new CSV file
  rows.each do |row|
    csv << row
  end
end
