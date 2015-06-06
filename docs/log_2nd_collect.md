# 第二回募集にむけたアップデート

## 物品貸出の募集をする

モデル生成

```
# 貸出物品
bundle exec rails g model rentalItem name_ja:string name_en:string
      invoke  active_record
      create    db/migrate/20150605080243_create_rental_items.rb
      create    app/models/rental_item.rb

# 貸出物品が選択可能な団体のカテゴリ
bundle exec rails g model rentalItemAllowList rental_item:references group_category:references
      invoke  active_record
      create    db/migrate/20150605081834_create_rental_item_allow_lists.rb
      create    app/models/rental_item_allow_list.rb

# モデル初期データ投入
rake db:seed_fu

== Seed from /Volumes/Data/Dropbox/nfes15/group_manager/db/fixtures/rental_item.rb
 - RentalItem {:id=>1, :name_ja=>"机", :name_en=>"table"}
 - RentalItem {:id=>2, :name_ja=>"長机", :name_en=>"long table"}
 - RentalItem {:id=>3, :name_ja=>"椅子", :name_en=>"chair"}
 - RentalItem {:id=>4, :name_ja=>"パイプ椅子", :name_en=>"pipe chair"}
 - RentalItem {:id=>5, :name_ja=>"パーテーション", :name_en=>"partition"}
 - RentalItem {:id=>6, :name_ja=>"掲示板", :name_en=>"bulletin board"}
 - RentalItem {:id=>7, :name_ja=>"暗幕", :name_en=>"black curtain"}
 - RentalItem {:id=>8, :name_ja=>"マイク", :name_en=>"microphone"}

== Seed from /Volumes/Data/Dropbox/nfes15/group_manager/db/fixtures/rental_item_allow_list.rb
 - RentalItemAllowList {:id=>1, :rental_item_id=>1, :group_category_id=>1}
 - RentalItemAllowList {:id=>2, :rental_item_id=>1, :group_category_id=>2}
 - RentalItemAllowList {:id=>3, :rental_item_id=>1, :group_category_id=>4}
 - RentalItemAllowList {:id=>4, :rental_item_id=>1, :group_category_id=>5}
 - RentalItemAllowList {:id=>5, :rental_item_id=>2, :group_category_id=>1}
 - RentalItemAllowList {:id=>6, :rental_item_id=>2, :group_category_id=>2}
 - RentalItemAllowList {:id=>7, :rental_item_id=>2, :group_category_id=>4}
 - RentalItemAllowList {:id=>8, :rental_item_id=>2, :group_category_id=>5}
 - RentalItemAllowList {:id=>9, :rental_item_id=>3, :group_category_id=>1}
 - RentalItemAllowList {:id=>10, :rental_item_id=>3, :group_category_id=>2}
 - RentalItemAllowList {:id=>11, :rental_item_id=>3, :group_category_id=>3}
 - RentalItemAllowList {:id=>12, :rental_item_id=>3, :group_category_id=>4}
 - RentalItemAllowList {:id=>13, :rental_item_id=>3, :group_category_id=>5}
 - RentalItemAllowList {:id=>14, :rental_item_id=>4, :group_category_id=>1}
 - RentalItemAllowList {:id=>15, :rental_item_id=>4, :group_category_id=>2}
 - RentalItemAllowList {:id=>16, :rental_item_id=>4, :group_category_id=>3}
 - RentalItemAllowList {:id=>17, :rental_item_id=>4, :group_category_id=>4}
 - RentalItemAllowList {:id=>18, :rental_item_id=>4, :group_category_id=>5}
 - RentalItemAllowList {:id=>19, :rental_item_id=>5, :group_category_id=>1}
 - RentalItemAllowList {:id=>20, :rental_item_id=>5, :group_category_id=>2}
 - RentalItemAllowList {:id=>21, :rental_item_id=>5, :group_category_id=>3}
 - RentalItemAllowList {:id=>22, :rental_item_id=>5, :group_category_id=>4}
 - RentalItemAllowList {:id=>23, :rental_item_id=>5, :group_category_id=>5}
 - RentalItemAllowList {:id=>24, :rental_item_id=>6, :group_category_id=>1}
 - RentalItemAllowList {:id=>25, :rental_item_id=>6, :group_category_id=>2}
 - RentalItemAllowList {:id=>26, :rental_item_id=>6, :group_category_id=>4}
 - RentalItemAllowList {:id=>27, :rental_item_id=>6, :group_category_id=>5}
 - RentalItemAllowList {:id=>28, :rental_item_id=>7, :group_category_id=>1}
 - RentalItemAllowList {:id=>29, :rental_item_id=>7, :group_category_id=>2}
 - RentalItemAllowList {:id=>30, :rental_item_id=>7, :group_category_id=>4}
 - RentalItemAllowList {:id=>31, :rental_item_id=>7, :group_category_id=>5}
 - RentalItemAllowList {:id=>32, :rental_item_id=>8, :group_category_id=>3}
```

Scoffoldで貸出物品のCURDを生成

```
# 貸出物品の希望調査
bundle exec rails g scaffold rentalOrder group:references rental_item:references num:integer
rake db:migrate
```

物品貸出用のリンクをDashboardに追加．
app/views/welcome_inedxを修正．
