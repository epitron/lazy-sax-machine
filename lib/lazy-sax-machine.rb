require "rubygems"

$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__))) unless $LOAD_PATH.include?(File.expand_path(File.dirname(__FILE__)))

require "lazy-sax-machine/sax_document"
require "lazy-sax-machine/sax_handler"
require "lazy-sax-machine/sax_config"
