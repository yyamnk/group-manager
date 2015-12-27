namespace :set_year_to_groups do
  desc "既存の団体の年度を設定"

  task set_2015: :environment do
    # 全団体を2015年に紐付け
    groups = Group.all
    year = FesYear.where(fes_year: 2015).first

    groups.each{ |group|
      group.fes_year_id = year.id
      group.save
    }
  end
end
