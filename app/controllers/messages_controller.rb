class MessagesController < ApplicationController
  before_action :require_login
  before_action :set_chat

  def create
    @message = @chat.messages.new(message_params)
    @message.sender = current_user
    @message.receiver = (@chat.ad_owner == current_user) ? @chat.user : @chat.ad_owner

    if @message.save
      redirect_to chat_path(@chat), notice: 'Сообщение отправлено'
    else
      @messages = @chat.messages.includes(:sender, :receiver).order(:created_at)
      render 'chats/show', status: :unprocessable_entity
    end
  end

  private

  def set_chat
    @chat = Chat.find(params[:chat_id])
    unless @chat.ad_owner == current_user || @chat.user == current_user
      redirect_to root_path, alert: 'У вас нет доступа к этому чату'
    end
  end

  def message_params
    params.require(:message).permit(:text)
  end
end