# frozen_string_literal: true

class PostsController < ApplicationController
  def new; end

  def create
    @post = current_user.posts.build(post_params)
    if @post.valid?
      @post.save
      flash[:success] = 'Post created'
    else
      flash[:danger] = "Post can't be empty"
    end
    redirect_to current_user
  end

  def destroy
    Post.find(params[:id]).destroy
    flash[:success] = 'Post deleted'
    redirect_to current_user
  end

  private

  def post_params
    params.require(:post).permit(:content)
  end
end