UserDetail.seed( :id,
{   id: 10000010,
    user_id: User.where(:email => 'admin@nutfes.com').first.id,  # 上のidに対応
    name_en: "Taro GIDAI admin",
    name_ja: "技大太郎 (admin)",
    department_id: 2,
    grade_id: 2,
    tel: "111-0000-9999",
},
{   id: 10000011,
    user_id: User.where(:email => 'developer@nutfes.com').first.id,  # 上のidに対応
    name_en: "Taro GIDAI admin",
    name_ja: "技大太郎 (admin)",
    department_id: 2,
    grade_id: 2,
    tel: "111-0000-9999",
},
{   id: 10000012,
    user_id: User.where(:email => 'user1@nutfes.com').first.id,  # 上のidに対応
    name_en: "Taro GIDAI admin",
    name_ja: "技大太郎 (admin)",
    department_id: 2,
    grade_id: 2,
    tel: "111-0000-9999",
},{
    id: 10000013,
    user_id: User.where(:email => 'user2@nutfes.com').first.id,  # 上のidに対応
    name_en: "Taro GIDAI admin",
    name_ja: "技大太郎 (admin)",
    department_id: 2,
    grade_id: 2,
    tel: "111-0000-9999",
}
)

