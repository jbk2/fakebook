# Note - there are only 10 profile photos in assets currently
def create_users(no_of_users)
  no_of_users.times do |i|
    user = User.create(email: "#{i + 1}@test.com", password: "Password12!", username: "user_#{i + 1}")
    puts "created user no #{i + 1}"

    if user.persisted?
      image_path = Rails.root.join('app', 'assets', 'images', 'profile_photos', "profile_#{i + 1}.jpg")
      if File.exist?(image_path)
        user.profile_photo.attach(
          io: File.open(image_path),
          filename: "profile_#{i + 1}.jpg",
          content_type: "image/jpg"
        )
        puts "saving user no #{i + 1} image"
      else
        puts "Image file does not exist: #{image_path}"
      end
    end
  end
end

create_users(10)

def create_posts(no_of_posts, user_id)
  user = User.find(user_id)

  no_of_posts.times do |i|
    post = user.posts.create(body: Faker::Lorem.paragraph(sentence_count: rand(1..6)))
  
    if post.persisted?
      puts "created post no #{i + 1} for user #{user_id}"
      image_nos = (1..24).to_a.sample(rand(1..6))
      images = []
      
      image_nos.each do |n|
        image_path = Rails.root.join('app', 'assets', 'images', 'post_photos', "post_#{n}.jpg")
        if File.exist?(image_path)
          images << {
            io: File.open(image_path),
            filename: "post_#{n}.jpg",
            content_type: "image/jpg"
          }
        else
          puts "Image file does not exist: #{image_path}"
        end
      end

      post.photos.attach(images) if images.any?
    end
  end
end

User.all.each do |user|
  create_posts(rand(3..6), user.id)
  followed_user_ids = (1..10).to_a.sample(5)
  followed_user_ids.each do |id|
    Follow.create(follower_id: user.id, followed_id: id)
  end
end
