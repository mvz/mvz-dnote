--- 
name: dnote
repositories: 
  public: git://github.com/rubyworks/dnote.git
title: DNote
contact: trans <transfire@gmail.com>
resources: 
  code: http://github.com/rubyworks/dnote
  api: http://rubyworks.github.com/dnote/rdoc
  mail: http://groups.google.com/group/rubyworks-mailinglist
  wiki: http://wiki.github.com/rubyworks/dnote
  home: http://rubyworks.github.com/dnote
requires: 
- group: 
  - build
  name: syckle
  version: 0+
- group: 
  - test
  name: lemon
  version: 0+
pom_verison: 1.0.0
manifest: 
- .ruby
- bin/dnote
- lib/dnote/core_ext.rb
- lib/dnote/format.rb
- lib/dnote/note.rb
- lib/dnote/notes.rb
- lib/dnote/session.rb
- lib/dnote/string.rb
- lib/dnote/templates/html/file.erb
- lib/dnote/templates/html/label.erb
- lib/dnote/templates/html/list.erb
- lib/dnote/templates/html.erb
- lib/dnote/templates/json/file.erb
- lib/dnote/templates/json/label.erb
- lib/dnote/templates/json/list.erb
- lib/dnote/templates/json.erb
- lib/dnote/templates/md/file.erb
- lib/dnote/templates/md/label.erb
- lib/dnote/templates/md/list.erb
- lib/dnote/templates/md.erb
- lib/dnote/templates/rdoc/file.erb
- lib/dnote/templates/rdoc/label.erb
- lib/dnote/templates/rdoc/list.erb
- lib/dnote/templates/rdoc.erb
- lib/dnote/templates/soap/file.erb
- lib/dnote/templates/soap/label.erb
- lib/dnote/templates/soap/list.erb
- lib/dnote/templates/soap.erb
- lib/dnote/templates/text/file.erb
- lib/dnote/templates/text/label.erb
- lib/dnote/templates/text/list.erb
- lib/dnote/templates/text.erb
- lib/dnote/templates/xml/file.erb
- lib/dnote/templates/xml/label.erb
- lib/dnote/templates/xml/list.erb
- lib/dnote/templates/xml.erb
- lib/dnote/templates/xoxo/file.erb
- lib/dnote/templates/xoxo/label.erb
- lib/dnote/templates/xoxo/list.erb
- lib/dnote/templates/xoxo.erb
- lib/dnote/templates/yaml/file.erb
- lib/dnote/templates/yaml/label.erb
- lib/dnote/templates/yaml/list.erb
- lib/dnote/templates/yaml.erb
- lib/dnote/version.rb
- lib/dnote/version.yml
- lib/dnote.rb
- lib/plugins/rake/task.rb
- lib/plugins/syckle/dnote.rb
- test/notes_case.rb
- try/sample.bas
- try/sample.js
- try/sample.rb
- HISTORY.rdoc
- LICENSE.txt
- README.rdoc
- VERSION
version: 1.5.0
copyright: Copyright (c) 2009 Thomas Sawyer
description: DNote makes it easy to extract developer's notes from source code, and supports almost any language.
summary: Extract developer's notes from source code
organization: RubyWorks
authors: 
- Thomas Sawyer
created: 2009-10-09