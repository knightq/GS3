xml.instruct! :xml, :version=>"1.0" 
xml.rows do
  @prodotti.each do |prodotto|
    xml.tag!("row",{ "id" => prodotto.cda_prodotto ? prodotto.cda_prodotto : "" }) do
      xml.tag!("cell", prodotto.cda_prodotto ? prodotto.cda_prodotto : "")
      xml.tag!("cell", prodotto.des_prodotto ? prodotto.des_prodotto : "")
      xml.tag!("cell", prodotto.kim_flg ? prodotto.kim_flg : 0)
      xml.tag!("cell", prodotto.iso9000_flg ? prodotto.iso9000_flg : 0)
    end
  end
end