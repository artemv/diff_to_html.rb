#require File.join(File.dirname(__FILE__), '../lib/diff_to_html.rb')
require 'rubygems'
require 'diff_to_html'
require File.join(File.dirname(__FILE__), 'test.rb')
filename = ARGV[0]
diff = `cat #{filename}`
converter = SvnDiffToHtml.new
out(diff, converter, filename)
