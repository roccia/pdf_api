class AddTitleToArticles < ActiveRecord::Migration[5.0]
  def change
    add_column :articles, :title, :text
  end
end
