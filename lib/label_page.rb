class LabelPage < Page
  def virtual? ; true ; end

  def find_by_url(url, live=true, clean=true)
    url = clean_url(url) if clean
    re = /^#{self.url}([^\/]+)\/$/
    m = url.match(re)
    if m
      # show cached / overwritten page
      if child=children.find_by_slug(m[1]) and child.published?
        child
      else
        @label = Tag.find_by_slug(m[1])
        if @label
          lazy_initialize_parser_and_context
          @context.globals.label = @label
          self
        else
          super
        end
      end
    else
      super
    end
  end

  def title
    @label ? @label.name : read_attribute('title')
  end

end
