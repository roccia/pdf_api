class AddReportDateToArticles < ActiveRecord::Migration[5.0]
  def change
    add_column :articles, :report_date, :string
  end
end
