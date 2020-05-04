class Users::RegistrationsController < Devise::RegistrationsController
  def after_sign_up_path_for(resource)
    addresses_new_path
  end

  # The path used after sign up for inactive accounts.
  def after_inactive_sign_up_path_for(resource)
    addresses_new_path
  end

  def step1
     @user = User.new
  end
  
  def step2
    session[:nickname] = params[:user][:nickname]
    session[:email] = params[:user][:email]
    session[:password] = params[:user][:password]
    session[:password_confirmation] = params[:user][:password_confirmation]
    session[:first_name_reading] = params[:user][:first_name_reading]
    session[:last_name_reading] = params[:user][:last_name_reading]
    session[:first_name] = params[:user][:first_name]
    session[:last_name] = params[:user][:last_name]
    session[:birth_year] = params[:user]["birth_day(1i)"]
    session[:birth_month] = params[:user]["birth_day(2i)"]
    session[:birth_day] = params[:user]["birth_day(3i)"]
    @user = User.create(nickname:session[:nickname], email: session[:email], password: session[:password], password_confirmation: session[:password_confirmation], first_name_reading: session[:first_name_reading],last_name_reading: session[:last_name_reading], first_name: session[:first_name], last_name: session[:last_name], birth_year: session[:birth_year], birth_month: session[:birth_month], birth_day: session[:birth_day])
  end



  def create
    @user = User.new(params[:id])
    # if params[:user][:password].nil?
    #   @user = User.create(nickname:session[:nickname], email: session[:email], password: session[:password], password_confirmation: session[:password_confirmation], first_name_reading: session[:first_name_reading],last_name_reading: session[:last_name_reading], first_name: session[:first_name], last_name: session[:last_name], birth_year: session[:birth_year], birth_month: session[:birth_month], birth_day: session[:birth_day], phone_number: params[:user][:phone_number])
    #   @user = User.create(phone_number: params[:user][:phone_number])
    #   # sns = SnsCredential.create(user_id: @user.id,uid: params[:user][:uid], provider: params[:user][:provider])
    # else 
    #  redirect_back(fallback_location: root_path)
    # end
  
  if @user.save
    redirect_to controller: 'addresses', action: 'step3'
    sign_in(@user)
    bypass_sign_in(@user)
  else
    render "step1"
  end
end

  private
  def user_via_sns_params
    password = Devise.friendly_token.first(7)
    params.require(:user).permit(:nickname, :email, :first_name, :last_name, :first_name_reading, :last_name_reading, :birth_day, :phone_number, :uid, :provider).merge(password: password, password_confirmation: password)
  end



  def birthday_join
    year = params[:user]["birth_day(1i)"]
    month = params[:user]["birth_day(2i)"]
    day = params[:user]["birth_day(3i)"]
    birth_day = year.to_s + "-" + month.to_s + "-" + day.to_s
    return birth_day
  end

end