class Utente < ActiveRecord::Base
	set_table_name "P18_USER"
  belongs_to :gruppo, :foreign_key => "grp_id"

  acts_as_authentic do |c|
		# for available options see documentation in: Authlogic::ActsAsAuthentic
    #c.my_config_option = my_value
  end # blocco opzionale

  def self.search_for_user_name_existence(login)
		Utente.find_by_user_name(login.upcase)		
  end

	def valid_password?(password)
		Utente.find_by_user_name_and_user_pwd(user_name, password)
  end

	def persistence_token=(ptoken)
		id = ptoken
  end

	def persistence_token
		return id
  end

	def self.find_by_persistence_token(pt)
		puts "****************** #{pt} ************** "
		Utente.find(pt)
  end

end
