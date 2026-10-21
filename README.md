# emacs, lean and mean

Intended use: as an easy deploy into containers and virtual machines. No local library dependencies, everything baked forever at compilation and post-install stages.

Corollary: it can not do many things. It can not add new packages, it does no longer support the removed features.

To add functionality, edit the build process.

Compilation features: in [Dockerfile](data/Dockerfile) at step `./configure`
Packages: in [post.install.el](data/post.install.el) at step `'package-install`

## size

On October, 2026:

```bash
$ ./data/build.sh
(...)
39M     /workspace/EmacsPortableBuild/data/output
12M     /workspace/EmacsPortableBuild/data/emacs.tgz
```

## build it

```bash
git clone https://github.com/NeptuneMagicSauce/EmacsPortableBuild.git
cd EmacsPortableBuild
./data/build.sh
```

## install it

To install in a virtual machine:
```bash
sudo tar zxf data/emacs.tgz -C /usr
```

To install in a Docker container with Dockerfile, move the tarball in your docker directory, then:
```
COPY emacs.tgz /
RUN tar zxf /emacs.tgz -C /usr
```
