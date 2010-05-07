class Gruppo < ActiveRecord::Base
  set_table_name "P18_GRP"
  has_many :utenti
end
