# Interactive Linear Algebra: Vassar Edition

This is the **Vassar Edition** of the free online textbook
[*Interactive Linear Algebra*](https://textbooks.math.gatech.edu/ila/)
by Dan Margalit and Joseph Rabinoff, edited by Trevor Hyde to accompany
[Math 221: Linear Algebra](https://tghyde.github.io/math221-fall2026/)
at Vassar College.

**Read the book here: <https://tghyde.github.io/ila/>**

## About

The original book is a complete introductory linear algebra text with
inline (WebGL) interactive demos, written in
[PreTeXt](https://pretextbook.org) with all mathematics compiled by
genuine LaTeX.  This fork restyles it to match the Math 221 course
site (including a day/night mode), updates the front matter and
attribution for the Vassar Edition, and will accumulate content edits
over the semester.  A complete record of the modifications is in this
repository's git history.

- Upstream source: <https://github.com/QBobWatson/ila>
- This edition's changes are tracked in [TODO.md](TODO.md)

## Building

The original Vagrant build environment (see `DEVELOP.md`) no longer
runs on modern machines; this fork builds with Docker instead — see
[DOCKER.md](DOCKER.md) for setup and [src/EDITING.md](src/EDITING.md)
for the day-to-day edit/preview/publish workflow.

## License

Copyright 2017 Georgia Institute of Technology; modifications by
Trevor Hyde, 2026.  Both the original book and this edition are
licensed under the GNU Free Documentation License v1.2 or later; see
`src/gfdl.xml` (rendered in the book's appendix).  You are free to
copy, modify, and redistribute this book under the same terms.
