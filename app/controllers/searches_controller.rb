class SearchesController < ApplicationController
  before_action :authenticate_user!
  def search
    @word = params[:word]
    @model = params[:model]
    @method = params[:method]
     if @model == "User"
       @records = User.search_for(@word, @method)
     else
       @records = Book.search_for(@word, @method)
     end
  end
  def index
  end
end
