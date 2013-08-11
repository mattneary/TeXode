require 'rubygems'
require 'json'

DOCUMENT_MODE = ARGV[0]=="document"

if DOCUMENT_MODE
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
    [keyword, '\text{'+keyword+'}']
  }).concat([[/\.\.\./, '\dots'], [/[a-zA-Z0-9><]+-\S+/, '\text{\0}'], [/#[^\s]+/, '\text{\0}']])
end

def handle_headers(line, author)
  case line
  when /^###/ then '\subsection{'+line[3..-1]+'}'
  when /^##/  then '\subsection{'+line[2..-1]+'}'
  when /^#/ 
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
  else line
  end
end

code = false
lineno = 0
if PRELUDE then puts PRELUDE end

if File.exist?('config.json')
  config = JSON.parse File.read(File.dirname(__FILE__)+'/config.json')
else
  config = JSON.parse File.read(File.dirname(__FILE__)+'/_config.json')
end
keywords = config["*"] ? config["*"] : []
author = config["author"]

STDIN.read.split("\n").each do |line|
  if line.match(/^```/) and (not code)
    if line.match(/^```\S+/)
      langkeys = config[line.match(/^```(\S+)/)[1]]
      keywords = keywords.concat((langkeys ? langkeys : langkeys))
    end
    code = true
    lineno = 0
    puts BLOCK_START
  elsif line.match(/^```/) and code
    code = false
    puts BLOCK_END
  elsif code
    puts (if lineno == 0 then '& ' else '\\\\& ' end) + literal_keywords(indentation(literal_spaces(line)), keywords)
    lineno += 1
  else
    if DOCUMENT_MODE
      puts handle_headers(line, author)
    else
      puts line.gsub(/#(\S+)/, "\1")
    end
  end
end
