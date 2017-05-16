class CreateArticles < ActiveRecord::Migration[5.0]
  def change
    create_table :articles do |t|
      t.text :content ,limit: 4294967295
      t.timestamps
    end
  end
end
