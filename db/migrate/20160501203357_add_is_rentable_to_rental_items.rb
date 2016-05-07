class AddIsRentableToRentalItems < ActiveRecord::Migration
  def change
    add_column :rental_items, :is_rentable, :boolean, :default => true, null:false
  end
end
