require 'rubygems'
require 'json'

DOCUMENT_MODE = ARGV[0]=="article"
CHAPTERS = ARGV[0]=="book"
FULLDOC = DOCUMENT_MODE || CHAPTERS

if ARGV[0]=="article"
  PRELUDE = <<-eos
\\documentclass[11pt]{article}
\\usepackage{amsmath}
\\usepackage{amssymb}

% {{{ LaTeX document
\\begin{document}
  eos
  LITERAL_SPACE = '\;'
  BLOCK_START = '\begin{align*}'
  BLOCK_END = '\end{align*}'
elsif ARGV[0]=="book"
  PRELUDE = ''  
  LITERAL_SPACE = '\;'
  BLOCK_START = '\begin{align*}'
  BLOCK_END = '\end{align*}'
else
  PRELUDE = ''
  LITERAL_SPACE = '\space'
  BLOCK_START = "<div>\n"+'\begin{align*}'
  BLOCK_END = '\end{align*}'+"\n</div>"
end

def nonliteral_spaces(segment)
  if segment.match(/#\{[^}]+\}/)
    (segment.gsub(/#\{[^}]+\}/) do |match|
      match.gsub(/\s/, '_')[2..-2]
    end).gsub(/\s+/, ' '+LITERAL_SPACE+' ').gsub('_', ' ')
  else
    segment.gsub(/\s+/, ' '+LITERAL_SPACE+' ')
  end
end

def literal_spaces(line)
  if line.match(/^\s/)
    _, spaces, content = line.match(/^(\s+)([^\n]+)/)[0..2]	
    spaces + nonliteral_spaces(content)
  else
    nonliteral_spaces(line)
  end
end

def handle_tabs(spacing)
  spacing.map { |space|
    case space
    when /\t/ then '    '
    else ' '
    end
  }.join('').split('')
end

def indentation(line)
  if line.match(/^\s/)
    line.gsub(/^\s+/, handle_tabs(line.match(/^\s+/)[0].split('')).each_slice(4).to_a.map { |spaces|
      case spaces.length
      when 4 then '\qquad '
      when 3 then '\quad '+LITERAL_SPACE+' '
      when 2 then '\quad '
      else LITERAL_SPACE+' '
      end
    }.join(''))
  else
    line
  end
end

def apply_replaces(base, replaces)
  if replaces.length == 0
    base
  else
    apply_replaces(base.gsub(replaces.first.first, replaces.first.last), replaces[1..-1])  
  end
end

def literal_keywords(line, keywords)  
  apply_replaces line, (keywords.map { |keyword|
    [Regexp.new('([^{a-zA-Z0-9\-_><\\\])('+keyword+')(\s)'), '\1\text{\2}\3']
  }).concat([
    [/\.\.\./, '\dots'], 
    [/[a-zA-Z0-9><]+-\S+/, '\text{\0}'], 
    [/([^\\])_ /, '\1\_ '], 
    [/#([A-Za-z0-9]+)/, 
      FULLDOC ? '\#\1' : '\text{\0}']])
end

def handle_headers(line, author)
  case line
  when /^###/ then '\subsection{'+line[3..-1]+'}'
  when /^##/  then '\section{'+line[2..-1]+'}'
  when /^#/ 
    if CHAPTERS
      '\chapter{'+line[1..-1]+'}'
    else
      title = line[1..-1]
      moyr = Time.new.strftime "%B %Y"
      titlepage = <<-eos
% {{{ Title page
\\begin{titlepage}
\\title{#{title}}
\\author{#{author["name"]}}
\\date{#{moyr}}
\\maketitle
\\thispagestyle{empty}
\\end{titlepage}
% }}}
      eos
      titlepage
    end
  else line
  end
end

def handle_body(line, author)
  if FULLDOC
    # TODO: fix hash handling
    line = handle_headers(line, author).gsub(/#[a-zA-Z0-9]+/) do |match|
      match[1..-1]
    end
    line.gsub(/_([^0-9{}])/, '\_\1').gsub(/`([^`]+)`/, '$\1$').gsub(/\*([^*]+)\*/, '\emph{\1}')
  else
    line.gsub(/_([^0-9{}])/, '\_\1').gsub(/`([^`]+)`/, '$\1$').gsub(/\*([^*]+)\*/, '\emph{\1}')
  end
end

def handle_bullet(line, author)
  '  \item '+handle_body(line[2..-1], author)
end

if PRELUDE then puts PRELUDE end

if File.exist?('config.json')
  config = JSON.parse File.read(File.dirname(__FILE__)+'/config.json')
else
  config = JSON.parse File.read(File.dirname(__FILE__)+'/_config.json')
end
keywords = config["languages"]["*"] ? config["languages"]["*"] : []
_keywords = keywords
author = config["author"]

code = false
list = false
lineno = 0
STDIN.read.split("\n").each do |line|
  if line.match(/^```/) and (not code)
    if line.match(/^```\S+/)
      langkeys = config["languages"][line.match(/^```(\S+)/)[1]]
      keywords = keywords.concat((langkeys ? langkeys : []))
    end
    code = true
    lineno = 0
    puts BLOCK_START
  elsif line.match(/^```/) and code
    code = false
    keywords = _keywords
    puts BLOCK_END
  elsif code
    puts (if lineno == 0 then '& ' else '\\\\& ' end) + literal_keywords(indentation(literal_spaces(line)), keywords)
    lineno += 1
  elsif FULLDOC and line.match(/^- /) and (not list)
    puts '\begin{itemize}'+"\n"
    list = true
    puts handle_bullet(line, author)
  elsif FULLDOC and list and (not line.match(/^- /))
    list = false
    puts '\end{itemize}'+"\n"
    puts handle_body(line, author)
  elsif FULLDOC and list
    puts handle_bullet(line, author)
  else
    puts handle_body(line, author)
  end
end
if DOCUMENT_MODE
  puts '\end{document}'
end

