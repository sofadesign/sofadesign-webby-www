# Render text via markdown using the RubyPants library.
if try_require('rubypants', 'rubypants')
 
  Webby::Filters.register :rubypants do |input|
    RubyPants.new(input).to_html
  end
 
# Otherwise raise an error if the user tries to use rubypants
else
  Webby::Filters.register :rubypants do |input|
    raise Webby::Error, "'rubypants' must be installed to use the rubypants filter"
  end
end
 
# EOF