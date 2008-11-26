require 'cgi'

class DiffToHtml

  attr_accessor :file_prefix

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

  def range_row(range)
    "<tr class='range'><td>...</td><td>...</td><td>#{range}</td></tr>"
  end

  def range_info(range)
    range.match(/^@@ \-(\d+),\d+ \+(\d+),\d+ @@/)
    left_ln = Integer($1)
    right_ln = Integer($2)
    return left_ln, right_ln
  end

  def begin_file(file)
    result = <<EOF 
<li><h2><a name="F#{@filenum}" href="#F#{@filenum}">#{file}</a></h2><table class='diff'>
<colgroup>
<col class="lineno"/>
<col class="lineno"/>
<col class="content"/>
</colgroup>
EOF
  result
  end
  
  def flush_changes(result, left_ln, right_ln)
    x, left_ln, right_ln = get_diff_row(left_ln, right_ln)
    result << x
    @left.clear
    @right.clear    
    return left_ln, right_ln
  end
  
  def get_single_file_diff(file_name, diff_file)
    @last_op = ' '
    @left = []
    @right = []
  
    result = ""

    diff = diff_file.split("\n")
    
    diff.shift #index
    line = nil
    while line !~ /^---/ && !diff.empty?
      line = diff.shift
    end
    header_old = line
    if line =~ /^---/
      diff.shift #+++
      
      result << begin_file(file_name)
      range = diff.shift
      left_ln, right_ln = range_info(range)
      result << range_row(range)
      
      diff.each do |line|
        op = line[0,1]
        line = line[1..-1] || ''
        if op == '\\'
          line = op + line
          op = ' '
        end
        
        if ((@last_op != ' ' and op == ' ') or (@last_op == ' ' and op != ' '))
          left_ln, right_ln = flush_changes(result, left_ln, right_ln)
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
        else
          flush_changes(result, left_ln, right_ln)
          result << "</table></li>"
          break
        end
        @last_op = op
      end

      flush_changes(result, left_ln, right_ln)
      result << "</table></li>"      
    else
      #"<div class='error'>#{header_old}</div>"
      result =%Q{<li><h2><a name="F#{@filenum}" href="#F#{@filenum}">#{file_name}</a></h2>#{header_old}</li>}
    end

    result
  end

  def file_header_pattern
    raise "Method to be implemented in VCS-specific class"
  end
  
  def get_diffs(composite_diff)
    pattern = file_header_pattern
    files = composite_diff.split(pattern)
    headers = composite_diff.scan(pattern) #huh can't find a way to get both at once
    files.shift if files[0] == '' #first one is junk usually
    result = []
    i = 0
    files.each do |file|
      result << {:filename => "#{file_prefix}#{get_filename(headers[i])}", :file => file}
      i += 1
    end
    result
  end

  def diffs_to_html(diffs)
    result = '<ul class="diff">'
    @filenum = 0
    diffs.each do |file_map|
      result << get_single_file_diff(file_map[:filename], file_map[:file])
      @filenum += 1
    end
    result << '</ul>'
    result    
  end
  
  def composite_to_html(composite_diff)
    diffs_to_html get_diffs(composite_diff)
  end
end

class GitDiffToHtml < DiffToHtml
  def file_header_pattern
    /^diff --git.+/
  end

  def get_filename(file_diff)
    match = (file_diff =~ / b\/(.+)/)
    raise "not matched!" if !match
    $1
  end  
end

class SvnDiffToHtml < DiffToHtml
  def file_header_pattern
    /^Index: .+/
  end

  def get_filename(header)
    match = (header =~ /^Index: (.+)/) #if we use this pattern file_header_pattern files split doesn't work
    raise "header '#{header}' not matched!" if !match
    $1
  end  
end
