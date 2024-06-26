;;; init.el -- Emacs config entry point

;; A lot of things in this config come from or are inspired by:
;; https://github.com/bbatsov/prelude
;; https://github.com/daedreth/UncleDavesEmacs
;; https://github.com/sergeyklay/.emacs.d/
;; https://github.com/mclear-tools/dotemacs
;; Thank you!!

;; After startup, set to 50MB.
(defun startup/reset-gc ()
  (setq gc-cons-threshold 50000000
        gc-cons-percentage 0.1))

(defun startup/revert-file-name-handler-alist ()
  (setq file-name-handler-alist startup/file-name-handler-alist))

(add-hook 'emacs-startup-hook 'startup/revert-file-name-handler-alist)
(add-hook 'emacs-startup-hook 'startup/reset-gc)

;; Disable warnings and visual distractions during startup.
(setq byte-compile-warnings '(not free-vars unresolved noruntime lexical make-local))
(setq-default inhibit-startup-screen t)
(setq inhibit-splash-screen t)
(setq inhibit-startup-message t)
(setq initial-scratch-message "")

(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)

;; Definitions
(defvar mr-emacs-dir (expand-file-name user-emacs-directory)
  "Path to .emacs.d, should be located in ~.")

(setq package-user-dir (format "%selpa/" user-emacs-directory))
(setq load-prefer-newer t) ;; use newest version of file
;; make the package directory
(unless (file-directory-p package-user-dir)
  (make-directory package-user-dir t))
(setq load-path (append load-path (directory-files package-user-dir t "^[^.]" t)))

;; Set up packages
(require 'package)

;; Set up use-package
;; (unless (package-installed-p 'use-package)
;;   (package-refresh-contents)
;;   (package-install 'use-package))

;; (setq use-package-always-ensure t)

;; (require 'use-package)

;; bootstrap stright.el
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 6))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(straight-use-package 'use-package)
(require 'use-package-ensure)
(setq use-package-always-ensure t)

(use-package no-littering
  :demand t
  :init
  (setq no-littering-etc-directory
        (expand-file-name "config/" user-emacs-directory))
  (setq no-littering-var-directory
        (expand-file-name "data/" user-emacs-directory))
  :config
  (setq auto-save-file-name-transforms
        `((".*" ,(no-littering-expand-var-file-name "auto-save/") t)))
  (setq custom-file (expand-file-name "custom.el" user-emacs-directory)))

(no-littering-theme-backups)

(setq package-check-signature 'allow-unsigned)

;; This is the actual config file. It is omitted if it doesn't exist so emacs won't refuse to launch.
(if (file-readable-p "~/.emacs.d/config.elc")
    (load-file "~/.emacs.d/config.elc")
  (if (file-readable-p "~/.emacs.d/config.org")
      (org-babel-load-file "~/.emacs.d/config.org")))
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)
