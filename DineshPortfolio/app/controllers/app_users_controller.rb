class AppUsersController < ApplicationController
  before_action :set_app_user, only: %i[ show edit update destroy ]

  # GET /app_users or /app_users.json
  def index
    # This page now serves as the login page
    if logged_in?
      redirect_to profile_path, notice: "You are already logged in."
    end
  end

  # GET /app_users/1 or /app_users/1.json
  def show
  end

  # GET /app_users/new
  def new
    @app_user = AppUser.new
  end

  # GET /app_users/1/edit
  def edit
  end

  # POST /app_users or /app_users.json
  def create
    @app_user = AppUser.new(app_user_params)

    respond_to do |format|
      if @app_user.save
        format.html { redirect_to app_user_url(@app_user), notice: "Account was successfully created." }
        format.json { render :show, status: :created, location: @app_user }
      else
        # Add this line to debug
        puts "Validation errors: #{@app_user.errors.full_messages}"
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @app_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /app_users/1 or /app_users/1.json
  def update
    respond_to do |format|
      if @app_user.update(app_user_params)
        format.html { redirect_to @app_user, notice: "App user was successfully updated." }
        format.json { render :show, status: :ok, location: @app_user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @app_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /app_users/1 or /app_users/1.json
  def destroy
    @app_user.destroy!

    respond_to do |format|
      format.html { redirect_to app_users_path, status: :see_other, notice: "App user was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  # POST /login
  def login
    user = AppUser.find_by(email: params[:email])
    
    if user && user.authenticate(params[:password])
      # Store user id in session
      session[:user_id] = user.id
      redirect_to profile_path, notice: "Logged in successfully!"
    else
      flash.now[:alert] = "Invalid email or password"
      render :index, status: :unprocessable_entity
    end
  end

  def logout
    session[:user_id] = nil
    redirect_to app_users_path, notice: "Logged out successfully!"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_app_user
      @app_user = AppUser.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def app_user_params
      params.require(:app_user).permit(:name, :email, :password, :password_confirmation)
    end
end
