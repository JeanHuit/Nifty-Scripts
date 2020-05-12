# output - Hash
# ['articles'][0]['title'] === will give you the titles
# ['articles'][0]['content'] === will give you the snippet
# ['articles'][0]['description'] === will give you the descripiton
# ['articles'][0]['url'] === will give you the link

require 'open-uri'
require 'json'
require 'dotenv'

Dotenv.load

@newsapi = ENV['news_key']

news_topic = ARGV.first
time_parameter = Time.now
time_ = time_parameter.year.to_s + '-' + time_parameter.month.to_s + '-' +
        time_parameter.day.to_s

def receive_news(query, time_)
  url = "http://newsapi.org/v2/everything?q=#{query}&from=#{time_}&sortBy=publishedAt&apiKey=#{@newsapi}"
  raw_output = URI.open(url).read
  content = JSON.parse(raw_output)
  totalresults = content['totalResults'].to_i
  (0...totalresults).each do |number|
    puts content['articles'][number]['title']
    # puts content['articles'][number]['content']
        # TODO - Put in rescue statements to skip the errors

  end
end

def receive_headlines
  url = "http://newsapi.org/v2/top-headlines?sources=google-news&apiKey=#{@newsapi}"
  raw_output = URI.open(url).read
  content = JSON.parse(raw_output)
  totalresults = content['totalResults'].to_i
  (0...totalresults).each do |number|
    puts content['articles'][number]['title']
    # TODO - Put in rescue statements to skip the errors
  end
end

if news_topic.nil?
  receive_headlines
else
  receive_news(news_topic, time_)
end
