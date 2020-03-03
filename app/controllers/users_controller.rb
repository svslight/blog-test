class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :admin_user, only: :destroy

  # GET /users
  # GET /users.json
  def index
    # @users = User.all
    @users = User.paginate(page: params[:page])
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        log_in @user    # Вход пользователя после регистрации
        format.html { redirect_to @user, notice: 'Внимание! Вы удачно прошли регистрацию!' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    @user = User.find(params[:id])
    respond_to do |format|
      if @user.update_attributes(user_params)
        format.html { redirect_to @user, notice: 'Внимание! Ваши данные удачно изменены!' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    # @user.destroy
    User.find(params[:id]).destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'Внимание! Ваши данные удалены!' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    # Предфильтры (защита)

    # Подтверждает вход пользователя - требование для входа пользователя
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
        # format.html { redirect_to login_url, notice: 'Please log in' }
      end
    end

    # Подтверждает правильного пользователя
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    # Подтверждает администратора
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
