class PagesController < ApplicationController
  def profile
  end

  def seller_profile
    @user = User.find(params[:id])
    @advertisements = Advertisement.where(user_id: @user.id).order(created_at: :desc)
  end
end