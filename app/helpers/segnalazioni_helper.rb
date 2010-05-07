module SegnalazioniHelper
 def display_container
#   Html.div(:id => "display_container") do |div|
#     %w(exclusive, other, none).each do |state|
#       div << display_type_section(state.titlecase, @brands[state])
#     end
#   end
 end

	def display_type_section(type, brands)
		brands ||= []
  	Html.div(:class => :display_type,
    			   :id => "display_type_#{type.downcase}") do |div|
			div << Html.h2("Brands displayed as #{type}")
    	div << table_into_cells(brands.map { |b| brand_span(b)}, 4)
    end
  end
 
  def brand_span(brand)
    Html.span(brand.name, :class => :brand_span,
        :id => dom_id(brand, :span))
  end

end
