class Array
  def somma
    inject(0.0) { |result, el| result + el }
  end

  def media 
    somma / size
  end
end
