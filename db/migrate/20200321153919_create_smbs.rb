class CreateSmbs < ActiveRecord::Migration[6.0]
  def change
    create_table :smbs do |t|
      t.string :name, null: false
      t.string :description, null: false
      t.string :phone, null: false
      t.boolean :active
      t.decimal :lat, {:precision=>10, :scale=>6}
      t.decimal :lng, {:precision=>10, :scale=>6}

      t.timestamps
    end
  end
end
