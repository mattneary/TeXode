TeXode
======
TeXode renders code blocks in a Markdown file as LaTeX, targeted specifically for use with MathJax. Rendering can be directed to update a Markdown file, output to another file, and even use command-line input and output.

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
- An global installation script.
- Syntax to trigger non-literal spaces.