require 'active_model'

class Menu
  include ActiveModel::Validations
  include ActiveModel::Serialization
  
  attr_accessor :giorno
  attr_accessor :primi
  attr_accessor :secondi
  attr_accessor :contorni
  attr_accessor :condimenti
  attr_accessor :piatti_unici
  attr_accessor :cestini


  def initialize(giorno = nil)
    @giorno = giorno
    @primi = Array.new
    @secondi = Array.new
    @contorni = Array.new
  end

  def to_key
    
  end

  def parseRow(valore)
    val = valore.split('  ').collect{|e| e unless ((e == "") or (e =~ /\$.*/) or (e =~ /\*.*/))}.compact.reverse
    if(val.size == 9 or val.size == 6)
      @primi << {:cod => val.pop, :des => val.pop, :cal => val.pop}
      @secondi << {:cod => val.pop, :des => val.pop, :cal => val.pop}
      @contorni << {:cod => val.pop, :des => val.pop, :cal => val.pop} unless val.size == 0
    elsif (val.size <= 4)
      puts "VAL <= 4 (size= #{val.size}): #{val}"
    end
    puts "VALORE SPLITTATO: #{val}"
  end

  def to_s
    return to_html
  end
  
  def bello
    tos = "Menu del #{@giorno}\n"
    tos << "==========================================\n"
    tos << "PRIMI:\n"
    tos << "==========================================\n"
    @primi.each do |p|
      tos << "#{p[:cod]}) #{p[:des]} [#{p[:cal]} Kcal]\n"
    end
    tos << "\n"
    tos << "==========================================\n"
    tos << "SECONDI:\n"
    tos << "==========================================\n"
    @secondi.each do |s|
      tos << "#{s[:cod]}) #{s[:des]} [#{s[:cal]} Kcal]\n"
    end
    tos << "\n"
    tos << "==========================================\n"
    tos << "CONTORNI:\n"
    tos << "==========================================\n"
    @contorni.each do |c|
      tos << "#{c[:cod]}) #{c[:des]} [#{c[:cal]} Kcal]\n"
    end
    return tos
  end

  def to_html
    tos = "<li>"
    tos << "<b>Menu del #{@giorno}<b><br/>"
    tos << "<b>PRIMI:</b><br/><ul>"
    @primi.each do |p|
      tos << "<li>#{p[:cod]}) #{p[:des]} [#{p[:cal]} Kcal]</li>"
    end
    tos << "</ul>"
    tos << "<b>SECONDI:</b><br/><ul>"
    @secondi.each do |s|
      tos << "<li>#{s[:cod]}) #{s[:des]} [#{s[:cal]} Kcal]</li>"
    end
    tos << "</ul>"
    tos << "<b>CONTORNI:</b><br/><ul>"
    @contorni.each do |c|
      tos << "<li>#{c[:cod]}) #{c[:des]} [#{c[:cal]} Kcal]</li>"
    end
    tos << "</ul></li>"
    return tos
  end

end
