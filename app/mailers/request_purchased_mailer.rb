class RequestPurchasedMailer < ApplicationMailer
  default from: 'admin@example.com'

  def request_purchased_notification
    @request = params[:request]
    @user = @request.user
    @url = 'http://localhost:3000'
    mail(to: @user.email, subject: 'リクエストいただいた本を購入いたしました')
  end
end