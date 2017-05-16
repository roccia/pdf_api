class AddPageNumToCnInfos < ActiveRecord::Migration[5.0]
  def change
    add_column :cn_infos, :page_num, :integer
  end
end
