class Article < ActiveRecord::Base
  attr_accessible :citations_page_rank, :pub_med_id
  # Instance methods
  attr_accessor :name, :size
end
