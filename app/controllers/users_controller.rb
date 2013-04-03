class UsersController < ApplicationController
  respond_to :html, :json, :csv
  respond_to :js, :only => [:update]
  # Privileged controller
  before_filter :authenticate_admin
  # Edit the submitted admin collections based on existing collections in @user's db entry
  before_filter :update_admin_collections, :only => [:update]
  
  # GET /users
  def index
    @users = User.search(params[:q]).order(sort_column + " " + sort_direction).page(params[:page]).per(30)
    
    respond_with(@users)
  end

  # GET /users/1
  def show
    @user = User.find(params[:id])
    
    respond_with(@user)
  end

  # PUT /users/1
  def update
    # Update user attributes
    user_attributes = {
      :umbra_admin_collections => user_collections,
      :umbra_admin => !user_collections.empty?
    }
    @user.user_attributes = user_attributes
    
    if @user.save 
      flash[:notice] = t('users.update_success')
    else
      flash[:error] = t('users.update_failure')
    end
    
    respond_with(@user) do |format|
      format.js { render :layout => false }
      format.html { render action: "show" }
    end
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
    User.destroy_all("user_attributes not like '%:umbra_admin: true%'")
    flash[:success] = t('users.clear_patron_data_success')
    
    respond_with(@users) do |format|
      format.html { render :index }
    end
  end
  
  # Implement sort column for User class
  def sort_column
    super "User", "lastname"
  end
  helper_method :sort_column

end
