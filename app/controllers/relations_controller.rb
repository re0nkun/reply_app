class RelationsController < ApplicationController
  before_action :authenticate_user!

  def create
    @user = User.find(params[:user_id])
    current_user.active_rels.create(followed_id: @user.id)
    redirect_back(fallback_location: root_path)
  end

  def destroy
    @user = User.find(params[:user_id])
    current_user.active_rels.find_by(followed_id: @user.id).destroy
    redirect_back(fallback_location: root_path)
  end

  # def create
  #   user = User.find(params[:followed_id])
  #   current_user.active_rels.create(followed_id: user.id)
  #   redirect_to users_path
  # end
  # def destroy
  #   user = Relation.find(params[:id]).followed
  #   current_user.active_rels.find_by(followed_id: user.id).destroy
  #   redirect_to users_path
  # end
end
