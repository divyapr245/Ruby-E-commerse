class OrderMailer < ApplicationMailer
  def example(order)
    @order = order
    @user = @order.account
    mail(to: @user.email, subject: 'Test Email for Letter Opener')
  end
end
