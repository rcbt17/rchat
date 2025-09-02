class ChatroomsController < ApplicationController
  def new
    @chatroom = Chatroom.new
  end

  def create
    @chatroom = Chatroom.new(chatroom_params)
    @chatroom.user = Current.user
    if @chatroom.save
      redirect_to chatroom_path(@chatroom), notice: "Congrats for your new chatroom!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @chatroom = Chatroom.find(params[:id])
    @messages = Message.where(chatroom: @chatroom).last(100)
    @message = @chatroom.messages.build
    @active_users, @idle_users = PresenceRoster.build(@chatroom.id)
  end

  def index
    @chatrooms = Chatroom.all.order(created_at: :desc)
    @user_chatrooms = Chatroom.where(user: Current.user)
  end

  private

  def chatroom_params
   params.require(:chatroom).permit(:name)
  end
end
