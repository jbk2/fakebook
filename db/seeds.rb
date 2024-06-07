# Note - there are only 10 profile photos in assets currently
def create_users(no_of_users)
  no_of_users.times do |i|

    # Avoiding the Devise controller with #create to stop mailers for seed user creation
    user = User.new(
      email: "#{i + 1}@test.com",
      password: "Password12!",
      username: "user_#{i + 1}"
    )
    user.skip_confirmation! if user.respond_to?(:skip_confirmation!)  # Skip confirmation if you have confirmable module enabled
    user.save(validate: false)  # Consider whether you want to skip validations
    puts "saved user no #{i + 1}"

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

def create_posts(no_of_posts, user_id)
  user = User.find(user_id)
  
  no_of_posts.times do |i|
    post = user.posts.create(body: Faker::Lorem.paragraph(sentence_count: rand(1..6)))
    
    if post.persisted?
      puts "created post no #{i + 1} for user #{user_id}"
      image_nos = (1..24).to_a.sample(rand(1..4))
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
      
      post.photos.each do |photo|
        ProcessImageJob.perform_later(photo.blob.id)
      end
    end
  end
end

def create_follows(user)
  no_of_follows = User.all.count / 3
  users_to_follow = User.all.sample(no_of_follows)
  users_to_follow.each do |follow|
    
    follow = Follow.create(follower_id: user.id, followed_id: follow.id)
    puts "created follow_id#{follow.id} for user_id##{user.id}"
  end
end

def create_conversations(user)
  no_of_convos = User.all.count / 3
  users_to_converse_with = User.all.sample(no_of_convos)
  user_existing_convos = Conversation.where(participant_two_id: user.id)

  unless user_existing_convos.empty?
    user_existing_convos.each do |convo|
      users_to_converse_with.delete(convo.participant_one_id)
    end
  end
  
  unless users_to_converse_with.empty?
    users_to_converse_with.each do |participant_two|
      conversation = Conversation.create(participant_one_id: user.id, participant_two_id: participant_two.id)
      puts "created conversation_id#{conversation.id} for user_id##{user.id}"
    end
  end
end

def create_messages(user)
  user.conversations.each do |convo|
    no_of_messages_from_user = rand(2..6)
    no_of_messages_to_user = rand(2..6)
    
    no_of_messages_from_user.times do
      create_message(user.id, convo.id)
    end
    
    no_of_messages_to_user.times do
      create_message(convo.other_participant(user).id, convo.id)
    end
  end
end

def create_message(sender_id, conversation_id)
  message = Message.create(
    body: Faker::Lorem.sentence(word_count: rand(3..7)),
    user_id: sender_id,
    conversation_id: conversation_id
  )
  message.skip_broadcast = true
  message.save
  puts "created message_id#{message.id} for sender_id##{sender_id} in conversation_id##{conversation_id}"
end


create_users(10)

User.all.each do |user|
  create_posts(rand(3..6), user.id)
  create_follows(user)
  create_conversations(user)
  create_messages(user)  
end