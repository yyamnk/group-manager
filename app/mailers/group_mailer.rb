class GroupMailer < ApplicationMailer

  def update(group)
    @group = group
    @user_detail = group.user.user_detail
    mail(to: group.user.email, subject: '[技大祭]参加団体情報 更新のお知らせ')
    # 暗黙的にapp/views/group_mailer/update.html.erb がrenderされる.
  end
end
