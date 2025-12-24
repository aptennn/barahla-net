class ReviewsController < ApplicationController
  before_action :require_login
  before_action :set_review, only: [:destroy]
  before_action :ensure_review_owner, only: [:destroy]

  def create
    if params[:seller_id].to_i == current_user.id
      redirect_to seller_profile_path(params[:seller_id]), alert: "Вы не можете оставить отзыв самому себе"
      return
    end

    @review = Review.new(review_params)
    @review.user_id = current_user.id
    @review.user_to_id = params[:seller_id].to_i

    if @review.save
      redirect_to seller_profile_path(params[:seller_id]), notice: 'Отзыв успешно добавлен!'
    else
      redirect_to seller_profile_path(params[:seller_id]), alert: "Ошибка: #{@review.errors.full_messages.to_sentence}"
    end
  end

  def destroy
    @review.destroy
    redirect_to seller_profile_path(@review.user_to_id), notice: 'Отзыв удалён.'
  end

  private

  def review_params
    params.require(:review).permit(:rating, :text)
  end

  def set_review
    @review = Review.find(params[:id])
  end

  def ensure_review_owner
    unless @review.user_id == current_user.id
      redirect_to seller_profile_path(@review.user_to_id), alert: 'Вы не можете удалить чужой отзыв.'
    end
  end
end