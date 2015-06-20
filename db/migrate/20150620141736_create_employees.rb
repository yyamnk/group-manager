class CreateEmployees < ActiveRecord::Migration
  def change
    create_table :employees do |t|
      t.references :group, index: true, foreign_key: true
      t.string :name, null: false
      t.integer :student_id, null: false
      t.references :employee_category, index: true, foreign_key: true
      t.boolean :duplication

      t.timestamps null: false
    end
  end
end
