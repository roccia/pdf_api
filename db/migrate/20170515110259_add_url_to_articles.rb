class AddUrlToArticles < ActiveRecord::Migration[5.0]
  def change
    add_column :articles, :url, :text
  end
end
