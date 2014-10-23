class ContactsMailer < ActionMailer::Base
  default from: 'me@example.com'

  def welcome(contact)
    @contact = contact

    mail(to: @contact.email, subject: "Welcome to my list #{@contact.name}!")
  end
end
