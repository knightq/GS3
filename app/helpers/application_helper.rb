# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def content_for(name, content = nil, &block)
    @has_content ||= {}
    @has_content[name] = true
    super(name, content, &block)
  end

  def has_content?(name)
    #(@has_content && @has_content[name]) || false
		true
  end

	def droppable_area(opts={})
		render :partial => 'segnalazioni/in_carico', :titolo => opts[:title]
	end

end
