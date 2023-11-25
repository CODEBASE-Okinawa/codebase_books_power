module ApplicationHelper
  # サムネイル取得 volumeInfoの中のimageLinksの中のthumbnail
  def google_book_thumbnail(google_book)
    google_book['volumeInfo']['imageLinks'].nil? ? 'sample.jpg' : google_book['volumeInfo']['imageLinks']['thumbnail']
  end

  #thumbnailはネストしている配置となっているのでdigを使って取り出す
  #また画像のリンクがhttpとなっているためgsubを使いhttpsに変更する。変更した値をbookImageに代入する
  def set_google_book_params(google_book)
    google_book['volumeInfo']['bookImage'] = google_book.dig('volumeInfo', 'imageLinks', 'thumbnail')&.gsub("http", "https")

    # 10桁を取得するように修正した
    if google_book['volumeInfo']['industryIdentifiers']&.select { |h| h["type"].include?("ISBN_10") }.present?
      google_book['volumeInfo']['systemid'] = google_book['volumeInfo']['industryIdentifiers']&.find { |h| h["type"].include?("ISBN_10") }.fetch("identifier", nil)
    end
     #volumeInfoの中が必要な項目のみになるようsliceを使って絞りこむ
    google_book['volumeInfo'].slice('title', 'authors', 'publishedDate', 'infoLink', 'bookImage', 'systemid', 'canonicalVolumeLink')
  end
end
