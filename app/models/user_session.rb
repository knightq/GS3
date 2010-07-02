class UserSession < Authlogic::Session::Base
	#include ActiveModel::Validations

  authenticate_with Utente
  login_field :user_name
  password_field :user_pwd
	find_by_login_method :search_for_user_name_existence

	attr_accessor :compact_mode
  
  #validates_presence_of(:user_name, :message => "Il nome utente è obbligatorio!")
  #validates_presence_of(:user_pwd, :message => "La password è obbligatoria!")

end
