require 'Spidr'
require 'open-uri'
require 'digest'
require "awesome_print"

url_list = Hash.new { |hash, key| hash[key] = [] }


Spidr.site('http://localhost/web/') do |spider|
  spider.every_url do |url|
    url_digest = open(url).read
    url_list[url] = Digest::SHA2.hexdigest "#{url_digest}"
  end
end

puts url_list.size
ap url_list
