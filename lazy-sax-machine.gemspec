# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name    = "lazy-sax-machine"
  s.version = File.read("VERSION").strip
  s.date    = File.mtime("VERSION").strftime("%Y-%m-%d")

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=

  authors = [
    ["Paul Dix", "paul@pauldix.net"],
    ["Greg Weber", "greg@gregweber.info"],
    ["Ezekiel Templin", "zeke@templ.in"],
    ["Chris Gahan", "chris@ill-logic.com"]
  ]
  s.authors, s.email = authors.transpose

  s.description = "Parse (huge) XML documents into Ruby objects with a nifty declarative language!"
  s.summary     = "Tired of writing parsers for XML files? Now you can parse XML into Ruby objects with ease! SAXMachine provides a simple declarative language for describing how to convert XML into Ruby objects."
  s.homepage    = "https://github.com/epitron/lazy-sax-machine"
  s.licenses    = ["MIT"]

  s.files            = `git ls-files -z`.split("\0")
  s.test_files       = `git ls-files -z -- spec/*`.split("\0")
  s.extra_rdoc_files = ["README.md"]
  s.require_paths    = ["lib"]

  s.add_dependency("nokogiri", "> 1.4")
end
