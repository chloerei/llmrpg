class ApplicationMailer < ActionMailer::Base
  default from: "notifications@#{ENV.fetch("HOST", "localhost")}"
  layout "mailer"
end
