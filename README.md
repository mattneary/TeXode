TeXode
======
TeXode renders code blocks in a Markdown file as LaTeX, targeted specifically for use with MathJax. Rendering can be directed to update a Markdown file, output to another file, and even use command-line input and output.

Installation
------------
To install TeXode, paste & run the following in your Terminal. This assumes that *git* is installed.

```sh
$ git clone https://github.com/mattneary/TeXode.git; \
  echo ""; cd TeXode/lib; \
  ./install.sh; cd ../..; \
  rm -rf TeXode/
```

This will clone the repo into your current directory, then run the install script, and remove any intermediary files created in the process.

Special Syntax
--------------
###Leading Spaces
All leading spaces are treated as indentation which will be converted to LaTeX spacing. Of note is the fact that all blocks are wrapped in `\begin{align*}` blocks, thus `&` may be used for alignment as well.

###Literal Spaces
By default, all spaces within the contents of a line will be converted to LaTeX literal spaces, i.e., `\space`. However, a region for which you would not like literal spacing may be designated by `#{...}`. For example:

```latex
#{\lambda f \lambda x (f) x}
```

The above renders as a dense array of characters, without any spacing between them.

Usage
-----
There are three modes of the TeXode command-line utility.

###Update
To update a Markdown file with LaTeX rendered code, use the `-u input.md` flag.

```sh
$ ./texode.sh -u code.md
```

###Output
To output the rendering of one file to another, use the `-o input.md output.md` flag.

```sh
$ ./texode.sh -o code.md tex.md
```

###Interactive
To run TeXode in interactive mode, pass the flag `-i`.

```sh
$ ./texode.sh -i
```

Will bear a __vi__ input pane, and then output the result to the command line.

Why LaTeX?
----------
1. LaTeX rendered code can have explicit aligning between lines.

	```latex
	(lambda (x) x) &\implies \lambda x x
	(lambda (f x) (f x)) &\implies \lambda f \lambda x (f) x
	```

2. LaTeX rendered code can include an array of special symbols easily, e.g., `\implies` or `\lambda`.
3. LaTeX looks far more traditional and formal than syntax highlighting.

Roadmap
-------
- Syntax to trigger non-literal spaces.
- Install script independent of running directory.