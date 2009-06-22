# Render text via markdown using the RubyPants library.
def compress_css(source)
  source.gsub!(/\s+/, " ")           # collapse space
  source.gsub!(/\/\*(.*?)\*\//, "")  # remove comments - caution, might want to remove this if using css hacks
  source.gsub!(/\} /, "}\n")         # add line breaks
  source.gsub!(/\n$/, "")            # remove last break
  source.gsub!(/ \{ /, " {")         # trim inside brackets
  source.gsub!(/; \}/, "}")          # trim inside brackets
  source.gsub!(/^\s+/, "")           # trim leading spaces
  source
end

Webby::Filters.register :minifycss do |input|
  compress_css input
end

 
# EOF


