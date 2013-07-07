require 'awesome_print'
require 'open-uri'
require_relative './pub_med_api.rb'

namespace :publication do

  desc "Importing page_rank data on the server"
  task :import => :environment do

    file = "./test/fixtures/page_rank_test_data.txt" if Rails.env.development?
    file = "http://jairodiaz.co/ranker_pagerank.txt" if Rails.env.production?

    i = 0
    open(file).each_line do |line|
      i += 1
      ap elements = line.split("\t")
      article = Article.new
      article.pub_med_id = elements[0]
      article.citations_page_rank = elements[1]
      #article.save
      break if i == 100
      puts "Imported record #{i}"
    end
  end

  desc "Print document information"
  task :info => :environment do
    ap docs = PubmedApi.find('12969510')
    article.find_by_pub_med_id('12969510')

  end

end
