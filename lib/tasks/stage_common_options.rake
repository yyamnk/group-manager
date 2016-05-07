namespace :stage_common_options do
  desc "既存のStageOrderから共通項目をStageCommonOptionに移行"

  task copy: :environment do
    # 各グループのStageOrderの1日目晴れの情報をStageCommonOptionへコピー
    groups = Group.where(group_category_id: 3)

    groups.each{ |group|
      stage_order = StageOrder.find_by(group_id: group.id)
      unless StageCommonOption.exists?(group_id: group.id)
        option = StageCommonOption.new(
          group_id: stage_order.group_id,
          own_equipment: stage_order.own_equipment || false,
          bgm: stage_order.bgm || false,
          camera_permittion: stage_order.camera_permittion || false,
          loud_sound: stage_order.loud_sound || false,
          stage_content: 'NO DATA'
        )
        if option.save
          puts('group: ' + option.group.name + ' is saved.')
        end
      end
    }
  end
end