require 'yaml'
require 'date'

class QuoteExtractor
  def initialize(input_file, output_file)
    @input_file = input_file
    @output_file = output_file
  end

  def extract_quotes
    quotes = []
    current_quote = {}

    File.open(@input_file, 'r') do |file|
      file.each_line do |line|
        line.strip!

        # Skip empty lines
        next if line.empty?

        # Check if line is a date (e.g., "Wednesday January 1, 2025")
        if line.match?(/^\w+ \w+ \d{1,2}, \d{4}$/)
          current_quote[:date] = parse_date(line)
        # Check if line is a quote (starts with “ or ")
        elsif line.match?(/^[“"]/)
          current_quote[:quote] = line.gsub(/^[“"]|["”]$/, '').strip
        # Check if line is an author (starts with —)
        elsif line.start_with?('—')
          current_quote[:author] = line.gsub(/^—/, '').strip
          # If all fields are present, add to quotes and reset
          if current_quote.key?(:date) && current_quote.key?(:quote) && current_quote.key?(:author)
            quotes << current_quote.dup
            current_quote.clear
          end
        end
      end
    end

    write_to_yaml(quotes)
  end

  private

  def parse_date(date_str)
    # Convert "Wednesday January 1, 2025" to "2025-01-01" (ISO format for Dataview)
    Date.parse(date_str).strftime('%Y-%m-%d')
  rescue ArgumentError
    date_str # Fallback if parsing fails
  end

  def write_to_yaml(quotes)
    File.open(@output_file, 'w') do |file|
      file.puts quotes.to_yaml(line_width: -1)
    end
  end
end

# Usage
input_file = 'motivational.txt'
output_file = 'quotes.yaml'

extractor = QuoteExtractor.new(input_file, output_file)
extractor.extract_quotes
