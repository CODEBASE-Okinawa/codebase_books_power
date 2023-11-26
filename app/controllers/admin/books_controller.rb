class Admin::BooksController < ApplicationController
  before_action :check_admin

  def index
    @books = Book.eager_load(:lending).with_attached_image.order(:id)
  end

  def new
    @book = Book.new
    @result_book = params[:result_book]
  end

  def create
    @book = Book.new(book_params)

    # 画像のURLがあればそれを利用
    if params[:book][:image_url].present?
      @book.image_url = params[:book][:image_url]
    end
    
    if @book.save
      flash[:success] = "本を登録しました"
      redirect_to admin_books_path
    else
      render 'new', status: :unprocessable_entity
    end
  end


  def search
    require 'net/http'
    require 'uri'
  
    isbn10 = params[:isbn]
    title = params[:title]
    query = if isbn10.present?
              "isbn:#{isbn10}"
            elsif title.present?
              title
            else
              ""
            end
  
    uri = URI.parse('https://www.googleapis.com/books/v1/volumes')
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    response = http.get("#{uri}?q=#{URI.encode_www_form_component(query)}")
    hash = JSON.parse(response.body)
  
    if hash["items"].present? && hash["items"].is_a?(Array) && hash["items"].first.present?
      @result_book = hash["items"].first["volumeInfo"]
  
      if @book.present? && @result_book["imageLinks"] && @result_book["imageLinks"]["thumbnail"]
        @book.image_url = @result_book["imageLinks"]["thumbnail"]
        @book.save
      end
  
      redirect_to action: 'new', result_book: @result_book
    else
      @result_book = nil
      redirect_to action: 'new', result_book: @result_book
    end
  end
  
  
  
  
  

  private

  def book_params
    params.require(:book).permit(:title, :image, :isbn)
  end
end
