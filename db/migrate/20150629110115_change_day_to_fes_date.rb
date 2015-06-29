class ChangeDayToFesDate < ActiveRecord::Migration
  def change
    change_column_null :fes_dates, :day, false
  end
end
