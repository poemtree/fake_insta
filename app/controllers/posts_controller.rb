class PostsController < ApplicationController

  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: :index

  # cancancan을 사용하기 위한 권한 설정?
  load_and_authorize_resource

  def index
    @posts = Post.order(created_at: :desc).page(params[:page]).per(3)
    respond_to do |format|
        format.html
        format.json {render json: @posts}
    end
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.new(post_params)
    # address = "new_post_path"
    respond_to do |format|
      if @post.save
        # flash[:notice] = "글 작성을 완료하였습니다."
        # address = "/"
        format.html { redirect_to '/', notice: "글 작성을 완료하였습니다." }
      else
        # flash[:alert] = "글 작성에 실패하였습니다."
        format.html {render :new}
        format.json {render json: @post.errors}
      end
    end
    # redirect_to address
  end

  def show
    @comments = @post.comments
  end

  def edit
  end

  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: "수정을 완료하였습니다."}
      else
        format.html { render :edit }
        format.json { render json: @post.errors }
      end
    end
  end

  def destroy
    @post.destroy
    redirect_to "/"
  end

  private
  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :content, :img)
  end
end
