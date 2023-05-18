# require 'rqrcode'
# require 'csv'
# require 'fileutils'

# # Create the qrcodes directory if it doesn't already exist
# FileUtils.mkdir_p('qrcodes')

# # Set the batch size to 1000 records
# BATCH_SIZE = 1000

# # Open the CSV file and process the records in batches
# CSV.foreach('malicious_phish.csv', headers: false, encoding: 'UTF-8') do |row|
#   url = row[0]

#   # Generate a QR code for the URL
#   qr_code = RQRCode::QRCode.new(url)

#   # Save the QR code as a PNG file
#   png = qr_code.as_png(
#     bit_depth: 1,
#     border_modules: 4,
#     color_mode: ChunkyPNG::COLOR_GRAYSCALE,
#     color: 'black',
#     file: nil,
#     fill: 'white',
#     module_px_size: 6,
#     resize_exactly_to: false,
#     resize_gte_to: false,
#     size: 640
#   )

#   # Save the QR code as a file in the qrcodes directory
#   File.open("qrcodes/#{url}.png", 'w') { |f| f.write png.to_s }

#   # If we've processed a full batch, print a progress message
#   if CSV.lineno % BATCH_SIZE == 0
#     puts "Processed #{CSV.lineno} records..."
#   end
# end

# # Print a final progress message
# puts "Processed #{CSV.lineno} records."


# require 'rqrcode'
# require 'csv'
# require 'fileutils'

# # Create the base directory for QR codes
# BASE_DIR = 'qrcodes'

# # Open the CSV file
# CSV.foreach('malicious_phish.csv', headers: true, encoding: 'UTF-8') do |row|
#   url = row[0]
#   qr_type = row[1]

#   # Generate a QR code for the URL
#   qr_code = RQRCode::QRCode.new(url)

#   # Determine the directory path based on the type
#   dir_path = File.join(BASE_DIR, qr_type)

#   # Create the directory if it doesn't already exist
#   FileUtils.mkdir_p(dir_path)

#   # Save the QR code as a PNG file in the appropriate directory
#   png = qr_code.as_png(
#     file: nil,
#     resize_exactly_to: false,
#     resize_gte_to: false,
#     size: 640
#   )
#   File.open(File.join(dir_path, "#{url}.png"), 'w') { |f| f.write png.to_s }
# end

# require 'rqrcode'
# require 'csv'
# require 'fileutils'

# # Create the base directory for QR codes
# BASE_DIR = 'qrcodes'
# GOOD_DIR = File.join(BASE_DIR, 'good')
# BAD_DIR = File.join(BASE_DIR, 'bad')

# # Create the "good" and "bad" directories if they don't exist
# FileUtils.mkdir_p(GOOD_DIR)
# FileUtils.mkdir_p(BAD_DIR)

# # Open the CSV file
# CSV.foreach('malicious_phish.csv', headers: true, encoding: 'UTF-8') do |row|
#   url = row[0]
#   qr_type = row[1]

#   # Generate a QR code for the URL
#   qr_code = RQRCode::QRCode.new(url)

#   # Determine the directory path based on the type
#   dir_path = qr_type == 'benign' ? GOOD_DIR : BAD_DIR

#   # Save the QR code as a PNG file in the appropriate directory
#   png = qr_code.as_png(
#     file: nil,
#     resize_exactly_to: false,
#     resize_gte_to: false,
#     size: 640
#   )

#   num = 0
#   if qr_type == 'benign'
#     File.open(File.join(dir_path, "good_#{num}.png"), 'w') { |f| f.write png.to_s }
#     num+=1
#   else
#     File.open(File.join(dir_path, "bad_#{num}.png"), 'w') { |f| f.write png.to_s }
#     num+=1
#   end
#   end
# end


require 'rqrcode'
require 'csv'
require 'fileutils'

# Create the base directory for QR codes
BASE_DIR = 'qrcodes'
GOOD_DIR = File.join(BASE_DIR, 'good')
BAD_DIR = File.join(BASE_DIR, 'bad')

# Create the "good" and "bad" directories if they don't exist
FileUtils.mkdir_p(GOOD_DIR)
FileUtils.mkdir_p(BAD_DIR)

# Counter for numerical filenames
counter = 1

# Open the CSV file
CSV.foreach('malicious_phish.csv', headers: true, encoding: 'UTF-8') do |row|
  url = row[0]
  qr_type = row[1]

  # Generate a QR code for the URL
  qr_code = RQRCode::QRCode.new(url)

  # Determine the directory path based on the type
  dir_path = qr_type == 'benign' ? GOOD_DIR : BAD_DIR

  # Save the QR code as a PNG file with a numerical filename
  png = qr_code.as_png(
    file: nil,
    resize_exactly_to: false,
    resize_gte_to: false,
    size: 640
  )
  File.open(File.join(dir_path, "#{counter}.png"), 'wb') { |f| f.write png.to_s }

  # Increment the counter for the next filename
  counter += 1
end
