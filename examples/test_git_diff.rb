require File.join(File.dirname(__FILE__), '../lib/diff_to_html.rb')
require 'test.rb'
diff = `cat diff.git`
converter = GitDiffToHtml.new
out(diff, converter)
