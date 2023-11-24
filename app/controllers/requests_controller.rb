class RequestsController < ApplicationController
    def new
    end

    def search
        require 'net/http'
        require 'uri'
        uri = URI.parse('https://www.googleapis.com/books/v1/volumes')
        text = params[:search]

        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true        
        response = http.get("#{uri}?q=search:#{text}")

        @google_books = JSON.parse(response.body)
    end

    def create

        @bookRequest = Request.new 
        #モデルに書いたsave_with_authorメソッドを実行する

        if @bookRequest.save_with_request(params[:title], params[:systemid], params[:book][:authors])
          redirect_to books_path, success: t('.success')
        else
          flash.now[:danger] = t('.fail')
        end
      end
    
      private  
      
      #うまく使えなかった
      def requests_params
        params.require(:book).permit(:title, :systemid, authors: [])
      end
    
    

end
