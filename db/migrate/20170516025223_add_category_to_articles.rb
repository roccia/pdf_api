class AddCategoryToArticles < ActiveRecord::Migration[5.0]
  def change
    add_column :articles, :category, :text
  end
end
