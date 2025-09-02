class PresenceRoster
  ACTIVE_WINDOW = 5.minutes
  IDLE_WINDOW   = 30.minutes

  class << self
    def build(chatroom_id)
      user_ids = $redis.smembers("presence:room:#{chatroom_id}:users")
      return [ User.none, User.none ] if user_ids.empty?

      now = Time.current.to_i
      active_ids = []
      idle_ids   = []

      user_ids.each do |uid|
        last_seen = $redis.get("presence:room:#{chatroom_id}:user:#{uid}:last_seen")
        next unless last_seen

        seconds = now - last_seen.to_i
        if seconds <= ACTIVE_WINDOW
          active_ids << uid
        elsif seconds <= IDLE_WINDOW
          idle_ids << uid
        end
      end

      [ User.where(id: active_ids.uniq), User.where(id: idle_ids.uniq) ]
    end

    def broadcast(chatroom)
      return unless chatroom

      active_users, idle_users = build(chatroom.id)
      Turbo::StreamsChannel.broadcast_replace_to(
        chatroom,
        target: ActionView::RecordIdentifier.dom_id(chatroom),
        partial: "chatrooms/active",
        locals: { active_users:, idle_users: }
      )
    end
  end
end
