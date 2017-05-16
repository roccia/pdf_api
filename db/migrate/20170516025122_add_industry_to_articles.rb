class AddIndustryToArticles < ActiveRecord::Migration[5.0]
  def change
    add_column :articles, :industry, :text
  end
end
