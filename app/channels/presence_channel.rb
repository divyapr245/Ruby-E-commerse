class PresenceChannel < ApplicationCable::Channel
  def subscribed
    room_id = params[:room_id]
    user_id = params[:user_id]
    stream_from "presence_status_#{room_id}"
    ActionCable.server.broadcast("presence_status_#{room_id}", { user_id: current_user.id, status: 'online' })
    ActionCable.server.broadcast("user_#{user_id}", {type: "UserStatus", user_id: current_user.id, current_status: 'online' })
    REDIS_CLIENT.hmset("presence:#{current_user.id}", "status", "online", "last_active_at", Time.now.to_i, "room_id", room_id, "user_id", user_id)
  end
  
  def receive(data)
    if data["type"] == "heartbeat"
      puts(current_user.id)
      REDIS_CLIENT.hmset("presence:#{current_user.id}", "status", "online", "last_active_at", Time.now.to_i, "room_id", data["room_id"], "user_id", data["user_id"])
    end
  end

  def unsubscribed
    user_id = params[:user_id]
    room_id = params[:room_id]
    REDIS_CLIENT.hmset("presence:#{current_user.id}", "status", "offline", "last_active_at", Time.now.to_i, "room_id", room_id, "user_id", user_id)
    ActionCable.server.broadcast("user_#{user_id}", {type: "UserStatus", user_id: current_user.id, current_status: 'offline' })
  end
end
