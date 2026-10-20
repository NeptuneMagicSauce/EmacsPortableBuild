(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")))

(setq package-user-dir
      (format "share/emacs/%s/site-lisp/elpa" (getenv "VERSION")))

(package-refresh-contents)

(package-install 'markdown-mode)
