class Users::CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post
  before_action :set_comment, only: [:edit, :update, :destroy]
  include ApplicationHelper

  def index
    @comments = @post.comments.includes(:user)
  end

  def new
    @comment = Comment.new
  end

  def create
    @comment = Comment.new(comment_params)
    @comment.post = @post
    @comment.user = current_user
    if @comment.save
      redirect_to users_post_comments_path(@post), notice: 'Comment Posted!'
    else
      render :new
    end
  end

  def edit
    authorize @comment, :edit?, policy_class: CommentPolicy
  end

  def update
    authorize @comment, :update?, policy_class: CommentPolicy
    if @comment.update(comment_params)
      redirect_to users_post_comments_path(@post), notice: 'Comment Updated!'
    else
      render :edit
    end
  end

  def destroy
    authorize @comment, :destroy?, policy_class: CommentPolicy
    if @comment.destroy
      redirect_to users_post_comments_path(@post), notice: 'Comment Deleted!'
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end

  def set_comment
    @comment = @post.comments.find(params[:id])
  end

  def set_post
    @post = Post.where(id: filter_post).find(params[:post_id])
  end
end