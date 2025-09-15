class ChatRequestNotificationsController < ApplicationController
  before_action :authorize_request

  def index 
    chat_notification = @current_user.chat_request_notifications.where(read: false).order(created_at: :desc)
    render json:  chat_notification, each_serializer:ChatRequestNotificationsSerializer
    rescue => e
      render json: {error: e.message}, status: :unprocessable_entity
  end
end
