class RemoveColumnFromCnInfos < ActiveRecord::Migration[5.0]
  def change
    remove_column :cn_infos, :company_name
    remove_column :cn_infos, :company_code
    remove_column :cn_infos, :industry
    remove_column :cn_infos, :plate
    remove_column :cn_infos, :category
    remove_column :cn_infos, :url
    remove_column :cn_infos, :title
    remove_column :cn_infos, :report_date
    remove_column :cn_infos, :article_id
  end
end
