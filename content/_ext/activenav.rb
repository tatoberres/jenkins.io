
module ActiveNav
  def active_link?(section_name, options={:css_class => 'active'})
    return options[:css_class] if page.section == section_name
  end

  def absolute_link(relative_url)
    # if it is a full url with a schema, then can't do anything with it
    return relative_url if relative_url.start_with?('https://', 'http://')

    link = [site.base_url, relative_url.sub(%r{^/}, '')].join('/')
    link.gsub(%r{/index.html$}, '/').gsub(%r{/(/)+}, '/')
  end

  def expand_link(relative_url)
    # if it is a full url with a schema, then can't do anything with it
    return relative_url if relative_url.start_with?('https://', 'http://')

    link = [URI(site.base_url).path, relative_url.sub(%r{^/}, '')].join('/')
    # if it has a file extension its a file and shouldn't get a / added
    link = link + '/' if File.extname(link).empty?
    # strip double slashes on the end
    link.gsub(/\/(\/)+/, '/')
  end

  def active_href(relative_url, text, options={:class => nil})
    classes = []
    if options[:class]
      classes << options[:class]
    end

    matcher = /^\/#{relative_url}\/index.html/

    if options[:fuzzy]
      matcher = relative_url
    end

    if page.output_path.match(matcher)
      classes << 'active'
    end
    classes = classes.join(' ')

    return [
      "<a href=\"#{expand_link(relative_url)}\" class=\"#{classes}\">",
      text,
      '</a>',
        ].join('')
  end
end
