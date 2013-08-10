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

###Build
The build command is fulfills the most likely primary use-case. Using the flag `-b file.md file2.md ... build/folder/` will render all provided files to a build directory.

```sh
$ texode -b test.md test2.md ../sample
Rendering the contents of `test.md` to the folder `../sample/`.
Rendering the contents of `test2.md` to the folder `../sample/`.
```

This works as well for wildcards. Hence the following example could fulfill the needs of many projects.

```sh
$ texode -b *.md ../sample
```

###Update
To update a Markdown file with LaTeX rendered code, use the `-u input.md` flag.

```sh
$ texode -u code.md
Rendering the contents of `code.md`.
```

The *update* command now supports wildcards, the following is an example of this.

```sh
$ texode -u *.md
Rendering the contents of `test.md`.
Rendering the contents of `test2.md`.
```

###Output
To output the rendering of one file to another, use the `-o input.md output.md` flag.

```sh
$ texode -o code.md tex.md
Rendering contents of `code.md` to the file `tex.md`.
```

Note that the build command can often fulfill this need; however, build assumes that you would like to maintain the file name and only adjust the folder location when outputting.

###Interactive
To run TeXode in interactive mode, pass the flag `-i`.

```sh
$ texode -i
```

Will bear a __vi__ input pane, and then output the result to the command line. This could be useful to minimize overhead in a one-time compilation.

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
- Config file for keyword provisioning.