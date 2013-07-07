class Article < ActiveRecord::Base
  attr_accessible :citations_page_rank, :pub_med_id, :title, :date, :source, :url, :db, :authors
  # Instance methods
  attr_accessor :name, :size
end
