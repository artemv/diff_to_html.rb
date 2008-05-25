require 'rubygems'
gem 'artemv-diff_to_html'
require 'diff_to_html'
#require '../lib/diff_to_html.rb'
#diff = `svn diff -r 46:47 svn://hamptoncatlin.com/haml --diff-cmd diff -x "-U 2"`
diff = `cat diff`
puts <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
<head>
  <link type="text/css" rel="stylesheet" href="diff.css">
  <title>diff of HAML revision 47</title>
</head>
<body>
#{DiffToHtml.new.get_diff(diff)}
</body>
</html>
EOF