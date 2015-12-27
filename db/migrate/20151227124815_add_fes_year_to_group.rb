class AddFesYearToGroup < ActiveRecord::Migration
  def change
    add_reference :groups, :fes_year, index: true, foreign_key: true
  end
end
