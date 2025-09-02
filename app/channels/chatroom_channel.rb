class ChatroomChannel < ApplicationCable::Channel
  def subscribed
    @chatroom = Chatroom.find_by(id: params[:chatroom_id])
    return reject unless @chatroom

    uid = current_user.id
    room_id = @chatroom.id
    now = Time.current.to_i

    $redis.incr("presence:room:#{room_id}:user:#{uid}:conns")
    $redis.sadd("presence:room:#{room_id}:users", uid)
    $redis.set("presence:room:#{room_id}:user:#{uid}:last_seen", now)

    stream_for @chatroom
    PresenceRoster.broadcast(@chatroom)
  end

  def heartbeat
    $redis.set("presence:room:#{params[:chatroom_id]}:user:#{current_user.id}:last_seen", Time.current.to_i)
  end

  def unsubscribed
    room_id = params[:chatroom_id]
    uid     = current_user.id

    conns_key = "presence:room:#{room_id}:user:#{uid}:conns"
    users_key = "presence:room:#{room_id}:users"

    current = ($redis.get(conns_key) || "0").to_i
    if current > 1
      $redis.decr(conns_key)
    else
      $redis.del(conns_key)
      $redis.srem(users_key, uid)
    end

    if (chatroom = Chatroom.find_by(id: room_id))
      PresenceRoster.broadcast(chatroom)
    end
  end
end
