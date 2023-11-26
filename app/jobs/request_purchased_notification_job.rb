class RequestPurchasedNotificationJob < ApplicationJob
  queue_as :default

  def perform(request_data)
    # リクエスト本が購入されたらリクエスト者に通知を送る
    RequestPurchasedMailer.with(request: request_data).request_purchased_notification.deliver_later
  end
end