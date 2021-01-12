;; !!! This configuration requires Emacs 27+ !!!

;; Set GC threshold for startup to maximum size.
(setq gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 0.6)

;; Package setup
(setq package-archives '(("gnu" . "https://elpa.gnu.org/packages/")
                         ("ublt" . "https://elpa.ubolonton.org/packages/")
                         ("melpa" . "https://melpa.org/packages/")))

(setq package-enable-at-startup nil)
(setq package-quickstart t)

(setq frame-inhibit-implied-resize t)

(defvar startup/file-name-handler-alist file-name-handler-alist)
(setq file-name-handler-alist nil)
;; Both are reset/changed after startup.

;; Remove command line options that aren't relevant to our current OS; means
;; slightly less to process at startup.
(unless (eq system-type 'darwin)
  (setq command-line-ns-option-alist nil))
(unless (eq system-type 'gnu/linux)
  (setq command-line-x-option-alist nil))
