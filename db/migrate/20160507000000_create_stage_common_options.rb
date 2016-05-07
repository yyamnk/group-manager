class CreateStageCommonOptions < ActiveRecord::Migration
  def change
    create_table :stage_common_options do |t|
      t.references :group, index: true, foreign_key: true, null: false
      t.boolean :own_equipment
      t.boolean :bgm
      t.boolean :camera_permittion
      t.boolean :loud_sound
      t.text :stage_content, null: false

      t.timestamps null: false
    end
  end
end