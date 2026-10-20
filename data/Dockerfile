FROM debian:bookworm-slim AS builder

RUN apt update && apt install -y --no-install-recommends \
    build-essential \
    autoconf \
    automake \
    texinfo \
    pkg-config \
    libncurses-dev \
    git ca-certificates

WORKDIR /build

RUN git clone --depth 1 https://github.com/emacs-mirror/emacs.git .

RUN ./autogen.sh

ENV CFLAGS=-O2

RUN ./configure \
  --prefix=/emacs \
  --without-x \
  --without-all \
  --without-xpm \
  --without-jpeg \
  --without-tiff \
  --without-gif \
  --without-png \
  --without-rsvg \
  --without-webp \
  --without-sqlite3 \
  --without-lcms2 \
  --without-libsystemd \
  --without-cairo \
  --without-xml2 \
  --without-native-image-api \
  --without-xft \
  --without-harfbuzz \
  --without-libotf \
  --without-m17n-flt \
  --without-toolkit-scroll-bars \
  --without-xaw3d \
  --without-xim \
  --without-xdbe \
  --without-gpm \
  --without-gsettings \
  --without-selinux \
  --without-gnutls \
  --without-zlib \
  --without-modules \
  --without-threads \
  --without-xinput2 \
  --without-android-debug \
  --without-compress-install \
  --without-libsmack \
  --without-selinux \
  --without-libgmp \
  --without-included-regex \
  --without-sound \
  --with-small-ja-dic \
  --disable-build-details

RUN make -j$(nproc)

RUN make install

WORKDIR /emacs
COPY init.el /
COPY post.install.sh /
RUN /post.install.sh

FROM scratch
COPY --from=builder /emacs /

# TODO
# remove cruft installed in share,libexec ...
# packages: MD
# install procedure and instructions
# install in AgentHost and opencode, integrate with LocalGenie: submodule?
# C-v change buffer
# helm?
# add tmux to LocalGeni?
# clean up docker cache
