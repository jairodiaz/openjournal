require 'awesome_print'
require 'open-uri'

namespace :publication do

  desc "Importing page_rank data on the server"
  task :import => :environment do

    file = "./test/fixtures/page_rank_test_data.txt" if Rails.env.development?
    file = "http://jairodiaz.co/ranker_pagerank.txt" if Rails.env.production?

    i = 0
    open(file).each_line do |line|
      i += 1
      elements = line.split("\t")
      article = Article.new
      article.pub_med_id = elements[0]
      article.citations_page_rank = elements[1]
      article.save
      break if i == 100
      puts "Imported record #{i}"
    end
  end

end
