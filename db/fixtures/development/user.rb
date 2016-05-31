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

users.each do |u|
    user = User.new(u)
    user.skip_confirmation!
    user.save(:validate=>false)
end
