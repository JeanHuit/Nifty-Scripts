require 'rss'
require 'open-uri'
news_feed = Hash.new
number = 0
url = 'https://cdn.ghanaweb.com/feed/newsfeed.xml'
rss = URI.open(url).read
feed = RSS::Parser.parse(rss)
puts "Title: #{feed.channel.title}"
feed.items.each do |item|
  news_feed[number] = "<a href=#{item.link}>#{item.title}</a>: #{item.description}"
  number += 1
end
news_feed.each{}
