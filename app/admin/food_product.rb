ActiveAdmin.register FoodProduct do

  permit_params :group_id, :name, :num, :is_cooking, :start

  index do
    selectable_column
    id_column
    column :group
    column :name
    column :num
    # column :ingredients do |ingredient|
    #   if not ingredient.purchase_list.empty?
    #     ingredient.purchase_list.map { |food| food.items }.join(',')
    #   end
    # end
    column :ingredients do |ingredient|
      if not ingredient.purchase_list.empty?
        ingredient.purchase_list.first.shop
      end
    end
    column :shops do |shop|
      if not shop.purchase_list.empty?
        shop.purchase_list.first.shop
      end
    end
    column :buy_dates do |buy_date|
      if not buy_date.purchase_list.empty?
        buy_date.purchase_list.first.fes_date
      end
    end
    column :is_cooking
    column :start
    actions
  end
end
