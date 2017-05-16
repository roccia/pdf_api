class AddArticleIdToCnInfos < ActiveRecord::Migration[5.0]
  def change
    add_column :cn_infos, :article_id, :integer
  end
end
