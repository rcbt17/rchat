class MessagesController < ApplicationController
  def create
    @chatroom = Chatroom.find(params[:chatroom_id])
    @message = Message.new(message_params)
    @message.chatroom = @chatroom
    @message.user = Current.user
    if @message.save
      redirect_to chatroom_path(@chatroom), notice: "Saved message"
    else
      render "chatrooms/show", status: :unprocessable_content
    end
  end

  private

  def message_params
    params.require(:message).permit(:body)
  end
end
