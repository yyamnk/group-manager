namespace :change_columns_config_user_permission do

  task delete_record: :environment do
    ConfigUserPermission.delete_all
  end
end
