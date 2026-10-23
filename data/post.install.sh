#!/bin/sh

cd /emacs

exec > portable.install.log 2>&1

echo "running this:"
realpath $0

set -x

VERBOSE="-v"

export VERSION=$(basename /emacs/share/emacs/[0-9]*)

cp $VERBOSE /init.el share/emacs/$VERSION/site-lisp/site-start.el
cp $VERBOSE /save.on.quit.el share/emacs/$VERSION/site-lisp/

# bin
mkdir -p bin/bin
rm $VERBOSE bin/emacs
mv $VERBOSE bin/emacs-* bin/bin/emacs
cp $VERBOSE /emacs.launcher.sh bin/emacs
rm $VERBOSE bin/ebrowse bin/emacsclient bin/etags

# install packages
./bin/bin/emacs --batch -l /post.install.el

# include,lib
rm $VERBOSE -r include lib

# libexec
rm $VERBOSE libexec/emacs/$VERSION/*/*

# share
cd share
rm $VERBOSE -r man info metainfo applications icons
rm $VERBOSE -r emacs/site-lisp

# share/emacs/version
cd emacs/$VERSION

rm $VERBOSE -r site-lisp/elpa/archives

# lisp source files that are compiled
find -name \*el -exec sh -c '
    for el; do
        if [ -f "${el}c" ]; then
            rm $VERBOSE $el
        fi
    done
' _ {} +

# etc
(
    cd etc
    rm $VERBOSE -r images tutorials DOC refcards schema nxml org srecode gnus forms e
    # development files
    find -maxdepth 1 -type f | xargs rm $VERBOSE
)

# lisp
(
    cd lisp
    rm $VERBOSE -r \
       leim org net gnus cedet \
       play emulation mh-e obsolete \
       erc calc eshell mail image nxml \
       use-package \
       ldefs-boot.el
)

exit 0
