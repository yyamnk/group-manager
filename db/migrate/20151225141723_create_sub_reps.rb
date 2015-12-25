class CreateSubReps < ActiveRecord::Migration
  def change
    create_table :sub_reps do |t|
      t.references :group, index: true, foreign_key: true, null: false
      t.string :name_ja, null: false
      t.string :name_en, null: false
      t.references :department, index: true, foreign_key: true, null: false
      t.references :grade, index: true, foreign_key: true, null: false
      t.string :tel, null: false
      t.string :email, null: false

      t.timestamps null: false
    end
  end
end
