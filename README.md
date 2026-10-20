# TODO bla bla

need docker ...

Intended use: as an easy deploy into containers and virtual machines. No local library dependencies, everything built-in at compilation and post-install stages.

Corollary: it can not do many things: add new packages, support anything relying on stuff we removed.

To add functionality, edit the build process.

Compilation features: in [Dockerfile](data/Dockerfile) at step `./configure`
Packages: in [post.install.el](data/post.install.el) at step `'package-install`

```bash
git clone https://github.com/NeptuneMagicSauce/EmacsPortableBuild.git
cd EmacsPortableBuild
./data/build.sh

# TODO
```
