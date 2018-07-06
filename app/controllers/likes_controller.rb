class LikesController < ApplicationController
  def create
    @post_id = params[:post_id]
    Like.create(user_id: current_user.id, post_id: @post_id)
    respond_to do |format|
      format.html {redirect_to :back}
      format.js {}
    end
  end

  def destroy
    @post_id = params[:post_id]
    Like.find_by(user_id: current_user.id, post_id: @post_id).destroy
    respond_to do |format|
      format.html {redirect_to :back}
      format.js {}
    end
  end

end
