class ChatsChannel < ApplicationCable::Channel
  def subscribed
    sender_id = params[:sender_id]
    recipient_id = params[:recipient_id]

    # Stream both ways, so both participants receive messages
    stream_from "chat_#{sender_id}#{recipient_id}"
    stream_from "chat_#{recipient_id}#{sender_id}"
  end

  def unsubscribed
    stop_all_streams
  end
end
