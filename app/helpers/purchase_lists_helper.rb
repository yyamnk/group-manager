module PurchaseListsHelper

  def show_new_noncooking(fesdate)
    # 保存食品はいつでも買える
    food_product = FoodProduct.find_by(group_id: @groups.first.id)
    # createが許可された場合のみNewボタンを表示する
    if @ability.can?(:create, PurchaseList.new(food_product_id: food_product.id))
      return link_to "#{fesdate.date}" + 'に購入する提供品を追加',
        new_noncooking_purchase_lists_path(fes_date_id: fesdate.id),  # 提供品
        :class => 'btn btn-primary'
    end
  end

  def show_new_nonfresh(fesdate)
    # 保存食品はいつでも買える
    food_product = FoodProduct.find_by(group_id: @groups.first.id)
    # createが許可された場合のみNewボタンを表示する
    if @ability.can?(:create, PurchaseList.new(food_product_id: food_product.id))
      return link_to "#{fesdate.date}" + 'に購入する保存食品を追加',
        new_cooking_purchase_lists_path(is_fresh: false, fes_date_id: fesdate.id), # 保存食品
        :class => 'btn btn-primary'
    end
  end

  def show_new_fresh(fesdate)
    return if fesdate.days_num == 0  # 準備日に生鮮食品は買えない

    food_product = FoodProduct.find_by(group_id: @groups.first.id)
    # createが許可された場合のみNewボタンを表示する
    if @ability.can?(:create, PurchaseList.new(food_product_id: food_product.id))
      return link_to "#{fesdate.date}" + 'に使用する生鮮食品を追加',
        new_cooking_purchase_lists_path(is_fresh: true, fes_date_id: fesdate.id), # 生鮮食品
        :class => 'btn btn-primary'
    end
  end
end
