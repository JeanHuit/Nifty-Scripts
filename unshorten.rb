# Author: King Sabri with slight modifications from Jean Huit
# Date: 23-05-2018

require 'net/http'
uri = ARGV[0].to_s
unless uri.empty?
  loop do
    puts uri
    res = Net::HTTP.get_response URI uri
    if !res['location'].nil?
      uri = res['location']
    else
      break
    end
  end
else
  puts 'usage: ruby unshorten.rb [shortened link]'
end
