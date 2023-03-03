class BooksController < ApplicationController
  before_action :redirect_to_admin_books, only: [:index]
  before_action :redirect_to_sign_in, only: %i[show], unless: :user_signed_in?

  def index
    @books = Book.eager_load(:reservation_active, :lend_active).with_attached_image.order(:id)
  end

  def show
    @book = Book.eager_load(:reservation_active, :lend_active).where(id: params[:id]).with_attached_image.order("reservations.reservation_at asc").first

    lending = @book.lend_active.first
    redirect_to lending if lending&.user_id == current_user.id && lending.present?
    reservation = @book.reservation_active.find{|reservation| reservation.user_id == current_user.id}
    redirect_to reservation_path(reservation) if reservation

    @reservation = Reservation.new
    @lending = Lending.new
  end

  private

  def redirect_to_admin_books
    return unless current_user&.admin?

    redirect_to admin_books_path
  end

end
