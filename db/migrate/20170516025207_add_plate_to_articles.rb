class AddPlateToArticles < ActiveRecord::Migration[5.0]
  def change
    add_column :articles, :plate, :text
  end
end
