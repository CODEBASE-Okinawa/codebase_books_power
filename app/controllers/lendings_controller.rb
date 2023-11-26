class LendingsController < ApplicationController
  before_action :redirect_to_sign_in, only: [:index, :show], unless: :user_signed_in?
  before_action :redirect_lendings, only: :show

  def index
    @lendings = current_user&.lendings.not_yet_returned
  end

  def show
    @lending = Lending.find(params[:id])
  end

  def update
    lending = Lending.find(params[:id])

    if lending.update(return_status: true)
      flash[:success] = "返却が完了しました"
      redirect_to book_path(lending.book)
    else
      flash.now[:failed] = "返却に失敗しました"
      render "show", status: :unprocessable_entity
    end
  end

  def create
    @lending = Book.find(params[:book_id]).lendings.build(lending_params(params))

    if @lending.save
      # reservation_remind_dateメソッドで返された日付にメールを送るように、ジョブにキューイング。
      MailDeliveryJob.set(wait_until: return_remind_date(@lending.return_at)).perform_later(@lending)

      flash[:success] = "貸出が完了しました"
      redirect_to lendings_path
    else
      # 保存が失敗した場合の処理
      flash[:error] = "貸出の処理に失敗しました"
      render :new
    end
  end

  private

  def lending_params(data)
    @lending_params = { book_id: data[:book_id],
                        user_id: current_user&.id,
                        return_at: data[:return_at] }
  end

  # サインインしているユーザーが借りていない本だったら、貸出一覧ページへリダイレクト
  def redirect_lendings
    if current_user&.lendings.find_by(id: params[:id]).blank?
      redirect_to lendings_path
    end
  end
end

# 返却のリマインド通知を送る、日付を返す
def return_remind_date(returmn_at)
  # 貸出して、返却日の３日前の日付をセット
    return_at.days_ago(3).to_time
end