class PostsController < ApplicationController
  before_filter :authenticate_user!, :except => [:show]

  before_filter :find_board
  before_filter :find_board_post, :only => [:show, :edit]
  before_filter :find_user_post,  :only => [:update, :destroy]

  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found

  def show
  end

  def new
    @post = @board.posts.build
  end

  def create
    @post = @board.posts.build(params[:post])
    @post.user_id = current_user.id
    if @post.save
      redirect_to board_post_path(@board, @post)
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @post.update_attributes(params[:post])
      redirect_to board_post_path(@board, @post), :notice => "Post has been updated!"
    else
      render :edit
    end
  end

  def destroy
    @post.destroy
    redirect_to board_path(@board), :notice => "Post has been deleted!"
  end

  protected

  def find_board
    @board = Board.find(params[:board_id])
  end

  def find_board_post
    @post = @board.posts.find(params[:id])
  end

  def find_user_post
    @post = current_user.posts.find(params[:id])
  end

  def record_not_found
    redirect_to board_path(@board), :notice => "Not found"
  end
end
