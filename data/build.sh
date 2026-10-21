#!/bin/sh

set -e

cd "$(dirname $0)"

out="output"
rm -fr $out

docker buildx build --output type=local,dest=$out .

echo
echo "post install logs: $(realpath $out/*log)"

cd $out
tar czf ../emacs.tgz *
cd ..
du -sh $(realpath $out)
tarball=$(realpath emacs.tgz)
du -h $tarball

echo
echo "Install it:"
echo "sudo tar xzf $tarball -C /usr"
