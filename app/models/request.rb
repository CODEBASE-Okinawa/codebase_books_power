class Request < ApplicationRecord
  def save_with_request(title, systemid, authors)
    ActiveRecord::Base.transaction do
      puts title
      self.title = title
      self.author = authors.first.strip
      self.isbn = systemid
      self.save!
    end
    true
  rescue StandardError
    false
  end
end