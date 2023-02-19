class LendingsController < ApplicationController
  before_action :require_signed_in, only: [:index, :show]
  before_action :redirect_lendings, only: :show

  def index
    @lendings = current_user.lendings.not_yet_returned
  end

  def show
    @lending = Lending.find(params[:id])
  end

  def update
    lending = Lending.find(params[:id])
    if lending.update(return_status: true)
      flash[:success] = "返却が完了しました"
      redirect_to book_path
    else
      flash.now[:faild] = "返却に失敗しました"
      render "show", status: :unprocessable_entity
    end
  end

  private
  
  #lendingへのアクセスは、サインインが必要
  def require_signed_in
    redirect_to new_user_session_path if !user_signed_in?
  end

  # サインインしているユーザーが借りていない本だったら、貸出一覧ページへリダイレクト
  def redirect_lendings
    if current_user.lendings.find_by(id: params[:id]).blank?
      redirect_to lendings_path
    end
  end
end
