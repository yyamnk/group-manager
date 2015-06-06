namespace :rental_orders do

  task generate_for_preexist: :environment do
    groups = Group.all
    items = RentalItem.all

    groups.each{ |group|
      items.each{ |item|
        order = RentalOrder.new( group_id: group.id, rental_item_id: item.id, num: 0 )
        order.save # 新規追加のみ
      }
    }
  end
end
