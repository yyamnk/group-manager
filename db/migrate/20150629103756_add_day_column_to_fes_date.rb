class AddDayColumnToFesDate < ActiveRecord::Migration
  def change
    add_column :fes_dates, :day, :string
  end
end
