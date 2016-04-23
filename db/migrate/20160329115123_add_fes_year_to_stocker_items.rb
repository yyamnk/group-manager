class AddFesYearToStockerItems < ActiveRecord::Migration
  def change
    add_reference :stocker_items, :fes_year, index: true, foreign_key: true
  end
end
