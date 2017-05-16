class ChangeCninfos < ActiveRecord::Migration[5.0]
  def change
    change_column :cn_infos, :context, :text ,limit: 4294967295
  end
end
