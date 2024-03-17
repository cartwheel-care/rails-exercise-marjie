class ContactsController < ApplicationController
  def index
    @contacts = Contact.all.includes(:patient).order(:first_name, :last_name)
  end

  def create_patient
    @contact = Contact.find(params[:id])

    @contact.create_patient!

    redirect_to action: :index
  end
end
