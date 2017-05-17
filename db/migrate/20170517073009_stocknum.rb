class Stocknum < ActiveRecord::Migration[5.0]
  def change
    change_column :cn_infos, :stock_num, :string
  end
end
