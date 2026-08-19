# Building with Docker (replaces the Vagrant VM)

The original build environment (`DEVELOP.md`) is a VirtualBox/Vagrant VM
that no longer works on Apple Silicon Macs.  This Docker port reproduces
it: Ubuntu 18.04 (x86, emulated on ARM Macs), TeXLive, Python 2 + 3
tooling, the repo's patched Inkscape 0.92, compass, and Node 8.

## One-time setup

```bash
./docker.sh image        # build the Docker image (~15 min, ~2 GB)
./docker.sh subpackages  # build PreTeXt schemas, theme CSS, mathbox
```

## Everyday use

```bash
./docker.sh build        # build the book (first time ~10 min, then seconds)
./docker.sh serve        # browse it at http://localhost:8081/
```

`./docker.sh build` accepts the scons options from DEVELOP.md, e.g.
`--build-pdf`, `--theme duke`, `--variant 1553`, `--scratch`.

## Publishing to students

```bash
./docker.sh publish
```

Exports the built site to `html/`, commits it to the `gh-pages` branch
(kept checked out in the `.gh-pages/` worktree), and pushes.  GitHub
Pages serves that branch at https://tghyde.github.io/ila/ — so the
release workflow is: edit, `./docker.sh build`, check localhost:8081,
`./docker.sh publish`.

## What changed relative to the Vagrant setup

Differences from `build-environment/bootstrap.sh`, all forced by seven
years of bit-rot (fixed versions are pinned in the `Dockerfile`):

- `gem install compass` now resolves dependencies (`ffi`, `rb-inotify`,
  `multi_json`) that require Ruby >= 3; compatible versions are pinned.
- `pip3 install bs4` now pulls a beautifulsoup4 that needs Python >= 3.7;
  pinned to 4.9.3.
- Ubuntu 18.04's npm 3.5.2 can no longer talk to the npm registry
  (`EMISSINGARG`); the official Node 8.17 tarball (bundling npm 6) is
  installed over it.
- Apache is not installed; `./docker.sh serve` runs a static file server
  instead.

Build state persists in three named Docker volumes (`ila-out`,
`ila-cache`, `ila-tmp`), standing in for the VM's `/home/vagrant`.  All
three must persist between builds — in particular, if `output-html`
(`ila-tmp`) is lost, scons will claim success while silently no longer
propagating source edits into the final html.  If that happens, rebuild
with `./docker.sh build --scratch` after `rm -f .sconsign.dblite`.
