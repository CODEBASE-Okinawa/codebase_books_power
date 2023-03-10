class ReservationsController < ApplicationController
  before_action :redirect_to_sign_in, only: %i[index show], unless: :user_signed_in?
  before_action :delete_old_reservations, only: %i[show]

  def index
    @reservations = Reservation.where(user_id: current_user&.id).where("reservation_at >= ?",
                                                                       Time.now).order(reservation_at: :asc)
  end

  def show
    @reservation = Reservation.find(params[:id])
    redirect_to book_path(@reservation.book) unless @reservation
  end

  def create
    @reservation = Book.find(params[:book_id]).reservations.build(reservation_param(params))

    if @reservation.save
      # reservation_remind_dateメソッドで返された日付にメールを送るように、ジョブにキューイング。
      MailDeliveryJob.set(wait_until: reservation_remind_date(@reservation.reservation_at)).perform_later(@reservation)

      flash[:success] = "予約が完了しました"
      redirect_to reservations_path
    end
  end

  def destroy
    reservation = Reservation.find(params[:id])
    if reservation.destroy
      flash[:success] = "予約のキャンセルが完了しました"
      redirect_to reservations_path
    else
      redirect_to request.referer
    end
  end

  def reservation_param(data)
    @reservation_info = { book_id: data[:book_id],
                          user_id: current_user&.id,
                          reservation_at: data[:start_at],
                          return_at: data[:return_at] }
  end

  def delete_old_reservations
    old_reservations = Reservation.where("reservation_at < ?", Date.today)
    if old_reservations.destroy_all && old_reservations.exists?
      redirect_to reservations_path
    end
  end

  # 貸出予約のリマインド通知を送る、日付を返す
  def reservation_remind_date(reservation_at)
    # リマインダーを送る基準日時（現在時刻から3日後）
    three_days_before_lending = Date.today.days_since(3)

    # 予約して３日以内に貸出予定なら現在、それ以降なら予約日の３日前の日付をセット
    if reservation_at.before? three_days_before_lending
      # 貸出予定が現在から三日以内の場合
      Time.now
    else
      # 貸出予定が現在から３日以上後の場合
      reservation_at.days_ago(3).to_time
    end
  end
end
