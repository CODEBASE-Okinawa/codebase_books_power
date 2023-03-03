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
    @user = User.find(current_user.id)
    @lending = @user.lendings.build(lending_params)

    return unless @lending.save

    flash[:success] = "貸出が完了しました"
    redirect_to lendings_path
  end

  private

  def lending_params
    params.require(:lending).permit(:book_id,
                                    :return_at)
  end

  # サインインしているユーザーが借りていない本だったら、貸出一覧ページへリダイレクト
  def redirect_lendings
    if current_user&.lendings.find_by(id: params[:id]).blank?
      redirect_to lendings_path
    end
  end
end
