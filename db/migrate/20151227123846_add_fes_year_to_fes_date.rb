class AddFesYearToFesDate < ActiveRecord::Migration
  def change
    add_reference :fes_dates, :fes_year, index: true, foreign_key: true
  end
end
