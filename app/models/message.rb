class Message < ApplicationRecord
  include ActionView::RecordIdentifier
  belongs_to :user
  belongs_to :chatroom
  after_create_commit -> {
    broadcast_append_to chatroom,
      target: dom_id(chatroom, :messages),
      partial: "messages/message",
      locals: { message: self }
  }
end
