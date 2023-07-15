module GoogleBooksApi
  class << self
    def search_by_isbn(isbn)
      url = "https://www.googleapis.com/books/v1/volumes?q=isbn:#{isbn}"
      response = Faraday.get(url)
      @result = JSON.parse(response.body)
    end
  end
end