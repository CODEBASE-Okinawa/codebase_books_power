class Request < ApplicationRecord
  belongs_to :user
  def save_with_request(title, systemid, authors, user_id)
    ActiveRecord::Base.transaction do
      puts title
      self.title = title
      self.author = authors.first.strip
      self.isbn = systemid
      self.user_id = user_id
      self.save!
    end
    true
  rescue StandardError
    false
  end
end