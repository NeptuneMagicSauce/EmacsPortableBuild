;; -*- lexical-binding: t -*-

(defun save-buffer-and-quit ()
  (interactive)
  (save-buffer)
  (kill-emacs))

(bind-key* "C-x C-c" 'save-buffer-and-quit)
