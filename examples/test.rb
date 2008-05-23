require 'rubygems'
gem 'artemv-diff_to_html'
require 'diff_to_html'
#require '../lib/diff_to_html.rb'
diff = `svn diff -r 46:47 svn://hamptoncatlin.com/haml --diff-cmd diff -x "-U 2"`
#diff = `cat diff`
puts <<EOF
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
      <link type="text/css" rel="stylesheet" href="diff.css">
      <title>diff of HAML revision 47</title>
    </head>
    <body>
    #{DiffToHtml.new.get_diff(diff)}
    </body>
</html>
EOF