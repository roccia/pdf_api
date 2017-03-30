class CreateCnInfos < ActiveRecord::Migration[5.0]
  def change
    create_table :cn_infos do |t|
      t.text :industry
      t.text :plate
      t.text :category
      t.text :company_name
      t.text :company_code
      t.text :url
      t.text :title
      t.text :context

      t.timestamps
    end
  end
end
