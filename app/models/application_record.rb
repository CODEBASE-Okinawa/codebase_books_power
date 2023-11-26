class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  def self.exists_with_isbn?(isbn)
    exists?(isbn: isbn)
  end
end
