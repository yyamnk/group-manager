class ApplicationMailer < ActionMailer::Base

  default from: ENV['EMAIL_SENDER'] # config/initializers/devise.rb と統一

  # bccに転送設定されたemailアドレスを追加する
  noticed_mails = User.where( get_notice: true ).pluck('email') # 転送先のアドレス配列
  default_bcc = ActionMailer::Base.default[:bcc]                # config/environment/xxxで設定されたbccを取得
  noticed_mails.push( default_bcc )                             # default_bccを追加

  default bcc: noticed_mails # ApplicationMailerのbccを更新

end
