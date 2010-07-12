xml.instruct! :xml, :version=>"1.0" 
xml.rows do
  @recapiti.each do |recapito|
    xml.tag!("row",{ "id" => recapito.prg_id ? recapito.prg_id : "" }) do
      xml.tag!("cell", recapito.cda_nome ? recapito.cda_nome : "")
      xml.tag!("cell", recapito.cda_cognome ? recapito.cda_cognome : "")
      xml.tag!("cell", recapito.cda_telefono ? recapito.cda_telefono : "")
      xml.tag!("cell", recapito.cda_cellulare ? recapito.cda_cellulare : "")
      xml.tag!("cell", recapito.cda_email ? recapito.cda_email : "")
    end
  end
end