module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
      mark_user_online
    end
    
    def disconnect
      mark_user_offline
    end

    def mark_user_online
      REDIS_CLIENT.hmset("presence:#{current_user.id}", "status", "online", "last_active_at", Time.now.to_i)
    end

    def mark_user_offline
      REDIS_CLIENT.hmset("presence:#{current_user.id}", "status", "offline", "last_active_at", Time.now.to_i)
    end

    private 

    def find_verified_user
      token = request.params[:token]
      token_data = JsonWebToken.decode(token) rescue nil
      if token_data && (verified_user = Account.find_by(id: token_data[:user_id]))
        verified_user
      else
        reject_unauthorized_connection
      end
    end
  end
end
