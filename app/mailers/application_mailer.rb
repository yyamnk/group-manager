class ApplicationMailer < ActionMailer::Base

  default from: ENV['EMAIL_SENDER'] # config/initializers/devise.rb と統一

end
