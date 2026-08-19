# Customization to-do list

Working list for adapting this fork for the course. Items marked ⚖ are
obligations under the book's GFDL license for modified versions; items
marked ™ involve someone else's branding and should not ship.

## 1. Title, attribution, license (do first)

- [x] ⚖ **Distinct title** — change the book title in `src/ila.xml`
      (the GFDL requires a modified version to use a title distinct from
      the original, e.g. "Interactive Linear Algebra — <Course> Edition").
- [x] ⚖ **Title page authors** — in `src/frontmatter.xml` `<titlepage>`:
      keep Margalit and Rabinoff as original authors, add the instructor
      as editor/adapter with department + institution.
- [x] ⚖ **Colophon** — keep the 2017 Georgia Tech copyright and GFDL
      notice; add a line noting this is a modified version, who made the
      modifications, and a link to the original book
      (https://textbooks.math.gatech.edu/ila/) and its source repo.
- [x] ⚖ **Document changes** — add a short "About this edition" preface
      describing the nature of the modifications (git history covers the
      details; the preface satisfies the spirit of GFDL §4).
- [x] **Contributors section** — add instructor to "Contributors to this
      textbook" in `src/frontmatter.xml`; keep the original list intact.
- [x] **"Variants of this textbook" preface** — rewrite or remove: it
      describes Georgia Tech's master/1553 variants with absolute links
      (`/ila`, `/ila/1553`) that don't apply here (the 1553 link 404s on
      our Pages site).

## 2. De-brand Georgia Tech ™

- [x] **Logo** — `static/theme-gt/logo.gif` is GT's yellow-jacket mascot
      (a registered trademark). Replace with course/institution art, or a
      neutral placeholder.
- [x] **Favicon/app icons** — `static/theme-gt/icon-{1x,2x,4x}.png` are
      GT-branded; replace alongside the logo.
- [x] **Sponsor + online-home links** — `src/xsl/theme-gt.xsl` points the
      header/footer at `gatech.edu` and `textbooks.math.gatech.edu/ila`.
      Point at the course page and https://tghyde.github.io/ila/.
- [x] **manifest.json** — name/short_name say "Interactive Linear
      Algebra/ILA"; update for this edition.
- [x] **Decide: new theme vs. edit gt in place.** A proper new theme
      (e.g. `--theme myschool`) needs four pieces, cloned from the gt
      ones: `mathbook-assets/scss/mathbook-<name>.scss` (+ its SConstruct
      output line), `static/css/ila-add-on-<name>.css`,
      `static/theme-<name>/`, `src/xsl/theme-<name>.xsl`. Editing the gt
      theme in place is less work but makes upstream merges noisier.
      Colors: the gt theme is navy/gold — pick the course/school palette.

## 3. Site plumbing

- [ ] **PDF link 404s** — every page header links "PDF version" →
      `ila.pdf`, which we don't build. Either test `./docker.sh build
      --build-pdf` and publish the PDF, or suppress the link (the
      `pdf.online` param in `src/SConscript`).
- [x] **Remove `static/google9ccfcae89045309c.html`** — the original
      author's Google Search Console verification file (also drop it from
      the copy list in `SConstruct`). Harmless but not ours.
- [ ] **Check `static/images/qrcode.png`** — likely encodes the original
      gatech URL; replace or remove wherever it's used.
- [ ] **README.md** — rewrite for the fork: what this is, link to the
      original, build instructions → DOCKER.md, license note.

## 4. Course content (ongoing, chapter by chapter)

- [ ] **Variant strategy** — edit the default version in place, or define
      a course variant via `<restrict-version>` (like GT's 1553) to
      include/exclude sections without touching shared text.
- [ ] **Chapter editing passes** — the actual semester-long work;
      publish after each pass with `./docker.sh publish`.
- [ ] **Course-specific front matter** — syllabus pointers, how the book
      maps to lectures, link back to the course website.
