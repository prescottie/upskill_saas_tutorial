class ContactMailer < ActionMailer::Base
  default to: 'scott.hagan@aol.com'
  
  def contact_email(name, email, body)
    @name = name
    @email = email
    @body = body
    
    mail(from: email, subject)
  end
end