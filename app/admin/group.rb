ActiveAdmin.register Group do

  permit_params :user_id, :name, :group_category_id, :activity, :first_question,
                :fes_year_id

  index do
    selectable_column
    id_column
    column :fes_year
    column :user
    column :name
    column :group_category
    column :activity
    column :created_at
    actions
  end

  csv do
    column :id
    column :fes_year
    column :user do |group|
      group.user.user_detail.name_ja
    end
    column :user do |group|
      group.user.user_detail.name_en
    end
    column :name
    column :group_category do |group|
      group.group_category.name_ja
    end
    column :activity
    column :created_at
    column :updated_at
  end
end
