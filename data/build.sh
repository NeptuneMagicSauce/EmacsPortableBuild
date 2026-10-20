#!/bin/sh

set -e

out="output"
rm -fr $out

cd "$(dirname $0)"
docker buildx build --output type=local,dest=$out .

echo
echo "post install logs: $(realpath $out/*log)"
du -sh $(realpath $out)

cd $out
tar czf ../emacs.tgz *
tarball=$(realpath ../emacs.tgz)
du -h $tarball

echo
echo "Install it:"
echo "tar czf $tarball -C /usr"
