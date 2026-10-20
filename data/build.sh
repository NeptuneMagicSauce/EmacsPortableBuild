#!/bin/sh

set -e

cd "$(dirname $0)"

out="output"
rm -fr $out

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
echo "sudo tar xzf $tarball -C /usr"
