class AddCompanyNameToArticles < ActiveRecord::Migration[5.0]
  def change
    add_column :articles, :company_name, :text
  end
end
