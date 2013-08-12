TeXode
======
TeXode renders Markdown as LaTeX, either full documents or exclusively code-blocks, intended for use with MathJax. Rendering can be directed to update a Markdown file, output to another file, use command-line input and output, or build a series of documents to LaTeX.

Installation
------------
To install TeXode, paste & run the following in your Terminal. This assumes that *git* is installed.

```sh
$ git clone https://github.com/mattneary/TeXode.git; \
  echo ""; cd TeXode/lib; \
  ./install.sh `git log --pretty=format:'%h' -n 1`; cd ../..; \
  rm -rf TeXode/
```

This will clone the repo into your current directory, then run the install script, and remove any intermediary files created in the process.

Future updates can be performed from within TeXode by the `--update` flag, and your version number checked by the `-v` flag.

Usage
-----
There are various modes of use of TeXode, including different ways of rendering either full documents or code-blocks alone.

###Document Rendering
To render Markdown document(s) as LaTeX, use the flag `--document file1.md file2.md ... build/folder`. Files will be outputted with a `.tex` extension appended in the build folder. From there, the LaTeX may be rendered as a pdf.

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

###Document
To run TeXode to generate full LaTeX documents, pass the `--document input.md input2.md ... build/folder/`.

```sh
$ texode --document *.md ../sample/
Rendering the contents of `test.md` as a document to the folder `../sample/`.
Rendering the contents of `test2.md` as a document to the folder `../sample/`.
```

Versioning
----------
###Current Version
To get the current version of your installation of TeXode, run `texode -v`. Versions are labeled by their git commit hash, and can be found and referenced here on Github.

###Updating
To update TeXode, run `texode --update`.

Configuration
-------------
To configure keywords for all or only specific languages and set the author name, perform the command `texode --config`. The configuration is a JSON file, and code languages are specified within documents as on Github, like the following.

<div>```scheme<br>
(define a 2)<br>
```</div>

Why LaTeX?
----------
1. LaTeX automatically assigns section counts.
2. LaTeX has a very traditional appearance.
3. LaTeX automatically paginates and numbers pages, making your Markdown more appropriate for print.

Roadmap
-------
- A command for rendering clean Markdown as well.
- Footnotes
- Different document types