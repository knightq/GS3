class Recapito < ActiveRecord::Base
	set_table_name "FW_RUBRICA"
  set_primary_key :prg_id 

  belongs_to :utente, :primary_key => "user_mail", :foreign_key => "cda_email"

  default_scope :order => 'cda_cognome ASC'

  scope :attivi, where('disable_flg = 0')
  scope :exclude_uni, where("user_name not like 'UNI%'")
  scope :cda_cognome_LIKE, lambda { |cognome| where("cda_cognome LIKE ?", "%#{cognome}%") } 
  scope :cda_telefono_LIKE, lambda { |telefono| where("cda_telefono LIKE ?", "%#{telefono}%") } 

  validates_presence_of :cda_nome, :cda_cognome
  validates_format_of :cda_email, :with => /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i  

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

end
