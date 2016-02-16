namespace :stage_common_options do
  desc "既存のStageOrderから共通項目をStageCommonOptionに移行"

  task copy: :environment do
    # 各グループのStageOrderの1日目晴れの情報をStageCommonOptionへコピー
    groups = Group.where(group_category_id: 3)

    groups.each{ |group|
      stage_order = StageOrder.where(group_id: group.id).first # 配列で返ってくるので .first で先頭要素を取得
      option = StageCommonOption.new({ group_id: stage_order.group_id,
      								   own_equipment: stage_order.own_equipment,
		      						   bgm: stage_order.bgm,
		      						   camera_permittion: stage_order.camera_permittion,
		      						   loud_sound: stage_order.loud_sound,
		      						   stage_content: 'NO DATA' }) if (StageCommonOption.where(group_id: group.id) == []) # データが存在しない場合実行
      
      option.save if (StageCommonOption.where(group_id: group.id) == [])
    }
  end
end
