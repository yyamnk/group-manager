namespace :change_stage_weather_columns do
  desc "既存のStageOrderからStageの重複データを取り除く"

  task delete_stage_all_records: :environment do
    Stage.delete_all
  end
  task copy: :environment do
    groups = Group.where(group_category_id: 3)

    groups.each{ |group|
      stage_order = StageOrder.where(group_id: group.id)
      if StageOrder.exists?(group_id: group.id)
        stage_order.each do |order|
          next if order.stage_first==nil && order.stage_second==nil
          stage = "before:\t first:#{order.stage_first}, second:#{order.stage_second} =>\t"

          replaced_stages = replace_stage(order.stage_first, order.stage_second)
          next if replaced_stages.nil?

          # 重複したStage_idを参照するレコードを修正(validateを無視)
          order.update_attribute(:stage_first     , replaced_stages[:first])
          order.update_attribute(:stage_second    , replaced_stages[:second])
          order.update_attribute(:time_point_start, time_nil?(order.time_point_start))
          order.update_attribute(:time_point_end  , time_nil?(order.time_point_end))
          order.update_attribute(:time_interval   , time_nil?(order.time_interval))

          puts "group_id: #{group.id}\t" + "order_id: #{order.id}\t" 
          puts stage + "ofter:\t first:#{order.stage_first}, second:#{order.stage_second}"
          puts "---------------------------------------------------"
        end
      end
    }
  end

  def replace_stage(first, second)
    return nil if (first.class != Fixnum || second.class !=Fixnum)
    # 2度目の実行でデータが破壊されるのを防ぐ
    return nil if (first<5||second<5) 

    r_first   = exchager(first)
    r_second  = exchager(second)
    return {first: r_first, second: r_second}
  end

  def exchager(stage_id)
    return 3 if stage_id==5
    return 4 if stage_id==6
    return 5 if stage_id==7
    stage_id
  end

  def time_nil?(time)
    return time.nil? ? "未回答" : time
  end
end
