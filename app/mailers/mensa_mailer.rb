class MensaMailer < ActionMailer::Base
  default :from => "Servizio mensa KION <asalicetti@kion.it>"
  
  def pubblicazione_menu(user, da_a)
    @da_a = da_a
    @user = user
    mail(:to => user.user_mail, :subject => "[MENSA] Pubblicato nuovo menu")  
  end

end
