FROM debian:bookworm-slim AS builder

RUN apt-get update && apt-get install -y --no-install-recommends \
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
RUN ./configure --without-x --without-all \
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
  --without-sound --with-small-ja-dic --disable-build-details # step 3

  # --with-zlib \
    # --with-compress-install


#     --without-x --with-json --with-gnutls
RUN make -j$(nproc)

RUN make install DESTDIR=/opt/emacs-dest

# --- Stage 2: Bundle & Make Portable ---
FROM debian:bookworm-slim AS packager

RUN apt-get update && apt-get install -y --no-install-recommends \
    patchelf \
    binutils \
    libncurses6

COPY --from=builder /opt/emacs-dest /opt/emacs-portable

# Create a local shared library directory inside the bundle
RUN mkdir -p /opt/emacs-portable/usr/local/lib

# Harvest required shared dependencies (including libxml2) and copy them into the bundle
RUN ldd /opt/emacs-portable/usr/local/bin/emacs 2>/dev/null | grep "=>" | awk '{print $3}' | while read -r lib; do \
        if [ -f "$lib" ]; then \
            #cp -u "$lib" /opt/emacs-portable/usr/local/lib/; \
            libname=$(basename "$lib"); \
            case "$libname" in \
                libc.so* | libm.so* | libdl.so* | libpthread.so* | librt.so* | libgcc_s.so* | ld-linux*) \
                    continue ;; \
                *) \
                    cp -u "$lib" /opt/emacs-portable/usr/local/lib/ ;; \
            esac; \
        fi; \
    done

## Patch the Emacs binary to enforce searching the local lib folder via relative path ($ORIGIN)
#RUN patchelf --set-rpath '$ORIGIN/../lib' --force-rpath /opt/emacs-portable/usr/local/bin/emacs

# v4

# # Explicitly copy dlopen-loaded libraries that ldd misses
# RUN cp -P /usr/lib/x86_64-linux-gnu/libxml2.so* /opt/emacs-portable/usr/local/lib/
# RUN cp -P /usr/lib/x86_64-linux-gnu/libjansson.so* /opt/emacs-portable/usr/local/lib/

# Patch all binaries in bin/ to enforce searching the local lib folder via relative path ($ORIGIN)
RUN for bin in /opt/emacs-portable/usr/local/bin/*; do \
        if [ -f "$bin" ] && [ -x "$bin" ]; then \
            patchelf --set-rpath '$ORIGIN/../lib' --force-rpath "$bin" 2>/dev/null || true; \
        fi; \
    done

# --- Stage 3: Export Artifact ---
FROM scratch
COPY --from=packager /opt/emacs-portable /
