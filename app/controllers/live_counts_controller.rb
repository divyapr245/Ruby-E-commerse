class LiveCountsController < ApplicationController
  include ActionController::Live  # Enables live streaming

  def live_logins
    response.headers["Content-Type"] = "text/event-stream"
    redis = Redis.new

    begin
      loop do
        login_count = redis.get("user_login_count") || 0
        response.stream.write "data: #{login_count}\n\n"
        sleep 15000  # Sends an update every 5 seconds
      end
    rescue IOError
      Rails.logger.info "Stream closed"
    ensure
      response.stream.close
    end
  end
end
