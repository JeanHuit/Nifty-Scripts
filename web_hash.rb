# Author: Jean Huit
# Date: 08-02-2018
# Dependencies: Spidr | open-uri | digest

require 'Spidr'
require 'open-uri'
require 'digest'

url_list = Hash.new { |hash, key| hash[key] = [] }

Spidr.site('http://localhost/ladma') do |spider|
  spider.every_url do |url|
    url_digest = open(url).read
    url_list[url] = Digest::SHA2.hexdigest "#{url_digest}"
  end
end

puts url_list


# TODO: Connect to some of database for persistence
# TODO: Make up a simple web interface for this
