class ContactsController < ApplicationController
  
  # GET REQUEST to /contact-us
  # Show new contact form
  def new
    @contact = Contact.new
  end
  
  # Post request /contacts
  def create
    # Mass assignment of form fields into Contact Object
    @contact = Contact.new(contact_params)
    # Save the contact object to the database
    if @contact.save
      # Store form fields via parametres, into variables
      name = params[:contact][:name]
      email = params[:contact][:email]
      body = params[:contact][:comments]
      # Plug variables into Contact Mailer email Method
      # email method and send mail
      # and redirect to the new action
      ContactMailer.contact_email(name, email, body).deliver
      flash[:success] = "Messgage Sent"
      redirect_to new_contact_path
    else 
      # If contact object doesnt save, store errors in flash hash
      # redirect to the new action
      flash[:danger] = @contact.errors.full_messages.join(", ")
      redirect_to new_contact_path
    end
  end
  
  private 
  #to collect data from form, we need to use
  #strong parameters and whitelist the form fields
    def contact_params
      params.require(:contact).permit(:name, :email, :comments)
    end
end