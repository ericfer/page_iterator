require 'spec_helper'

describe PageIterator, "when instantiated" do
  before do
    @total_itens = 7
    @itens_per_page = 2
    @logfile = "current_page"
    @page_iterator = PageIterator.new(@total_itens, @logfile, @itens_per_page)
  end
  
  it "should calculate the total number of pages" do
    @page_iterator.total_pages.should == 4
  end

  it "should 'next!'"
  
  it "should 'previous!'"
  
  it "should 'remaining_pages'"

  context "without specifying itens per page" do
    before do
      @page_iterator = PageIterator.new(@total_itens, @logfile)
    end
    it "should use default itens per page" do
      @page_iterator.instance_variable_get(:@itens_per_page) == PageIterator::DEFAULT_ITENS_PER_PAGE
    end
  end
  
  context "when iterating through pages" do
    context "manually" do
      context "since the first page" do
        it "should return all itens" do
          @page_iterator.remaining_itens == @total_itens
        end
      end

      context "since some page in between" do
        before do
          2.times { @page_iterator.next! }
        end

        it "should return remaining itens" do
          @page_iterator.remaining_itens == 3
        end
      end

      context "when all pages have been already iterated" do
        before do
          @page_iterator.total_pages.times { @page_iterator.next! }
        end

        it "should return zero itens" do
          @page_iterator.remaining_itens == 0
        end
      end
    end

    context "automaticaly" do
      context "using per_page from the inside of the iteration" do
        before do
          @per_pages = []
          @expected_per_pages = @page_iterator.remaining_pages.map { @page_iterator.per_page }
          @page_iterator.each_remaining_page! do |page|
            @per_pages << @page_iterator.per_page
          end
        end
        
        it "should be accessible" do
          @per_pages.should == @expected_per_pages  
        end
      end
      
      context "since the first page" do
        it "should not iterate anymore" do
          validate_iteration
        end
        
        it "should return all itens" do
          @page_iterator.remaining_itens == @total_itens
        end        
      end

      context "since some page in between" do
        before do
          2.times { @page_iterator.next! }
        end

        it "should not iterate anymore" do
          validate_iteration
        end
        
        it "should return remaining itens" do
          @page_iterator.remaining_itens == 3
        end        
      end

      context "when all pages have been already iterated" do
        before do
          @page_iterator.total_pages.times { @page_iterator.next! }
        end

        it "should not iterate anymore" do
          validate_iteration
        end
        
        it "should return zero itens" do
          @page_iterator.remaining_itens == 0
        end        
      end
    end
  end
  
  after do
    File.exist?(@logfile) && File.delete(@logfile)
  end
end

def validate_iteration
  @pages = []
  @expected_pages = @page_iterator.remaining_pages.map
  @page_iterator.each_remaining_page! do |page|
    @pages << page
  end
  @pages.should == @expected_pages
end