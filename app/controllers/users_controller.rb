class UsersController < ApplicationController
  respond_to :html, :json, :csv
  # Privileged controller
  before_filter :authenticate_admin
  
  # GET /users
  def index
    @users = User.search(params[:q]).sorted(params[:sort], "lastname ASC").page(params[:page]).per(30)
    
    respond_with(@users)
  end

  # GET /users/1
  def show
    @user = User.find(params[:id])
    
    respond_with(@user)
  end
  
  # DELETE /users/1
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_with(@user)
  end
  
  # Delete all non-admin patrons
  def clear_patron_data
    @users = User.search(params[:q]).order(sort_column + " " + sort_direction).page(params[:page]).per(30)
    User.destroy_all("user_attributes not like '%:findingaids_admin: true%'")
    flash[:success] = t('users.clear_patron_data_success')
    
    respond_with(@users) do |format|
      format.html { render :index }
    end
  end

end
