# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  @@menu = YAML::load_file(File.join(File.dirname(__FILE__), '../../config', 'menu.yml')).symbolize_keys!

  def self.setMenu(menu)
    menu
  end
  
  def dock_menu
    controller = params[:controller]
    xml = "<div id='menu'>\n"
      if @@menu.has_key?(controller.to_sym)
        @@menu[controller.to_sym].each do |k, v|
          puts k
        end
      else
        @@menu[:global].each do |k, v|
          unless controller == k
            image = (v and v['image']) ? v['image'] : (k + "48.png")
            label = (v and v['label']) ? v['label'] : k.capitalize
            xml << "  <a href='/#{k}' title=''><img src='/images/#{image}' title='#{label}'/></a>\n"
          end
        end
      end
    xml << "</div>"
    return xml
  end

  def content_for(name, content = nil, &block)
    @has_content ||= {}
    @has_content[name] = true
    super(name, content, &block)
  end

  def has_content?(name)
    #(@has_content && @has_content[name]) || false
		true
  end

  def sidebar_bg_class
    request.env['HTTP_USER_AGENT'] =~ /Mozilla/ ? 'sidebar_bg_moz' : 'sidebar_bg_saf'
  end

	def droppable_area(opts={})
		render :partial => 'segnalazioni/in_carico', :titolo => opts[:title]
  end

  def tipo_segnalazione_image(tipo)
    todo = params[:controller] == 'todo'
    case tipo
      when 'A'
        image_tag "/images/bug#{todo ? '16' : '22'}.png"
      when 'R'
        image_tag "/images/rich_impl#{todo ? '16' : '22'}.png"
      when 'S'
        image_tag "/images/svil#{todo ? '16' : '22'}.png"
    end    
  end

end
