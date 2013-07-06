class AddIndexToArticles < ActiveRecord::Migration
 def self.up
    add_index :articles, :citations_page_rank
  end

  def self.down
    remove_index :articles, :column => :citations_page_rank
  end
end
