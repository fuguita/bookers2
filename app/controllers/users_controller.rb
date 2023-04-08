class UsersController < ApplicationController


  def index
    @users = User.all
    @book = Book.new

  end

  def show
    @user = User.find(params[:id])
     @book = Book.new
    @books = @user.books


  end

  def edit
    is_matching_user
    @user = User.find(params[:id])

  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
    flash[:notice] = 'You have updated user successfully.'
    redirect_to user_path(@user.id)
    else
    render :edit
    end
  end


  private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end

  def is_matching_user
    user = User.find(params[:id])
    unless user.id == current_user.id
    redirect_to user_path(current_user.id)
    end
  end
end
