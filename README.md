TeXode
======
TeXode renders Markdown as LaTeX. Full documents and books can be rendered, or merely the code blocks, allowing you to forgo syntax highlighting in favor of MathJax-powered LaTeX blocks.
Once LaTeX is produced, you will need to render the file with a LaTeX installation. This can then be converted to bear pdfs, amongst other formats.
Alternatively, if you built only the code blocks, you can simply embed MathJax in a page rendering your Markdown as HTML.

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

###Building Full Documents
To build full documents to LaTeX, pass the `-b [book|document] *.md build/folder`.

```sh
$ texode -b book intro.md definitions.md build/folder
```

###Building Only Code
To build just the code of documents to LaTeX, pass the `-c *.md build/folder`.

```sh
$ texode -c intro.md definitions.md build/folder
```

###Interactive
To run TeXode in interactive mode, pass the flag `-i`.

```sh
$ texode -i
```

Will bear a __vi__ input pane, and then output the result to the command line. This could be useful to minimize overhead in a one-time compilation.

Versioning
----------
###Current Version
To get the current version of your installation of TeXode, run `texode --version`. Versions are labeled by their git commit hash, and can be found and referenced here on Github.

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
- A command for building clean Markdown as well.
- Footnotes.
- Index files for `-b book`.