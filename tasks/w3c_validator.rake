namespace :validate do
 
  desc 'Validate HTML pages with W3C Validator '
  task :w3c => :build do
    Webby::W3CValidator.validate()
  end
 
end  # validate