class AddCompanyCodeToArticles < ActiveRecord::Migration[5.0]
  def change
    add_column :articles, :company_code, :text
  end
end
