ActiveAdmin.register PlaceAllowList do

  # permit_params :enable,:group_category_id,:place

  permit_params do 
    params = [:enable] 
    params.concat [:group_category_id, :place_id] if current_user.role_id==1
    params
  end

  index do
    id_column
    column :group_category_id do |order|
      order.group_category
    end
    column :place
    column :enable

    actions
  end

  form do |f|
    inputs '場所を許可/不許可' do
      if current_user.role_id==1 then
        input :group_category
        input :place
      end
      input :enable
    end
    f.actions
  end

end
