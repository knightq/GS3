require 'rubygems'
require 'pdf/reader'

class MenuFromPDF

  def self.parse(pdf)
    res = Array.new
    receiver = PDF::Reader::RegisterReceiver.new
    pdf = PDF::Reader.file(pdf, receiver)
    receiver.callbacks.each do |cb|
      if cb[:name].to_s =~ /show_text/ and not (valore = cb[:args].compact.first.strip).empty? and valore =~ /^\w/ 
        res << valore
        puts valore 
      end
    end
    res
  end

end
