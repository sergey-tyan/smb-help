class AddCategoryToSmb < ActiveRecord::Migration[6.0]
  def change
    change_table :smbs do |t|
      t.string :category, null: false
    end
    
  end
end
