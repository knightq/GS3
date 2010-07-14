class MensaMailer < ActionMailer::Base
  default :from => "Servizio mensa KION <asalicetti@kion.it>"
  
  def pubblicazione_menu(da_a)
    @da_a = da_a
    mail(:to => "asalicetti@kion.it", :subject => "[MENSA] Pubblicato nuovo menu")  
  end

end
