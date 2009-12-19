class CategoryPage < Page
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
        @category = Category.find_by_slug(m[1])
        if @category
          lazy_initialize_parser_and_context
          @context.globals.category = @category
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
    @category ? @category.name : read_attribute('title')
  end

end
