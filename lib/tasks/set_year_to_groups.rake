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

  # テストデータを隠蔽する(10001年に紐付け)
  task hide_test_data: :environment do
    test_group = Group.joins(:user).where( \
                   groups: {fes_year_id: FesYear.this_year.id}) \
                    .where(users: {role_id: (1..2)})
    
    test_group.update_all(fes_year_id: 100)
  end

end
