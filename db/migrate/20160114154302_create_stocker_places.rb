class CreateStockerPlaces < ActiveRecord::Migration
  def change
    create_table :stocker_places do |t|
      t.string :name, null: false
      t.boolean :is_available_fesdate, null: false, default: false

      t.timestamps null: false
    end
  end
end
