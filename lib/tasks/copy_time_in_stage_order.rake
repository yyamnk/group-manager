namespace :copy_time_in_stage_order do
  desc "timeカラムのデータをtime_intervalカラムへコピーする"
  task copy: :environment do
    groups = Group.where(group_category_id: 3)

    groups.each{ |group|
      stage_orders = StageOrder.where(group_id: group.id)
      stage_orders.each { |stage_order|
        stage_order.time_point_start = ""
        stage_order.time_point_end = ""
        stage_order.time_interval = stage_order.time
        if stage_order.save
          puts(
            'group: ' + stage_order.group.name +
            ', day/is_sunny: ' + stage_order.fes_date_id.to_s + '/' + stage_order.is_sunny.to_s +
            ' is saved.'
          )
        end
      }
    }
  end
end
