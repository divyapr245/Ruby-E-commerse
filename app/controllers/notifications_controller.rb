class NotificationsController < ApplicationController
  before_action :authorize_request

  def get_unread_notifications 
    unread_notifications = @current_user.notifications.unread.where(type: "OrderNotification")
    render json: {unread_notification: unread_notifications}, status: :ok
  end

  def update_notification 
    ids = params[:ids].split(',')
    notifications = Notification.where(id: ids)
    if notifications.update(read: true)
      render json: {message: "Notification updated successfully"}, status: 200
    else 
      render json: {error: "Can't Update Notificatins"}, status: 400
    end
  end
end
