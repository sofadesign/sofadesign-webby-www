module SofaDesignHelper
  def full_file_path(filename)
    timestamped_url("/" + @page.dir + "/" + filename)
  end
  
  def timestamped_url(path)
    page = Webby::Resources.pages.find do |resource|
      resource.url == path
    end
    if page
      if page.dirty?
        # copy the resource to the output directory if it is static
        if page.instance_of? Webby::Resources::Static
          FileUtils.mkdir_p ::File.dirname(page.destination)
          journal.create_or_update(page)
          FileUtils.cp page.path, page.destination
          FileUtils.chmod 0644, page.destination

        # otherwise, layout the resource and write the results to
        # the output directory
        else
          dest = page.destination
          renderer = Webby::Renderer.new page
          FileUtils.mkdir_p ::File.dirname(dest)
          journal.create_or_update(page)

          text = Webby::Filters.process(renderer, page, page._read)
          unless text.nil?
            ::File.open(dest, 'w') {|fd| fd.write(text)}
          end
        end
      end
    end
    
    path << '?' << page.mtime.to_i.to_s if page
    path
  end
  
  def merge_files(*filenames)
    sources = filenames.flatten
    asset_path = ::Webby.site.content_dir
    merged_file = ""
    sources.each do |s|
      path = File.join(asset_path, s)    
      File.open(path, "r") do |f| 
        merged_file << f.read + "\n" 
      end
    end
    merged_file
  end
  
  def merged_and_compressed_js(*filenames)  
    
    merged_path = File.join '', 'js', 'all.js'
    path = File.join(Webby.site.output_dir, merged_path)
    
    # test if it needs to be updated
    merged_exists = File.exist? path
    needs_update = !merged_exists
    
    filenames.each do |fn|
      resource = Webby::Resources.new File.join(Webby.site.content_dir, fn)
      if resource.dirty?
        needs_update = merged_exists ? File.mtime(path).to_i < resource.mtime.to_i : true
        break
      end
    end

    if needs_update
      source = compress_js(merge_files(filenames))
      FileUtils.mkdir_p File.dirname(path)
      File.open(path, "w") {|f| f.write(source)}
      if merged_exists 
        journal.update(path)
      else
        journal.create(path)
      end
    end

    merged_path << '?' << File.mtime(path).to_i.to_s

  end
  
  def compress_js(source)
    lib_path     = File.dirname(__FILE__)
    project_path = File.dirname(lib_path)
    jsmin_path   = File.join project_path, 'scripts'
    tmp_path     = File.join project_path, 'tmp', ''

    # write out to a temp file
    File.open("#{tmp_path}_uncompressed.js", "w") {|f| f.write(source) }

    # compress file with JSMin library
    `ruby #{jsmin_path}/jsmin.rb <#{tmp_path}_uncompressed.js >#{tmp_path}_compressed.js \n`

    # read it back in and trim it
    result = ""
    File.open("#{tmp_path}_compressed.js", "r") { |f| result += f.read.strip }

    # delete temp files if they exist
    File.delete("#{tmp_path}_uncompressed.js") if File.exists?("#{tmp_path}_uncompressed.js")
    File.delete("#{tmp_path}_compressed.js") if File.exists?("#{tmp_path}_compressed.js")

    result
  end
end

Webby::Helpers.register(SofaDesignHelper)

# EOF
