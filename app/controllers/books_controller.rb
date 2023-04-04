class BooksController < ApplicationController

  def new
    @book = Book.new

  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    @book.save
    redirect_to book_path
  end

  def index
  @books = Book.all
  end

  def show
    @book = Book.(params[:id])
  end

  def edit
    @book = Book.(params[:id])
  end

  def update
    @book = Book.find(params[:id])
    @book.update
    redirect_to book_path
  end

  def destory
  end

  private
  def book_params
    params.require(:book).permit(:title, :body)
  end

end
