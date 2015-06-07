namespace :stage_orders do
  task generate_for_preexist: :environment do
    groups = Group.where( group_category_id: 3) # ステージ企画の団体
    # 必要な4パターンを生成する
    groups.each{ |group|
      group.init_stage_order
    }
  end
end
