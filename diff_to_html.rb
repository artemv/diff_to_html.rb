require 'cgi'

class DiffToHtml

  attr_accessor :file_prefix
  
  #
  # globals
  #

  def ln_cell(ln, side = nil)
    anchor = "f#{@filenum}#{side}#{ln}"
    result = "<td class = 'ln'>"
    result += "<a name='#{anchor}' href='##{anchor}'>" if ln
    result += "#{ln}"
    result += "</a>" if ln
    result += "</td>"
    result
  end
  #
  # helper for building the next row in the diff
  #

  def get_diff_row(left_ln, right_ln)
    result = []
    if @left.length > 0 or @right.length > 0
      modified = (@last_op != ' ')
      if modified
        left_class = " class='r'"
        right_class = " class='a'"
        result << "<tbody class='mod'>"
      else
        left_class = right_class = ''
      end
      result << @left.map do |line| 
        x = "<tr#{left_class}>#{ln_cell(left_ln, 'l')}"
        if modified
          x += ln_cell(nil)
        else
          x += ln_cell(right_ln, 'r')
          right_ln += 1
        end
        x += "<td>#{line}</td></tr>"
        left_ln += 1
        x
      end
      if modified
        result << @right.map do |line| 
          x = "<tr#{right_class}>#{ln_cell(nil)}#{ln_cell(right_ln, 'r')}<td>#{line}</td></tr>"
          right_ln += 1
          x
        end
        result << "</tbody>"
      end
    end
    return result.join("\n"), left_ln, right_ln
  end

  #
  # build the diff
  #

  def range_row(range)
    "<tr class='range'><td>...</td<td>...</td><td>#{range}</td></tr>"
  end

  def range_info(range)
    range.match(/^@@ \-(\d+),\d+ \+(\d+),\d+ @@/)
    left_ln = Integer($1)
    right_ln = Integer($2)
    return left_ln, right_ln
  end

  def begin_file(file)
    @filenum ||=0
    result = <<EOF 
<li><h2><a name="F#{@filenum}" href="#F#{@filenum}">#{@file_prefix}#{file}</a></h2><table class='diff'>
<colgroup>
<col class="lineno"/>
<col class="lineno"/>
<col class="content"/>
</colgroup>
EOF
  @filenum += 1
  result
  end
  
  def flush_changes(result, left_ln, right_ln)
    x, left_ln, right_ln = get_diff_row(left_ln, right_ln)
    result << x
    @left.clear
    @right.clear    
    return left_ln, right_ln
  end
  
  def get_diff(diff_file)
    @last_op = ' '
    @left = []
    @right = []
  
    result = ""

    diff = diff_file.split("\n")
    
    index = diff.shift
    file = index[7..-1]
    diff.shift #equals
    header1 = diff.shift
    if header1 =~ /^---/
      diff.shift
      
      result << "<ul class='diff'>#{begin_file(file)}"
      range = diff.shift
      left_ln, right_ln = range_info(range)
      result << range_row(range)
      
      skip = 0
      diff.each do |line|
        if skip > 0
          skip -= 1
        else
          op = line[0,1]
          line = line[1..-1]
          
          if ((@last_op != ' ' and op == ' ') or (@last_op == ' ' and op != ' '))
            flush_changes(result, left_ln, right_ln)
          end
          
          # truncate and escape
          line = CGI.escapeHTML(line)

          case op
          when ' '
            @left.push(line)
            @right.push(line)
          when '-' then @left.push(line)
          when '+' then @right.push(line)
          when '@' 
            range = '@' + line
            flush_changes(result, left_ln, right_ln)
            left_ln, right_ln = range_info(range)
            result << range_row(range)
          when 'I'
            file = line[6..-1]
            flush_changes(result, left_ln, right_ln)
            result << "</table></li>#{begin_file(file)}"
            skip = 3
          end
          @last_op = op
        end
      end

      flush_changes(result, left_ln, right_ln)
      result << "</table></li></ul>"      
    else
      result = "<div class='error'>#{header1}</div>"
    end

    result
  end

end
