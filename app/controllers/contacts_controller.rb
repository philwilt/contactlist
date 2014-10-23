class ContactsController < ApplicationController
  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(contact_params)
    if @contact.save
      ContactsMailer.welcome(@contact).deliver_later
      flash[:success] = "You have been added to my contacts!"
      redirect_to root_url
    else
      render :new
    end
  end

  private

  def contact_params
    params.require(:contact).permit(:name, :email)
  end
end
