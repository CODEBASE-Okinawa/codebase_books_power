class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  def self.exists_with_isbn?(isbn)
    exists?(isbn: isbn)
  end

  def status(user)
    user_id = user&.id
    lending_status = lend_active.any?{ |lending| lending.user_id == user_id }
    reservation_status = reservation_active.any?{ |reservation| reservation.user_id == user_id }
    if lending_status && user_id.present?
      "lending"
    elsif reservation_status && user_id.present?
      "reserved"
    elsif lend_active.present?
      "lent"
    else
      "available"
    end
  end

end
