class ReservationsController < ApplicationController
  def index
    @user = current_user
    @reserved_books = Reservation.where(user_id: @user.id).where("reservation_at > ?",
                                                                 Time.now).order(reservation_at: :asc)
  end

  def show
  end
end
