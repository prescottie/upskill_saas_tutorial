class ProfilesController < ApplicationController
  # GET to /users/:user_id/profile/new
  def new
    # Render blank profile details form
    @profile = Profile.new
  end
  
  # POST to users/:user_id/profile
  def create
    # ensure that we have the user who is filling out form
    @user = User.find( params[:user_id] )
    # create profile linked to this specific user
    @profile = @user.build_profile( profile_params )
    if @profile.save
      flash[:success] = "Profile Updated!"
      redirect_to user_path(params[:user_id])
    else 
      render action :new
    end
  end
  
  #GET to /users/:user_id/profile/edit
  def edit 
    @user = User.find(params[:user_id])
    @profile = @user.profile
  end
  
  #PATCH to /users/:user_id/profile/
  def update
    #Retrieve user from DB
    @user = User.find(params[:user_id])
    #Retrieve that users profile
    @profile = @user.profile
    #mass assign profile attributes and save
    if @profile.update_attributes(profile_params)
      flash[:success] = "Profile Updated!"
      #redirect user to their profile
      redirect_to user_path(id: params[:user_id])
    else 
      render action: :edit
    end
  end
  
  private
  def profile_params
    params.require(:profile).permit(:first_name, :last_name, :avatar, :job_title, :phone_number, :contact_email, :description)
  end
end