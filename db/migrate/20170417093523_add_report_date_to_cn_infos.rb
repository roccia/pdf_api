class AddReportDateToCnInfos < ActiveRecord::Migration[5.0]
  def change
    add_column :cn_infos, :report_date, :string
  end
end
