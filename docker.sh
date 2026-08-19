#!/usr/bin/env bash
# Docker-based build for ila, replacing the Vagrant VM (see DEVELOP.md).
# Usage:
#   ./docker.sh image        # build the ila-build Docker image (one time, slow)
#   ./docker.sh subpackages  # build mathbook/mathbook-assets/mathbox (one time)
#   ./docker.sh build [scons options, e.g. --build-pdf --theme duke]
#   ./docker.sh serve        # serve the built book at http://localhost:8081/
#   ./docker.sh publish      # push the built site to gh-pages (GitHub Pages)
#   ./docker.sh shell        # interactive shell inside the build container
#
# State lives in three named Docker volumes, mirroring the Vagrant VM's
# persistent /home/vagrant.  ila-tmp (output-html) MUST persist between
# builds or scons's dependency tracking silently stops propagating edits
# to the final html; if the volumes get into a weird state, run
# `./docker.sh build --scratch` (or delete the volumes) to start clean.

set -e
cd "$(dirname "$0")"

RUN="docker run --rm --platform linux/amd64
     -v $PWD:/base
     -v ila-out:/home/vagrant/build
     -v ila-cache:/home/vagrant/cache
     -v ila-tmp:/home/vagrant/output-html
     -w /base ila-build"

case "${1:-build}" in
    image)
        docker build --platform linux/amd64 -t ila-build build-environment
        ;;
    subpackages)
        $RUN scons subpackages
        ;;
    build)
        shift
        $RUN scons "$@"
        ;;
    serve)
        docker rm -f ila-web 2>/dev/null || true
        docker run -d --name ila-web \
            -p 8081:80 -v ila-out:/usr/share/nginx/html:ro nginx:alpine
        echo "Serving at http://localhost:8081/  (stop with: docker rm -f ila-web)"
        ;;
    publish)
        # Export the built site to html/, then commit it to the gh-pages
        # branch (checked out in the .gh-pages worktree) and push.  GitHub
        # Pages serves that branch to students.
        $RUN scons html
        if [ ! -d .gh-pages ]; then
            if ! git show-ref --quiet refs/heads/gh-pages; then
                if git fetch origin gh-pages:gh-pages 2>/dev/null; then
                    : # someone published before; branch fetched
                else
                    empty_tree=$(git hash-object -t tree /dev/null)
                    init_commit=$(git commit-tree "$empty_tree" -m "Initialize gh-pages")
                    git branch gh-pages "$init_commit"
                fi
            fi
            git worktree add .gh-pages gh-pages
        fi
        rsync -a --delete --exclude .git html/ .gh-pages/
        touch .gh-pages/.nojekyll
        git -C .gh-pages add -A
        git -C .gh-pages commit -m "Publish $(date '+%Y-%m-%d %H:%M')" \
            || { echo "No changes to publish."; exit 0; }
        git -C .gh-pages push origin gh-pages
        echo "Published.  Site updates in a minute or two."
        ;;
    shell)
        docker run --rm -it --platform linux/amd64 \
            -v "$PWD":/base -v ila-out:/home/vagrant/build \
            -v ila-cache:/home/vagrant/cache -v ila-tmp:/home/vagrant/output-html \
            -w /base ila-build bash
        ;;
    *)
        echo "usage: $0 {image|subpackages|build|serve|shell}" >&2
        exit 1
        ;;
esac
