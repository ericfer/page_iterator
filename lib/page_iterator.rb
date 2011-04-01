class PageIterator
  DEFAULT_ITEMS_PER_PAGE = 50

  attr_reader :total_items

  def initialize(total_items, logfile, items_per_page=DEFAULT_ITEMS_PER_PAGE)
    @total_items = total_items
    @items_per_page = items_per_page
    @logfile = logfile
    @current_page = current_page_from_file
  end

  def per_page
    @items_per_page
  end

  def total_pages
    pages = @total_items / @items_per_page
    if pages == 0
      1
    else
      last_page_items = @total_items % @items_per_page
      last_page_items > 0 ? pages + 1 : pages
    end
  end

  def next!
    @current_page += 1
    log @current_page
  end
  
  def previous!
    @current_page -= 1
    log @current_page
  end

  def remaining_items
    if @current_page > total_pages
      0
    else
      @total_items - (@current_page - 1) * @items_per_page
    end
  end

  def remaining_pages
    @current_page..total_pages
  end

  def each_remaining_page!
    remaining_pages.each do |page| 
      yield page
      self.next!
    end
    self.next!
  end

  private 

  def current_page_from_file
    current_page_from_file = File.exist?(@logfile) && File.read(@logfile).chomp
    begin
      current_page_from_file = current_page_from_file.to_i
      current_page_from_file > 0 ? current_page_from_file : 1
    rescue
      1
    end
  end

  def log(page_number)
    File.open(@logfile, "w") do |file|
      file.print page_number
    end
  end
end  
