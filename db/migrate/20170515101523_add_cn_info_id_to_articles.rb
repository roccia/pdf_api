class AddCnInfoIdToArticles < ActiveRecord::Migration[5.0]
  def change
    add_column :articles, :cn_info_id, :integer
  end
end
