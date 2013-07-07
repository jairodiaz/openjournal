class AddTitleDateSourceUrlDbAuthors < ActiveRecord::Migration
  def change
     add_column :articles, :title, :string
     add_column :articles, :date, :date
     add_column :articles, :source, :string
     add_column :articles, :url, :string
     add_column :articles, :authors, :string
  end
end
