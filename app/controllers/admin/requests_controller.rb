class Admin::RequestsController < ApplicationController
  def index
    @request = Request.where(status: false)
  end

  def update
    request = Request.find_by(id: params[:id])
    if request.update(status: true)
      flash[:success] = "リクエスト本を購入処理が成功しました"
    else
      flash[:failed] = "リクエスト本の購入処理に失敗しました"
    end
    redirect_to requests_path
  end
end
