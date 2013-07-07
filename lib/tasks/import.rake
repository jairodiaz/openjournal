require 'awesome_print'
require 'open-uri'
require_relative './pub_med_api.rb'

namespace :publication do

  desc "Importing page_rank data on the server from a test file"
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
      article.save
      break if i == 100 # This App is limited to 100 documents.
      puts "Imported record #{i}"
    end
  end

  desc "Retrieve publication information from the PubMed online database"
  task :retrieve_data => :environment do

    articles = Article.find(:all, :order => "citations_page_rank desc", :limit => 100)

    ids = []
    articles.inject(ids) do |result, element|
      result << element.pub_med_id
    end

    ap 'Retrieving Information for:'
    ap ids

    ap documents = PubmedApi.find(ids)

    ap 'Data found:'

    ap documents

    ap 'Saving the information:'

    documents.each do |doc|
      article = Article.find_by_pub_med_id(doc[:id])
      article.title = doc[:title].byteslice(0, 250)
      article.date = doc[:date]
      article.source = doc[:source].byteslice(0, 250)
      article.url = doc[:url].byteslice(0, 250)
      article.authors = doc[:authors].byteslice(0, 250)
      article.save
    end

  end

end
