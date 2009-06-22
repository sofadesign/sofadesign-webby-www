# from http://radr.ca/posts/adding_support_for_ultraviolet_in_webby.html

require 'uv'

module UltraVioletHelper

  # The +uv+ method applies syntax highlighting to source code embedded
  # in a webpage. The UltraViolet highlighting engine is used for the HTML
  # markup of the source code. The page sections to be highlighted are given
  # as blocks of text to the +uv+ method.
  #
  # Options can be passed to the UltraViolet engine via attributes in the
  # +uv+ method.
  #
  #    uv( :lang => "ruby", :line_numbers => true ) do
  #     # Initializer for the class.
  #     def initialize( string )
  #       @str = stirng
  #     end
  #    end
  #    
  # The supported UltraViolet options are the following:
  #
  #    :lang               : the language to highlight (ruby, c, html, ...). defaults to plain_text
  #    :line_numbers       : true or false. defaults to false
  #    :theme              : see list of available themes in ultraviolet. defaults to SITE.uv_theme if defined or to 'mac_classic' as a last resort
  #
  def uv( *args, &block )
    opts = args.last.instance_of?(Hash) ? args.pop : {}

    buffer = eval('_erbout', block.binding)
    pos = buffer.length
    block.call(*args)

    text = buffer[pos..-1].strip
    if text.empty?
      buffer[pos..-1] = ''
      return
    end

    lang = opts.getopt(:lang, :plain_text).to_s
    line_numbers = opts.getopt(:line_numbers, false)
    theme = (opts.getopt(:theme, ::Webby.site.uv_theme) || :mac_classic).to_s

    out = '<div class="UltraViolet">'
    out << Uv.parse( text, "xhtml", lang, line_numbers, theme)
    out << '</div>'

    if @_cursor.remaining_filters.include? 'textile'
      out.insert 0, "<notextile>\n"
      out << "\n</notextile>"
    end

    buffer[pos..-1] = out
    return
  end
end  # module UltraVioletHelper

Webby::Helpers.register(UltraVioletHelper)


# EOF