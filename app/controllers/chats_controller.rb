class ChatsController < ApplicationController
  before_action :require_login
  before_action :set_advertisement, only: [:new, :create]
  before_action :set_chat, only: [:show, :destroy]

  def index
    @chats = current_user.chats_as_ad_owner.or(current_user.chats_as_user).includes(:advertisement, :ad_owner, :user).order(created_time: :desc)
  end

  def show
    @messages = @chat.messages.includes(:sender, :receiver).order(:created_at)
    @message = Message.new
  end

  def new
    @chat = Chat.new(advertisement: @advertisement, ad_owner: @advertisement.user, user: current_user)
  end

  def create
    @chat = Chat.find_or_initialize_by(
      advertisement: @advertisement,
      ad_owner: @advertisement.user,
      user: current_user
    )
    if @chat.new_record?
      @chat.created_time = Time.now
      if @chat.save
        redirect_to chat_path(@chat), notice: 'Чат успешно создан.'
      else
        render :new
      end
    else
      redirect_to chat_path(@chat), notice: 'Чат уже существует.'
    end
  end

  def destroy
    @chat.destroy
    redirect_to chats_path, notice: 'Чат удален.'
  end

  private

  def set_advertisement
    @advertisement = Advertisement.find_by(ad_id: params[:advertisement_id] || params.dig(:chat, :advertisement_id))
    redirect_to root_path, alert: 'Объявление не найдено.' unless @advertisement
  end

  def set_chat
    @chat = Chat.find(params[:id])
    # Проверка доступа
    unless @chat.ad_owner == current_user || @chat.user == current_user
      redirect_to root_path, alert: 'У вас нет доступа к этому чату.'
    end
  end
end