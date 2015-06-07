namespace :place_order do

  task generate_for_preexist: :environment do
    groups = Group.all # 全ての既存団体で

    groups.each{ |group|
      group.init_place_order # 実行
    }
  end

end
