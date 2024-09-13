class CreateTiffins < ActiveRecord::Migration[7.0]
  def change
    create_table :tiffins do |t|
      t.date :start_date
      t.date :date
      t.integer :status

      t.timestamps
    end
    add_column :tiffins, :customer_id, :integer
    add_foreign_key :tiffins, :customers
  end
end
