class LikesController < ApplicationController
  def create
    @like = Like.new(likeable_id:   params[:likeable_id],
                     likeable_type: params[:likeable_type],
                     user_id: current_user.id)
    if @like.save
      redirect_to :back
    else
      redirect_to :back, notice:  @like.errors.full_messages.to_sentence
    end
  end

  def destroy
    Like.find(params[:id]).destroy
    redirect_to :back
  end
end
