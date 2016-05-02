users = [{
     :email=>"admin@nutfes.com",
     :role=>Role.find(1),
     :password=>"nutfes",
     :password_confirmation=>"nutfes"
 },
 {
     :email=>"developer@nutfes.com",
     :role=>Role.find(2),
     :password=>"",
     :password_confirmation=>"nutfes"
 }, {
     :email=>"user1@nutfes.com",
     :role=>Role.find(3),
     :password=>"nutfes",
     :password_confirmation=>"nutfes"
 },{
     :role=>Role.find(3),
     :email=>"user2@nutfes.com",
     :password=>"nutfes",
     :password_confirmation=>"nutfes"
 },
]

detail_example = {
    :name_en  => "Taro GIDAI",
    :name_ja  => "技大太郎",
    :department_id => 2,
    :grade_id => 2,
    :tel => "111-0000-9999",
}

users.each do |u|
    user = User.find_by(email: u[:email])
    if user
        user.email = u[:email]
        user.role = u[:role]
        user.password = u[:password]
        user.password_confirmation = u[:password_confirmation]
        user.save(:validate=>false)
    else
        user = User.new(u) 
        user.skip_confirmation!
        user.save(:validate=>false)
    end
end
