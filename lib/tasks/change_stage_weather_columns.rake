namespace :change_stage_weather_columns do
  desc "既存のStageOrderからStageの重複データを取り除く"

  task delete_stage_all_records: :environment do
    Stage.delete_all
  end
end
