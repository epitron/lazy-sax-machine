# Lazy SAX Machine

## Description

Tired of writing parsers for XML files? Now you can parse XML into Ruby objects with ease! SAXMachine provides a simple declarative language for describing how to convert XML into Ruby objects.

This is Lazy version of [SAXMachine](https://github.com/pauldix/sax-machine) which lets you parse huge XML files (by streaming the objects one at a time as the XML file is parsed, instead of loading the whole thing into memory and crashing your machine.)

## Installation

Add these lines to your application's Gemfile:

```ruby
gem 'lazy-sax-machine'
gem 'nokogiri'
```

And then execute:

```bash
$ bundle
```

## Usage

SAX Machine currently only supports `nokogiri`, but eventually it will try to find the best XML library automatically. (First looking for `ox`, then `oga, then `nokogiri`.)


## Examples

### Lazy parsing/Enumerator - Constant memory usage

The Nokogiri Sax parser already operates in constant memory with respect to the file contents. However, Sax Machine fills up memory as it creates your Ruby objects. Using the laziness option will parse top-level elements one at a time- allowing for constant memory usage with respect to the Ruby objects.
The lazy option only allows *one* set of elements to be declared as lazy.

```ruby
class Atom
  include SAXMachine
  element :title
  elements :entry, :lazy => true, :as => :entries, :class => AtomEntry
end

feed = Atom.parse(xml_file_handle, :lazy => true)
feed.entries # => #<Enumerator: #<Enumerator::Generator:0x00000004c41ea0>:each> 
feed.entries.each do |entry|
  # every time the block is called the next entry is parsed- no memory blow up!
  #
  # This is probably where you save the entry to a database
end
```

#### Warning !!!
* If you use the lazy option twice, or if the class using this laziness is referenced from multiple other classes, the behavior will be incorrect.
* Does not work with Ruby version 1.8. Uses ruby fibers and Enumerator capabilities, both of which were added in Ruby version 1.9.

#### Caution
* The overall speed with laziness may be slower if you can already fit everything into memory.
* Once you traverse an enumerator (with #each), it will be empty.


### Eager Parsing

Include `SAXMachine` in any class and define properties to parse:

```ruby
class AtomContent
  include SAXMachine
  attribute :type
  value :text
end

class AtomEntry
  include SAXMachine

  element :title

  def title=(val)
    @title = val.titlecase
  end

  # The :as argument makes this available through entry.author instead of .name
  element :name, as: :author
  element "feedburner:origLink", as: :url
  # The :default argument specifies default value for element when it's missing
  element :summary, class: String, default: "No summary available"
  element :content, class: AtomContent
  element :published
  ancestor :ancestor
end

class Atom
  include SAXMachine
  # Use block to modify the returned value
  # Blocks are working with pretty much everything,
  # except for `elements` with `class` attribute
  element :title do |title|
    title.strip
  end
  # The :with argument means that you only match a link tag
  # that has an attribute of type: "text/html"
  element :link, value: :href, as: :url, with: {
    type: "text/html"
  }
  # The :value argument means that instead of setting the value
  # to the text between the tag, it sets it to the attribute value of :href
  element :link, value: :href, as: :feed_url, with: {
    type: "application/atom+xml"
  }
  elements :entry, as: :entries, class: AtomEntry
end
```

Then parse any XML with your class:

```ruby
feed = Atom.parse(xml_text)

feed.title # Whatever the title of the blog is
feed.url # The main URL of the blog
feed.feed_url # The URL of the blog feed

feed.entries.first.title # Title of the first entry
feed.entries.first.author # The author of the first entry
feed.entries.first.url # Permalink on the blog for this entry
feed.entries.first.summary # Returns "No summary available" if summary is missing
feed.entries.first.ancestor # The Atom ancestor
feed.entries.first.content # Instance of AtomContent
feed.entries.first.content.text # Entry content text
```

You can also use the elements method without specifying a class:

```ruby
class ServiceResponse
  include SAXMachine
  elements :message, as: :messages
end

response = ServiceResponse.parse("
  <response>
    <message>hi</message>
    <message>world</message>
  </response>
")
response.messages.first # hi
response.messages.last  # world
```

To limit conflicts in the class used for mappping, you can use the alternate
`SAXMachine.configure` syntax:

```ruby
class X < ActiveRecord::Base
  # This way no element, elements or ancestor method will be added to X
  SAXMachine.configure(X) do |c|
    c.element :title
  end
end
```

Multiple elements can be mapped to the same alias:

```ruby
class RSSEntry
  include SAXMachine
  # ...
  element :pubDate, as: :published
  element :pubdate, as: :published
  element :"dc:date", as: :published
  element :"dc:Date", as: :published
  element :"dcterms:created", as: :published
end
```

If more than one of these elements exists in the source, the value from the *last one* is used. The order of
the `element` declarations in the code is unimportant. The order they are encountered while parsing the
document determines the value assigned to the alias.

If an element is defined in the source but is blank (e.g., `<pubDate></pubDate>`), it is ignored, and non-empty one is picked.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## LICENSE

The MIT License

Copyright (c) 2009-2015:

* [Paul Dix](http://www.pauldix.net)
* [Julien Kirch](http://www.archiloque.net)
* [Ezekiel Templin](http://zeke.templ.in)
* [Dmitry Krasnoukhov](http://krasnoukhov.com)
* [Chris Gahan](http://github.com/epitron)

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
