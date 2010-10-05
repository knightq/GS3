class Utente < ActiveRecord::Base
	set_table_name "P18_USER"
  set_primary_key :user_id

  belongs_to :gruppo, :foreign_key => "grp_id"

  has_one :recapito, :primary_key => "user_mail", :foreign_key => "cda_email"

  scope :attivi, where('disable_flg = 0')
  scope :exclude_uni, where("user_name not like 'UNI%'")
  scope :user_name, lambda {|user_name| where('user_name = ?', user_name)}
  scope :with_recapito, joins('LEFT OUTER JOIN "FW_RUBRICA" ON "P18_USER".user_mail = "FW_RUBRICA".cda_email')
  #:joins => 'LEFT OUTER JOIN "FW_RUBRICA" ON "P18_USER".user_mail = "FW_RUBRICA".cda_email')
  #Utente.scoped.attivi.exclude_uni.order('USER_NAME asc').joins('LEFT OUTER JOIN "FW_RUBRICA" ON "P18_USER".user_mail = "FW_RUBRICA".cda_email')
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
  end

	def persistence_token
		return id
  end

	def self.find_by_persistence_token(pt)
		puts "****************** #{pt} ************** "
		Utente.find(pt)
  end

  def analista?
    analista_flg
  end

  def admin?
    cambia_pwd_flg
  end

  def dba?
    dba_flg
  end

  def programmatore?
    programatore_flg
  end

  def cq?
    cq_flg
  end

  def is_andrea?
    user_name == 'ASALICETTI'
  end

  def <=>(other)
    self.user_id <=> other.user_id
  end

end
