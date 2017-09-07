class AddErrorInfoToArticles < ActiveRecord::Migration[5.0]
  def change
    add_column :articles, :error_info, :text
  end
end
