class Segnalazione < ActiveRecord::Base
  set_table_name "FW_SEGNA"
  set_primary_key :prg_segna
  
  belongs_to :gravita, :foreign_key => 'cdn_gravita', :class_name => 'Gravita'
  belongs_to :risolutore, :foreign_key => 'cda_risolutore', :class_name => 'Utente'
  belongs_to :risolutore_analisi, :foreign_key => 'cda_risolutore_ana', :class_name => 'Utente'
  belongs_to :prodotto, :foreign_key => 'cda_prodotto', :class_name => 'Prodotto'

  # ====== STATI DELLA SEGNALAZIONE ====== 
  include Workflow
  
  # Workflow.create_workflow_diagram(Segnalazione, './')
  workflow_column :cda_stato
  workflow do
    state :SE, :meta => {:order => 1} do
      event :verifica, :transitions_to => :VE
    end

    state :VE, :meta => {:order => 2} do
      on_entry do
        consegna_flg = 0
      end
      event :assegna_a_analisi, :transitions_to => :AA
      event :assegna_a_sviluppo, :transitions_to => :AS
      event :rifiuta, :transitions_to => :RF
      event :rimanda, :transitions_to => :RI
    end

    state :AA, :meta => {:order => 3} do
      on_entry do
        consegna_flg = 0
      end
      event :risolvi_analisi, :transitions_to => :RA
    end

    state :RA, :meta => {:order => 4} do
      on_entry do
        consegna_flg = 0
      end
      event :assegna_a_sviluppo, :transitions_to => :AS
    end

    state :AS, :meta => {:order => 5} do
      on_entry do
        consegna_flg = 0
      end
      event :risolvi, :transitions_to => :RS
      event :riassegna_ad_analisi, :transition_to => :AA
      event :dichiara_obsoleta, :transition_to => :OB
    end

    state :RS, :meta => {:order => 6} do
      on_entry do
        consegna_flg = 0
      end
      event :valida, :transitions_to => :VL     
      event :riassegna_a_sviluppo, :transition_to => :AS
    end

    state :VL, :meta => {:order => 10} do
      on_entry do
        consegna_flg = 0
      end
    end

    state :RF, :meta => {:order => 10} do
      on_entry do
        consegna_flg = 0
      end
    end

    state :RI, :meta => {:order => 3} do
      on_entry do
        consegna_flg = 0
      end
    end

    state :OB, :meta => {:order => 10} do
      on_entry do
        consegna_flg = 0
      end
    end

  end
    
  # ============ VALIDATORI ============ 
  #validates_presence_of :prodotto
  
  scope :time_span, lambda { |da, time_span_behind| where("dtm_risoluzione between ? and ?", da - time_span_behind, da) }
  scope :time_span_by_today, lambda { |time_span_behind| time_span(Time.zone.now, time_span_behind) }
  scope :ultimo_mese, time_span(Time.zone.now, 1.month)
  scope :assegnate, where('cda_stato in (?)', ['AS', 'AA'])
  scope :in_consegna, where('consegna_flg = 1')
  scope :in_todo, lambda { |user| where("(cda_risolutore = ? and cda_stato in ('VE', 'AA', 'AR', 'AS' )) or (cda_risolutore_ana = ? and cda_stato in ('VE', 'AA')) or (cda_validatore = ? and cda_stato in ('VE', 'AA', 'AR', 'AS', 'RS'))", user, user, user) }
  scope :risolte, where('cda_stato in (?)', ['RS', 'VL'])
  scope :risolutore_or_risolutore_analisi, lambda { |user| where("cda_risolutore = ? or cda_risolutore_ana = ?", user, user) }
  scope :risolutore, lambda { |user| where("cda_risolutore = ?", user) }
  scope :risolutore_analisi, lambda { |user| where("cda_risolutore_ana = ?", user) }
  scope :risolutori, lambda { |users| where("cda_risolutore in (?)", users) }
  scope :risolutori_analisi, lambda { |user| where("cda_risolutore_ana = in (?) ", users) }
  scope :involved, lambda { |user| where("? in (cda_segnalatore, cda_verificatore, cda_risolutore_ana, cda_risolutore, cda_validatore)", user) }
  scope :involved_as_resolver, lambda { |user| where("? in (cda_risolutore_ana, cda_risolutore, cda_validatore)", user) }
  
  scope :chiuse, where("cda_stato in ('VL', 'RI', 'RF', 'OB')")
  scope :chiuse_da, lambda { |user| chiuse.where("? in (cda_risolutore_ana, cda_risolutore, cda_validatore)", user) }
  scope :fatte_da, lambda { |user| where("(cda_risolutore_ana = ? and cda_stato in ('AS', 'RS', 'VL', 'RI', 'RF', 'OB')) or (cda_risolutore = ? and cda_stato in ('RS', 'VL', 'RI', 'RF', 'OB'))", user, user) }
  scope :versione_prodotto,  lambda { |versione, prodotto| where("cda_versione_pian = ? and cda_prodotto = ?", versione, prodotto) }
  
  def self.search(search, page)
    paginate :per_page => 10, :page => page, :conditions => ['name like ?', "%#{search}%"], :order => 'name'
  end

  def self.find_by_user_todo(user_id)
    Segnalazione.in_todo(user_id)
  end
  
  def self.count_by_user_and_stato(user_id, stato)
    Segnalazione.risolutore(user_id).where(:cda_stato => stato).count
  end
  
  def self.risolte_ultimo_mese(user_id)
    Segnalazione.risolutore(user_id).risolte.ultimo_mese
  end
  
  def self.min_max_num_segna_utlimo_mese()
    Segnalazione.ultimo_mese.risolte.select("count(*) as num_segna").group(:cda_risolutore).order("num_segna DESC")
  end
  
  def self.performance_score_by_user_over_time(user_name, time_span = nil)
    rel = Segnalazione.risolutori(user_name).select("cda_risolutore, sum(NVL(tempo_risol_stimato,1))/sum(NVL(tempo_risol_impiegato,1)) as performance").group(:cda_risolutore).having("sum(nvl(tempo_risol_impiegato,1)) > 0")
    rel = rel.time_span_by_today(time_span) if time_span
    rel.order("performance ASC")
  end
  
  def self.num_segna_by_user_over_time(user_name)
    Segnalazione.risolutori(user_name).risolte.select("cda_risolutore, TO_CHAR(dtm_risoluzione,'yyyy mm MON-yy') as mese, count(*) AS num_segna").group("cda_risolutore, TO_CHAR(dtm_risoluzione,'yyyy mm MON-yy')").order("mese ASC")
  end
  
  def self.performance_score_by_user_by_time(user_name)
    Segnalazione.risolutori(user_name).select("cda_risolutore, sum(NVL(tempo_risol_stimato,1))/sum(NVL(tempo_risol_impiegato,1)) as performance, TO_CHAR(dtm_risoluzione,'yyyy mm MON-yy')").group("cda_risolutore, TO_CHAR(dtm_risoluzione,'yyyy mm MON-yy')").having("sum(nvl(tempo_risol_impiegato,1)) > 0")
  end
  
  def gravita_des
    Gravita.des(cdn_gravita)
  end

  def priorita_des
    Priorita.des(cdn_priorita.to_i)
  end

  def stato_des
    StatoSegnalazione.des(cda_stato)
  end
  
  def lavorabilita(user)
    res = "CLOSED"
    my_cda_stato = StatoSegnalazione.find_by_cda_stato(cda_stato);
    if (ready_for?(user) and not consegna_flg)
      res = "READY"
    elsif (stati_che_coinvolgono(user).inject(false) {|n, stato| n ||= stato > my_cda_stato })
      res = "WAIT"
    elsif (ready_for?(user) and consegna_flg)
      res = "IN LAVORAZIONE"
    end
    return res
  end
  
  def is_lavorabile_or_in_lavorazione(user)
    grp = lavorabilita(user)
    grp.eql?("READY") or grp.eql?("IN LAVORAZIONE")  
  end
  
  def is_in_stato?(stato)
    cda_stato == stato
  end

  def chiusa?
    vl? || ob? || ri? || rf? 
  end

  def fatta_for?(user)
    (actor_associated_to(:AA).eql?(user) and overcame?(:AA) and has_to_be?(:VL) and not actor_associated_to(:AS).eql?(user)) or (actor_associated_to(:AS).eql?(user) and overcame?(:AS) and has_to_be?(:VL)) 
  end

  def ready_for?(user)
    case cda_stato
      when 'SE'
      cda_verificatore == user       
      when 'AA'
      cda_risolutore_ana == user
      when 'AS'
      cda_risolutore == user
      when 'RS'
      cda_validatore == user
    else false     
    end
  end
  
  def wait_for?(user)
    
  end
  
  def tempo_stimato
    if aa?
      tempo_ris_ana_stimato
    elsif as?
      tempo_risol_stimato
    elsif rs?
      tempo_val_stimato
    else 
      0
    end
  end
  
  def performance_score
    ore_stima = :tempo_risol_stimato ? :tempo_risol_stimato : 1
    ore_impiegate = :tempo_risol_impiegato ? :tempo_risol_impiegato : 1;
    ore_stima / ore_impiegate
  end
  
  def aa?
    is_in_stato? 'AA'
  end
  
  def as?
    is_in_stato? 'AS'
  end

  def ob?
    is_in_stato? 'OB'
  end

  def rs?
    is_in_stato? 'RS'
  end

  def ri?
    is_in_stato? 'RI'
  end

  def rf?
    is_in_stato? 'RF'
  end

  def se?
    is_in_stato? 'SE'
  end

  def ve?
    is_in_stato? 'VE'
  end

  def vl?
    is_in_stato? 'VL'
  end

  def anomalia?
    cda_tipo_segna == 'A'
  end

  def sviluppo?
    cda_tipo_segna == 'S'
  end

  def richiesta?
    cda_tipo_segna == 'R'
  end

  def tipo
    case cda_tipo_segna
      when 'A'
        'Anomalia'
      when 'S'
        'Sviluppo prodotto'
      when 'R'
        'Richiesta implementazione'
    else 'Sconosciuto'     
    end
  end
  
  # Virtual Attributres
  def cod_prodotto
    prodotto.cda_prodotto if prodotto
  end
  
  def cod_prodotto=(cda_prodotto)
    self.prodotto = Prodotto.find_by_cda_prodotto(cda_prodotto) unless cda_prodotto.blank?
  end
  
  def versione_pianificata
    cda_versione_pian ? cda_versione_pian : "Non pianificate" 
  end
  
  def stati_che_coinvolgono(user)
    stati = []
    stati << StatoSegnalazione.find_by_cda_stato('VE') if cda_verificatore == user 
    stati << StatoSegnalazione.find_by_cda_stato('AA') if cda_risolutore_ana == user 
    stati << StatoSegnalazione.find_by_cda_stato('AS') if cda_risolutore == user 
    stati << StatoSegnalazione.find_by_cda_stato('RI') if cda_validatore == user 
    stati
  end
  
  def actors
    people = Array.new
    spec.states.keys.each do |stato_sym|
      actor = actor_associated_to(stato_sym)
      people << actor if actor
    end
    people
  end

  def actor_associated
    case cda_stato
      when 'SE'
      cda_verificatore
      when 'AA'
       (utente(cda_verificatore || cda_segnalatore) + ' ' + 8594.chr + ' ' + utente(cda_risolutore_ana)).html_safe if cda_risolutore_ana
      when 'AS'
       (utente(cda_risolutore_ana || cda_verificatore || cda_segnalatore) + ' ' + 8594.chr + ' ' + utente(cda_risolutore)).html_safe if cda_risolutore
      when 'RS'
       (utente(cda_risolutore || "") + ' ' + 8594.chr + ' ' + utente(cda_validatore || cda_verificatore)).html_safe if (cda_validatore || cda_verificatore)
    end
  end

  def actor_associated_to(state_as_simbol)
    case state_as_simbol
      when :VE
        cda_verificatore
      when :AA
        cda_risolutore_ana
      when :RA
        cda_risolutore_ana
      when :AS
        cda_risolutore
      when :VL
        cda_validatore
    end
  end

  def involved_as_resolver(user)
    [actor_associated_to(:AA), actor_associated_to(:AS), actor_associated_to(:VL)].include?(user.user_id)
  end

  def actor_associated_to_current_state
    actor_associated_to(current_state.name)
  end

  def date_associated
    case cda_stato
      when 'SE'
        "il #{dtm_creaz}"
      when 'AA'
      nil
      when 'AS'
      nil
      when 'RS'
        "il #{dtm_risoluzione}"
    end    
  end

  def tempi_analisi
    [tempo_ris_ana_stimato, tempo_ris_ana_impiegato]
  end

  def tempi_risoluzione
    [tempo_risol_stimato, tempo_risol_impiegato]
  end
  
  def tempi_validazione
    [tempo_val_stimato, tempo_val_impiegato]
  end

  def cliente_des
    Cliente.find_by_cda_cliente(cda_cliente).des_cliente
  end

  def modulo_des
    Modulo.find_by_cda_modulo(cda_modulo).des_modulo
  end
  
  def task_des
    Task.find_by_task_id(task_id).des_task
  end

  def priorita
    (5 - cdn_priorita.to_i) % 5
  end

  def gravita
    (5 - cdn_gravita.to_i) % 5
  end

  def previous_state(state)
    case state.name
      when :OB, :RI, :RF, :AA
        :VE
      when :VL
        :RS
      when :RS
        :AS
      when :AS
        cda_risolutore_ana ? :RA : :VE 
      when :RA
        :AA
      when :VE
        :SE
    end      
  end

  def funzione_label
    programma = Programma.find_by_cda_programma(cda_programma)
    return '[' << cda_programma << '] - ' << programma.des_programma if programma
  end

  def title
    (/\s*#(.*)#.*/.match(des_segna) || [des_segna])[0] 
  end
end
