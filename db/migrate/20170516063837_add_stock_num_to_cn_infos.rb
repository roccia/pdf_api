class AddStockNumToCnInfos < ActiveRecord::Migration[5.0]
  def change
    add_column :cn_infos, :stock_num, :integer
  end
end
