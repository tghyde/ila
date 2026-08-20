# Editing workflow (quick reference)

The book's text lives in the `.xml` files in this directory — one file
per section, stitched together by `ila.xml`.  Front matter (title page,
contributors, prefaces) is `frontmatter.xml`; LaTeX macros are in
`latex/macros.sty`.

The `./docker.sh` commands below work from this directory or from the
repository root (this directory has a forwarder to the real script one
level up).  The `git` commands work from anywhere in the repository.

## The loop

```bash
# 1. Edit the .xml files in src/

# 2. Rebuild (~20-30 s incremental)
./docker.sh build

# 3. Preview at http://localhost:8081/
./docker.sh serve        # only needed if the server isn't already running

# 4. When happy, commit and push — this AUTO-PUBLISHES to students:
#    a GitHub Action builds the book and deploys it to
#    https://tghyde.github.io/ila/ (live a few minutes later; progress
#    under the repo's Actions tab)
git add -A && git commit -m "describe the change" && git push
```

`./docker.sh publish` still works as a manual fallback if the Action
is ever down, but pushing is normally all you need.

## Which file makes which page?

A page's filename is the `xml:id` of the element that generated it, so
strip `.html` and grep for the id:

```bash
grep -rn 'xml:id="matrix-equations"' *.xml
```

Two things to know about the layout:

- **Chapter overview pages** (`chap-*.html`) come from `ila.xml` — each
  chapter's `<introduction>` is written inline there, not in a section
  file.
- Section files mostly echo their section's id (`matrixeq.xml` holds
  `xml:id="matrix-equations"`), but not exactly — trust the grep.

## Things to know

- **Math is real LaTeX** inside `<m>...</m>` (inline) and `<me>...</me>`
  (display).  Matrices/vectors use the spalign shorthand:
  `\mat{1 2; 3 4}`, `\vec{1 2 3}` (spaces between entries, `;` between
  rows).  New macros go in `latex/macros.sty`.
- **Structure is XML.**  The build validates against a schema and fails
  with a terse error if a tag is misplaced; look at neighboring sections
  for working patterns.  Common elements: `<p>`, `<em>`, `<term>`,
  `<definition>/<statement>`, `<example>`, `<remark>`, `<bluebox>`,
  `<xref ref="..."/>` for cross-references.
- **Theme/style** lives in `static/css/ila-add-on-vassar.css` (colors,
  dark mode, masthead) and `mathbook-assets/scss/mathbook-vassar.scss`
  (in the mathbook-assets submodule).
- **Full rebuilds** happen automatically when you touch XSL or front
  matter (a few minutes).  If the build ever behaves inconsistently
  (e.g. an edit stops showing up), reset with:

  ```bash
  rm -f .sconsign.dblite && ./docker.sh build --scratch
  ```

- **Pulling upstream fixes** from the original authors:

  ```bash
  git fetch upstream && git merge upstream/master
  ```
