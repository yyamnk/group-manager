class CreateStageOrders < ActiveRecord::Migration
  def change
    create_table :stage_orders do |t|
      t.references :group, index: true, foreign_key: true
      t.boolean :is_sunny
      t.references :fes_date, index: true, foreign_key: true
      t.integer :stage_first
      t.integer :stage_second
      t.string :time
      t.boolean :own_equipment
      t.boolean :bgm
      t.boolean :camera_permittion
      t.boolean :loud_sound

      t.timestamps null: false
    end
  end
end
