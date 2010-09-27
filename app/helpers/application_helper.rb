# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  require 'rdiscount'

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

  def tipo_segnalazione_image(segnalazione_or_tipo, options = {})
    tipo = segnalazione_or_tipo.respond_to?(:cda_tipo_segna) ? segnalazione_or_tipo.cda_tipo_segna : segnalazione_or_tipo 
    todo = params[:controller] == 'todo'
    case tipo
      when 'A'
        image_tag "/images/bug#{todo ? '16' : '22'}.png", options
      when 'R'
        image_tag "/images/rich_impl#{todo ? '16' : '22'}.png", options
      when 'S'
        image_tag "/images/svil#{todo ? '16' : '22'}.png", options
    end    
  end

  def markdown(text)
    RDiscount.new(text, :filter_html).to_html
  end
  
  def clippy(text, bgcolor='#FFFFFF')
    html = <<-EOF
      <object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000"
              width="110"
              height="14"
              id="clippy" >
      <param name="movie" value="/flash/clippy.swf"/>
      <param name="allowScriptAccess" value="always" />
      <param name="quality" value="high" />
      <param name="scale" value="noscale" />
      <param NAME="FlashVars" value="text=#{text}">
      <param name="bgcolor" value="#{bgcolor}">
      <embed src="/flash/clippy.swf"
             width="110"
             height="14"
             name="clippy"
             quality="high"
             allowScriptAccess="always"
             type="application/x-shockwave-flash"
             pluginspage="http://www.macromedia.com/go/getflashplayer"
             FlashVars="text=#{text}"
             bgcolor="#{bgcolor}"
      />
      </object>
    EOF
  end

  # Invocazione: progress_bar(value, :width => '80px')
  def progress_bar(array, options={})
    if array[0][2] == -1
      content_tag('p', t(:no_issue), :class => 'pourcent').html_safe
    else
      pcts = array[1]
      done_perc = pcts[1].floor
      pcts[1] = pcts[1] - pcts[0]
      pcts << (100 - pcts[1] - pcts[0])
      width = options[:width] || '300px;'
      legend = options[:legend] || "#{done_perc}%"
      content_tag('table',
        content_tag('tr',
          ((pcts[0] > 0 ? content_tag('td', "#{array[0][0]} (#{pcts[0].floor}%)", :style => "width: #{pcts[0].floor}%;", :class => 'closed') : '') +
          (pcts[1] > 0 ? content_tag('td', "#{array[0][1] - array[0][0]} (#{pcts[1].floor}%)", :style => "width: #{pcts[1].floor}%;", :class => 'done') : '') +
          (pcts[2] > 0 ? content_tag('td', "#{array[0][2] - array[0][1]} (#{pcts[2].floor}%)", :style => "width: #{pcts[2].floor}%;", :class => 'todo') : '')).html_safe
        ), :class => 'progress', :style => "width: #{width};") +
        content_tag('p', legend, :class => 'pourcent').html_safe
    end
  end
  
  def due_date_distance_in_words(date)
    if date
      l((date < Date.today ? :label_roadmap_overdue : :label_roadmap_due_in), distance_of_date_in_words(Date.today, date))
    end
  end

  def link_to_segnalazione(segnalazione, options={})
    options[:class] ||= ''
    options[:class] << ' segnalazione'
    options[:class] << ' closed' if segnalazione.chiusa?
    link_to "#{segnalazione.prg_segna}", {:controller => "segnalazioni", :action => "show", :id => segnalazione}, options
  end

end
