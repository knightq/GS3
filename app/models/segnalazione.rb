class Segnalazione < ActiveRecord::Base
  set_table_name "FW_SEGNA"
  
  belongs_to :gravita, :foreign_key => 'cdn_gravita', :class_name => 'Gravita'
  belongs_to :risolutore, :foreign_key => 'cda_risolutore', :class_name => 'Utente'
  belongs_to :risolutore_analisi, :foreign_key => 'cda_risolutore_ana', :class_name => 'Utente'
  belongs_to :prodotto, :foreign_key => 'cda_prodotto', :class_name => 'Prodotto'

  # ====== STATI DELLA SEGNALAZIONE ====== 
  include Workflow
  
  # Workflow.create_workflow_diagram(Segnalazione, './')
  workflow_column :cda_stato
  workflow do
    state :segnalata, :meta => {:order => 1} do
      event :verifica, :transitions_to => :verificata
    end

    state :verificata, :meta => {:order => 2} do
      on_entry do
        consegna_flg = 0
      end
      event :assegna_a_analisi, :transitions_to => :analisi_assegnata
      event :assegna_a_sviluppo, :transitions_to => :assegnata
      event :rifiuta, :transitions_to => :rifiutata
      event :rimanda, :transitions_to => :rimandata
    end

    state :analisi_assegnata, :meta => {:order => 3} do
      on_entry do
        consegna_flg = 0
      end
      event :risolvi_analisi, :transitions_to => :analisi_risolta
    end

    state :analisi_risolta, :meta => {:order => 4} do
      on_entry do
        consegna_flg = 0
      end
      event :assegna_a_sviluppo, :transitions_to => :assegnata
    end

    state :assegnata, :meta => {:order => 5} do
      on_entry do
        consegna_flg = 0
      end
      event :risolvi, :transitions_to => :risolta
      event :riassegna_ad_analisi, :transition_to => :analisi_assegnata
      event :dichiara_obsoleta, :transition_to => :obsoleta
    end

    state :risolta, :meta => {:order => 6} do
      on_entry do
        consegna_flg = 0
      end
      event :valida, :transitions_to => :validata     
      event :riassegna_a_sviluppo, :transition_to => :assegnata
    end

    state :validata, :meta => {:order => 10} do
      on_entry do
        consegna_flg = 0
      end
    end

    state :rifiutata, :meta => {:order => 10} do
      on_entry do
        consegna_flg = 0
      end
    end

    state :rimandata, :meta => {:order => 3} do
      on_entry do
        consegna_flg = 0
      end
    end

    state :obsoleta, :meta => {:order => 10} do
      on_entry do
        consegna_flg = 0
      end
    end

  end
  
  def load_workflow_state
    case cda_stato
      when 'SE'
        :segnalata
      when 'VE'
        :verificata
      when 'AA'
        :analisi_assegnata
      when 'RA'
        :analisi_risolta
      when 'AS'
        :assegnata
      when 'RS'
        :risolta
      when 'VL'
        :validata
      when 'RF'
        :rifiutata
      when 'RI'
        :rimandata
      when 'OB'
        :obsoleta
    end
  end

  def persist_workflow_state(new_value)
    case new_value
      when :segnalata
        cda_stato = 'SE'
      when :verificata
        cda_stato = 'VE'
      when :analisi_assegnata
        cda_stato = 'AA'
      when :analisi_risolta
        cda_stato = 'RA'
      when :assegnata
        cda_stato = 'AS'
      when :risolta
        cda_stato = 'RS'
      when :validata
        cda_stato = 'VL'
      when :rifiutata
        cda_stato = 'RF'
      when :rimandata
        cda_stato = 'RI'
      when :obsoleta
        cda_stato = 'RI'
    end
    save!
  end

    
  # ============ VALIDATORI ============ 
  validates_presence_of :prodotto
  
  scope :time_span, lambda { |da, time_span_behind| where("dtm_risoluzione between ? and ?", da - time_span_behind, da) }
  scope :time_span_by_today, lambda { |time_span_behind| time_span(Time.zone.now, time_span_behind) }
  scope :ultimo_mese, time_span(Time.zone.now, 1.month)
  scope :assegnate, where('cda_stato in (?)', ['AS', 'AA'])
  scope :in_consegna, where('consegna_flg = 1')
  scope :in_todo, lambda { |user| where("(cda_risolutore = ? and cda_stato = 'AS') or (cda_risolutore_ana = ? and cda_stato = 'AA') or (cda_validatore = ? and cda_stato = 'RS')", user, user, user) }
  scope :risolte, where('cda_stato in (?)', ['RS', 'VL'])
  scope :risolutore_or_risolutore_analisi, lambda { |user| where("cda_risolutore = ? or cda_risolutore_ana = ?", user, user) }
  scope :risolutore, lambda { |user| where("cda_risolutore = ?", user) }
  scope :risolutore_analisi, lambda { |user| where("cda_risolutore_ana = ?", user) }
  scope :risolutori, lambda { |users| where("cda_risolutore in (?)", users) }
  scope :risolutori_analisi, lambda { |user| where("cda_risolutore_ana = in (?) ", users) }
  
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
  
  def rs?
    is_in_stato? 'RS'
  end
  
  def ve?
    is_in_stato? 'VE'
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
    puts "SET cod_prodotto!!!! #{cda_prodotto}"
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
  
  def actor_associated
    case cda_stato
      when 'SE'
      cda_verificatore
      when 'AA'
       ((cda_verificatore || "") + " --> " + cda_risolutore_ana) if cda_risolutore_ana
      when 'AS'
       ((cda_risolutore_ana || "") + " --> " + cda_risolutore) if cda_risolutore
      when 'RS'
       ((cda_risolutore || "") + " --> " + (cda_validatore || cda_verificatore)) if (cda_validatore || cda_verificatore)
    end
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

end
