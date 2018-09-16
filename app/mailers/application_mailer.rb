class ApplicationMailer < ActionMailer::Base
  default template_path: 'email'
  default from: 'membership@abutours.com'
  default reply_to: 'membership@abutours.com'

  layout 'application_email'
end
