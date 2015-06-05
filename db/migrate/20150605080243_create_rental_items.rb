class CreateRentalItems < ActiveRecord::Migration
  def change
    create_table :rental_items do |t|
      t.string :name_ja, null: false, unique: true
      t.string :name_en

      t.timestamps null: false
    end
  end
end
