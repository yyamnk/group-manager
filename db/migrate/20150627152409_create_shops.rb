class CreateShops < ActiveRecord::Migration
  def change
    create_table :shops do |t|
      t.string :name, null: false
      t.string :tel, null: false
      t.string :time_weekdays
      t.string :time_sat
      t.string :time_sun
      t.string :time_holidays

      t.timestamps null: false
    end
  end
end
