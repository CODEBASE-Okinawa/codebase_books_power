class RequestsController < ApplicationController

    def new
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
        @result_book = hash["items"][0]["volumeInfo"]
        redirect_to '/books/search'
    end

end
