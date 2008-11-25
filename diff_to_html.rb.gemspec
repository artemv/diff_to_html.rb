Gem::Specification.new do |s|
  s.name = 'diff_to_html'
  s.version = '1.0.3'
  s.date = '2008-05-23'
  
  s.summary = "Unified diff to HTML converter"
  s.description = "Generates HTML view of given unified diff"
  
  s.authors = ['Artem Vasiliev']
  s.email = 'abublic@gmail.com'
  s.homepage = 'http://github.com/artemv/diff_to_html.rb'
  
  s.has_rdoc = true
  s.rdoc_options = ['--main', 'README.rdoc']
  s.rdoc_options << '--inline-source' << '--charset=UTF-8'
  s.extra_rdoc_files = ['README.rdoc']
  
  s.files = %w(lib/diff_to_html.rb examples/diff.css examples/diff.git examples/diff.svn examples/test_git_diff.rb examples/test_svn_diff.rb examples/test.rb examples/test.sh lib README.rdoc)
end