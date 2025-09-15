class MessageNotificationChannel < ApplicationCable::Channel
  def subscribed
    current_user = params[:current_user]
    stream_from "message_notification_#{current_user}"
    # stream_from "some_channel"
  end

  def unsubscribed
    stop_all_streams
    # Any cleanup needed when channel is unsubscribed
  end
end
