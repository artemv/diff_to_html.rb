def out(diff, converter, title)
  puts <<-EOF
  <?xml version="1.0" encoding="UTF-8"?>
  <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "DTD/xhtml1-transitional.dtd">
  <html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>#{title}</title>
    <style type="text/css">
      <!-- 
      body, p, ol, ul, td {
        font-family:verdana,arial,helvetica,sans-serif;
        font-size:13px;
      }

      a, a:link, a:visited {
      color:#507EC0;
      text-decoration:none;
      }

      ul.diff {
        padding:0;
      }

      .diff table col.lineno {
        width:4em;
      }

      .diff h2 {
        color:#333333;
        font-size:14px;
        letter-spacing:normal;
        margin:0pt auto;
        padding:0.1em 0pt 0.25em 0.5em;
      }

      table.diff {
        font-size : 9pt;
        font-family : "lucida console", "courier new", monospace;
        white-space : pre;
        border : 1px solid #D7D7D7;
        border-collapse : collapse;
        line-height : 110%;
        width: 100%;  
      }  

      .diff tr {
        background: white;
      }

      .diff td {
        border : none;
        padding : 0px 10px;
        margin : 0px;
      }

      .diff td a {
        text-decoration: none;
      }

      tr.a { background : #ddffdd; }

      tr.r { background : #ffdddd; }

      tr.range { background : #EAF2F5; color : #999; }

      td.ln {
        background : #ECECEC; 
        color : #aaa;
        border-top:1px solid #999988;
        border-bottom:1px solid #999988;
        border-right:1px solid #D7D7D7;
      }

      .diff li {
        background:#F7F7F7 none repeat scroll 0%;
        border:1px solid #D7D7D7;
        list-style-type:none;
        margin:0pt 0pt 2em;
        padding:2px;
      }

      .ln a {
        color: #aaa;
      }
      --> 
    </style>
  </head>
  <body>
  #{converter.composite_to_html(diff)}
  </body>
  </html>
  EOF
end
