class CreateConfigWelcomeIndices < ActiveRecord::Migration
  def change
    create_table :config_welcome_indices do |t|
      t.string :name, null: false
      t.string :panel_partial, null: false
      t.boolean :enable_show, default: false

      t.timestamps null: false
    end
  end
end
