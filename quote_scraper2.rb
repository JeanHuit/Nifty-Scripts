#!/usr/bin/env ruby
require 'nokogiri'
require 'net/http'
require 'uri'
require 'csv'
require 'date'

# URL to scrape
url = "https://www.inc.com/bill-murphy-jr/365-inspirational-quotes-for-2025/91066225"

puts "Fetching content from #{url}..."

begin
  # Set up the request with proper headers to mimic a browser
  uri = URI.parse(url)
  request = Net::HTTP::Get.new(uri)
  request["User-Agent"] = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
  request["Accept"] = "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8"
  request["Accept-Language"] = "en-US,en;q=0.5"
  request["Connection"] = "keep-alive"
  request["Upgrade-Insecure-Requests"] = "1"
  request["Cache-Control"] = "max-age=0"

  # Execute the request
  response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') do |http|
    http.request(request)
  end

  # Check if response is successful
  if response.code != "200"
    raise "HTTP Error: #{response.code} - #{response.message}"
  end

  # Get the HTML content
  html_content = response.body

  # Parse HTML with Nokogiri
  doc = Nokogiri::HTML(html_content)

  # Find all content chunks (where quotes are located)
  content_chunks = doc.css('.content-chunk')

  puts "Found #{content_chunks.length} content chunks."

  # Create or overwrite CSV file
  CSV.open('motivational_quotes.csv', 'w') do |csv|
    # Write header
    csv << ['date', 'quote']

    # Get current year
    year = 2025

    # Process each content chunk
    content_chunks.each_with_index do |chunk, index|
      # Extract quote text
      quote_text = chunk.text.strip

      # Create a date for this quote (Jan 1 to Dec 31)
      date = begin
        Date.new(year, 1, 1) + index
      rescue Date::Error
        # Handle the case where index goes beyond Dec 31
        puts "Warning: Quote index #{index} exceeds days in year. Using December 31."
        Date.new(year, 12, 31)
      end

      # Format date as YYYY-MM-DD
      formatted_date = date.strftime('%Y-%m-%d')

      # Write to CSV
      csv << [formatted_date, quote_text]

      # Print progress every 30 quotes
      puts "Processed quote #{index + 1} for date #{formatted_date}" if (index + 1) % 30 == 0
    end
  end

  puts "Successfully scraped quotes and saved to motivational_quotes.csv"
  puts "Total quotes scraped: #{content_chunks.length}"

rescue OpenURI::HTTPError => e
  puts "Error accessing the website: #{e.message}"
rescue StandardError => e
  puts "An error occurred: #{e.message}"
end
