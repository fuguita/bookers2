class BooksController < ApplicationController
  before_action :authenticate_user!
  before_action :is_matching_book, only: [:edit, :update, :destroy]

  def new
    @book = Book.new
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      flash[:notice] = 'You have created book successfully.'
    redirect_to book_path(@book.id)
    else
      @books = Book.all
    render 'index'
    end
  end

  def index
  @books = Book.all
  @book = Book.new
  @book_comment = BookComment.new
  end

  def show
    @book = Book.find(params[:id])
    @user = @book.user
    @book_comment = BookComment.new
  end

  def edit
    is_matching_book
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      flash[:notice] = 'You have updated book successfully.'
    redirect_to book_path(@book)
    else
    render :edit
    end
  end

  def destroy
    book = Book.find(params[:id])
    book.destroy
    redirect_to books_path
  end

  private
  def book_params
    params.require(:book).permit(:title, :body, :rate)
  end

  def is_matching_book
    book = Book.find(params[:id])
    user = book.user
    unless user.id  == current_user.id
      redirect_to books_path
    end
  end



end

