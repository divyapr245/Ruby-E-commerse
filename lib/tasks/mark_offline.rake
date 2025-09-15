# lib/tasks/mark_offline.rake
namespace :presence do
  task mark_offline: :environment do
    keys = REDIS_CLIENT.keys("presence:*")
    keys.each do |key|
      data = REDIS_CLIENT.hgetall(key)
      last_active = data["last_active_at"].to_i
      status = data["status"]
      room_id = data["room_id"]
      another_user_id = data["user_id"]
      if Time.now.to_i - last_active > 30 && status == "online"
        REDIS_CLIENT.hmset(key, "status", "offline")
        user_id = key.split(":").last
        puts "User #{user_id} is offline and last active was #{last_active} seconds ago"
        ActionCable.server.broadcast("presence_status_#{room_id}", {user_id: user_id, status: "offline" })
        ActionCable.server.broadcast("user_#{another_user_id}", {type: "UserStatus", user_id: user_id, current_status: 'offline' })
      end
    end
  end
end
  