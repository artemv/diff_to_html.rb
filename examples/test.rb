require 'diff_to_html'
diff = `svn diff -r 46:47 svn://hamptoncatlin.com/haml --diff-cmd diff -x "-w -U 2"`

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