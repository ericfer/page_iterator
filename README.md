# PageIterator

The idea is splitting a large number of data in small parts (pagination concept) and iterating through them, so the execution of your script, batch file, rake task and so on, can be better managed in terms of CPU and memory.  
The differential of **PageIterator** is that it keeps track of each iterated page in a log file. If the iteration was interrupted for any reason, the next execution of that iteration is going to start from the page it was previously interrupted.

## Installation

    gem install page_iterator

### Usage
    page_iterator = PageIterator.new(<NUMBER_OF_TOTAL_ITEMS>, <FILENAME_TO_LOG>, [<NUMBER_OF_ITEMS_PER_PAGE>])

    page_iterator.each_remaining_page! do |page|
        # do something here
    end

### PageIterator Resources
* `page_iterator.each_remaining_page! { |page| }` - iterates through each page passing the current page number as parameter to the block
* `page_iterator.next!` - increments one page and logs it to filesystem. **PageIterator** execute it after each iteration of `each_remaining_page!` method.
* `page_iterator.previous!` - decrement one page and logs it to filesystem.
* `page_iterator.total_pages` - total number of pages
* `page_iterator.remaining_items` - number of remaining items to be iterated through pages
* `page_iterator.remaining_pages` - range of remaining pages to be iterated
* `page_iterator.per_page` - number of items per page. Default: 50


### Limitations
There is plenty room for improvements, but so far **PageIterator** just splits the total number of items to be processed, gets page numbers and other numbers calculated from the initial data, but it doesn't iterate through the items themselves. It's still needed a pagination mechanism for the items.


### Applied Usage Example
The example below shows **PageIterator** in action.

Consider the following class:

    class Person
      include MongoMapper::Document
      key :name, String
      key :status, String
      timestamps!
    end

It could be any other Mapping layer of any other type of database that provides pagination feature.

If you want to iterate through all records from the database an amount at a time, you can do the following

     STDOUT.sync = true
     STDOUT.write "Running..."
 
     page_iterator = PageIterator.new(Person.count, "current_page.log")

     STDOUT.write "\n - #{Person.to_s} (#{page_iterator.remaining_items}/#{page_iterator.total_items})"
     page_iterator.each_remaining_page! do |page|
       person_list = Person.paginate(:per_page => page_iterator.per_page , :page => page)
       person_list.each do |person| 
         person.status = 'active'
         if person.save
           STDOUT.write "."
         else
           STDOUT.write "F"
           exit(1)
         end
       end  
     end

Output:

    Running...
     - Person (60/60)....................................................... done

The script is processing all Person records, 50 at a time, and setting the status to *active*. If something goes wrong, the script will print *F* in the screen and exit. So, after you fix the reason of the failure (*F*) and run the script again, **PageIterator** is going to start the execution from the page where the failure happened, and not since the beginning of the collection.  
It's possible to see that it's still needed a pagination mechanism for the items themselves, like the `paginate` method that MongoMapper provides.


## Project
* https://github.com/ericfer/page_iterator

## Report bugs and suggestions
* [Issue Tracker](https://github.com/ericfer/page_iterator/issues)

## Author
* [Eric Fer](https://github.com/ericfer)
