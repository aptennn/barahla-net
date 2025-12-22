# class PagesController < ApplicationController
#   def seller_profile
#     @user = User.find(params[:id])
#     @advertisements = @user.advertisements
#     @reviews = Review.where(user_to_id: @user.id).includes(:user)
#   end
# def create_review
#   @review = Review.new(review_params)
#   if @review.save
#     redirect_to seller_profile_path, notice: 'Отзыв успешно сохранен.'
#   else
#     redirect_to seller_profile_path, alert: 'Ошибка при сохранении отзыва.'
#   end
# end
#
# private
#
# def review_params
#   params.require(:review).permit(:user_id, :user_to_id, :rating, :text)
# end
# def profile
# end
#
# def seller_profile
#   @user = User.find(params[:id])
#   @advertisements = Advertisement.where(user_id: @user.id).order(created_at: :desc)
# end
#
# def create_review
#   @review = current_user.reviews.build(review_params.merge(seller_id: params[:seller_id]))
#   if @review.save
#     redirect_to seller_profile_path(params[:seller_id]), notice: "Отзыв успешно добавлен"
#   else
#     redirect_to seller_profile_path(params[:seller_id]), alert: "Ошибка при добавлении отзыва"
#   end
# end
#
# private
#
# def review_params
#   params.require(:review).permit(:rating, :comment)
# end
# end
class PagesController < ApplicationController
  def profile
  end

  def seller_profile
    @user = User.find(params[:id])
    @advertisements = Advertisement.where(user_id: @user.id).order(created_at: :desc)
  end
end