require 'w3c_validators'

module Webby
  class W3CValidator
    include W3CValidators
    
    def initialize( opts = {})
      @log = Logging::Logger[self]
      glob = ::File.join(::Webby.site.output_dir, '**', '*.html')
      @html_files = Dir.glob(glob).sort
      glob = ::File.join(::Webby.site.output_dir, '**', '*.css')
      @css_files = Dir.glob(glob).sort
      @validator = MarkupValidator.new
      @cssvalidator = CSSValidator.new
    end
    
    def validate
      @html_files.each {|fn| check_html_file fn}
      @css_files.each {|fn| check_css_file fn}
    end
    
    def check_html_file(fn)
      check_file :filename => fn
    end
    
    def check_css_file(fn)
      check_file :filename => fn, :css => true
    end
    
    def check_file(opts)
      fn = opts[:filename]
      css = opts[:css] || false
      @log.info "validating #{fn}"
      
      # instance_variable_defined?("@b")
      # instance_variable_get("@#{v}")
      
      validator = css ? @cssvalidator : @validator
      results = validator.validate_file(fn)
      if results.errors.length > 0
        @log.error "Failed: Errors found while checking #{fn}"
        results.errors.each do |err|
          journal.typed_message('error', err.to_s, :yellow)
          #@log.error err.to_s
        end
      else
        @log.info 'Passed: This document was successfully checked.'
      end
    end
    
    class << self
      def validate( opts = {} )
        new(opts).validate
      end
    end
      
  end
end