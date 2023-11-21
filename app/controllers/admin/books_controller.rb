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
    @book.image.attach(params[:book][:image])
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
    uri = URI.parse('https://www.googleapis.com/books/v1/volumes')
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    response = http.get("#{uri}?q=isbn:#{isbn10}")
    hash = JSON.parse(response.body)
  
    # レスポンスが正常かつ"items"が存在する場合のみ@result_bookに代入する
    if hash["items"].present? && hash["items"].is_a?(Array) && hash["items"].first.present?
      @result_book = hash["items"][0]["volumeInfo"]
    else
      # それ以外の場合は@result_bookをnilに設定する
      @result_book = nil
    end
  
    redirect_to action: 'new', result_book: @result_book
  end

  private

  def book_params
    params.require(:book).permit(:title, :image, :isbn)
  end
end
