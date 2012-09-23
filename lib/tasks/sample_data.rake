namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
  make_users
  make_microposts
  make_relationships
  end
end


  def make_users
    admin = User.create!(name: "Example User",
                         email: "example@railstutorial.org",
                         password: "foobar",
                         password_confirmation: "foobar")
    admin.toggle!(:admin)
    99.times do |n|
      name  = Faker::Name.name
      email = "example-#{n+1}@railstutorial.org"
      password  = "password"
      User.create!(name: name,
                   email: email,
                   password: password,
                   password_confirmation: password)
    end
  end

  def make_microposts
    users = User.all(limit:6)
    50.times do
      content = Faker::Lorem.sentence(5)
      users.each { |user| user.microposts.create!(content: content) }
    end
  end

  def make_relationships
    users = User.all
    user = users.first
    followed_users = users[2..50]
    followers      = users[3..40]
    # 1 follows 2..5
    followed_users.each do |followed|
      user.follow!(followed)
    end
    # 3..40 follows 1
    followers.each { |follower| follower.follow!(user)}
  end