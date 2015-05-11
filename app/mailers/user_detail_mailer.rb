class UserDetailMailer < ApplicationMailer

  def update(user_detail)
    @user_detail = user_detail
    mail(to: user_detail.user.email, subject: '[技大祭]ユーザ情報の更新')
    # 暗黙的にapp/views/user_detail_mailer/update.html.erb がrenderされる.
  end

end
