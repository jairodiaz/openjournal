class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :pub_med_id
      t.float :citations_page_rank

      t.timestamps
    end
  end
end
