class UserSession < Authlogic::Session::Base
	authenticate_with Utente
  login_field :user_name
  password_field :user_pwd
	find_by_login_method :search_for_user_name_existence
end
