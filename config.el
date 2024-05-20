(when (eq system-type 'darwin) ;; mac specific settings
  (setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")
  (setq mac-option-modifier 'meta)
  ;; (setq mac-right-option-modifier 'none)
  (setq mac-command-modifier 'super)
  (setq mac-function-modifier 'hyper)
  (global-set-key [kp-delete] 'delete-char)
  ;; For some reason lockfiles break python anaconda-mode's autocomplete
  (setq create-lockfiles nil)
  (setq scroll-step 1)
  (menu-bar-mode +1)
  ;; Enable emoji, and stop the UI from freezing when trying to display them.
  (when (fboundp 'set-fontset-font)
    (set-fontset-font t 'unicode "Apple Color Emoji" nil 'prepend))
  (use-package exec-path-from-shell
    :config
    (exec-path-from-shell-initialize)))

;; https://web.archive.org/web/20150713053259/http://www.archivum.info/comp.emacs/2007-06/00348/Re-Ignore-%5EM-in-mixed-(LF-and-CR+LF)-line-ended-textfiles.html
(defun remove-dos-eol ()
  "Do not show ^M in files containing mixed UNIX and DOS line endings."
  (interactive)
  (setq buffer-display-table (make-display-table))
  (aset buffer-display-table ?\^M []))

(when (eq system-type 'windows-nt)
  ;; Don't show ^M
  (add-hook 'text-mode-hook 'remove-dos-eol)
  ;; Performance
  (setq w32-pipe-read-delay 0)
  (setq w32-pipe-buffer-size (* 64 1024)) ;; 64k Buffer Size
  (setq jit-lock-defer-time 0)
  (setq inhibit-compacting-font-caches t)
  ;; Scrolling fixes
  (setq fast-but-imprecise-scrolling t)
  (pixel-scroll-mode 0)
  (setq scroll-conservatively 10000
        scroll-preserve-screen-position 1
        scroll-step 1
        scroll-bar-mode -1)
  (setq mouse-wheel-scroll-amount '(1 ((shift) . 1))) ;; one line at a time
  (setq mouse-wheel-progressive-speed nil) ;; don't accelerate scrolling
  (setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse
  ;; Font
  (set-face-attribute 'default nil :family "Meslo LG M" :height 90)
  ;; UTF-8 as default encoding
  (set-language-environment "UTF-8")

  ;; make PC keyboard's Win key or other to type Super or Hyper, for emacs running on Windows.
  (setq w32-pass-lwindow-to-system nil)
  (setq w32-lwindow-modifier 'super) ; Left Windows key

  (setq w32-pass-rwindow-to-system nil)
  (setq w32-rwindow-modifier 'super) ; Right Windows key

  (setq w32-pass-apps-to-system nil)
  (setq w32-apps-modifier 'super) ; Menu/App key
  )

(when (eq system-type 'gnu/linux)
  (use-package exec-path-from-shell
    :config
    (exec-path-from-shell-initialize)))

(global-hl-line-mode +1)
(global-display-line-numbers-mode)
(blink-cursor-mode 0)
(global-display-fill-column-indicator-mode +1)
(setq fill-column 120)
(setq-default fill-column 120)

;; Only enable visual line mode in programming modes
(add-hook 'prog-mode-hook
  (lambda () (visual-line-mode t)))

(setq ring-bell-function 'ignore)
(set-default 'imenu-auto-rescan t)
(fset 'yes-or-no-p 'y-or-n-p)

(use-package recentf
  :config
  (add-to-list 'recentf-exclude no-littering-var-directory)
  (add-to-list 'recentf-exclude no-littering-etc-directory)
  (add-to-list 'recentf-exclude (expand-file-name "elpa/" user-emacs-directory))
  (add-to-list 'recentf-exclude (file-truename no-littering-var-directory))
  (add-to-list 'recentf-exclude (file-truename no-littering-etc-directory))
  (add-to-list 'recentf-exclude (file-truename (expand-file-name "elpa/" user-emacs-directory)))
  (setq recentf-max-saved-items 500
        recentf-max-menu-items 15
        ;; disable recentf-cleanup on Emacs start, because it can cause
        ;; problems with remote files
        recentf-auto-cleanup 'never)
  (recentf-mode 1))

(require 'tramp)

(setq tramp-default-method "ssh")

;; dired - reuse current buffer by pressing 'a'
(put 'dired-find-alternate-file 'disabled nil)

;; always delete and copy recursively
(setq dired-recursive-deletes 'always)
(setq dired-recursive-copies 'always)

;; if there is a dired buffer displayed in the next window, use its
;; current subdir, instead of the current subdir of this dired buffer
(setq dired-dwim-target t)

(require 'dired-x)

(require 'ediff)
(setq ediff-window-setup-function 'ediff-setup-windows-plain)

;; Clean up obsolete buffers automatically
(require 'midnight)

;; Saner regex syntax
(require 're-builder)
(setq reb-re-syntax 'string)

(winner-mode +1)

(line-number-mode t)
(column-number-mode t)
(size-indication-mode t)

;; (use-package outline
;;   :ensure nil ; built-in
;;   :hook
;;   (prog-mode . outline-minor-mode))

;; (use-package bicycle
;;   :commands (bicycle-cycle bicycle-cycle-global)
;;   :after outline
;;   :bind (:map outline-minor-mode-map
;;               ([C-tab] . bicycle-cycle)
;;               ([S-tab] . bicycle-cycle-global)))

;; (use-package outline-minor-faces
;;   :commands (outline-minor-faces-add-font-lock-keywords)
;;   :after outline
;;   :hook (outline-minor-mode . outline-minor-faces-add-font-lock-keywords))

;; (add-hook 'python-mode-hook
;;           (lambda ()
;;             (setq outline-regexp
;;                   (rx (or
;;                        ;; Definitions
;;                        (group (group (* space)) bow (or "class" "def") eow)
;;                        ;; Decorators
;;                        (group (group (* space)) "@"))))))

;; Instead of setting gc-cons-threshold, use gcmh.
(use-package gcmh
  :init
  (setq gcmh-high-cons-threshold 50000000
        gcmh-verbose nil
        gcmh-idle-delay 15)
  :config
  (gcmh-mode 1))

(use-package crux
  :demand t
  :init
  (require 'bind-key)
  :bind
  (("C-c TAB" . crux-indent-rigidly-and-copy-to-clipboard)
   ("s-k" . crux-kill-whole-line)
   ("s-j" . crux-top-join-line)
   ("C-c o" . crux-open-with)
   ("C-a" . crux-move-beginning-of-line)
   ("M-o" . crux-smart-open-line)
   ("s-o" . crux-smart-open-line-above)
   ("C-c f" . crux-recentf-find-file)
   ("C-c n" . crux-cleanup-buffer-or-region)
   ("C-c s" . crux-swap-windows)
   ("C-c D" . crux-delete-file-and-buffer)
   ("C-c d" . crux-duplicate-current-line-or-region)
   ("C-c M-d" . crux-duplicate-and-comment-current-line-or-region)
   ("C-c r" . crux-rename-buffer-and-file)
   ("C-c k" . crux-kill-other-buffers)
   ("C-c t" . crux-visit-term-buffer)))

(use-package page-break-lines)

(use-package dashboard
  :config
  (dashboard-setup-startup-hook)
  (setq dashboard-items '((recents  . 10)
                          (projects . 10)))
  (setq dashboard-banner-logo-title "")
  (add-to-list 'dashboard-items '(agenda) t))

(use-package projectile
  :demand t
  :config
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
  (setq projectile-indexing-method 'alien
        projectile-generic-command "fd . -0 --no-ignore-vcs"
        projectile-git-command "fd . -0 --no-ignore-vcs"
        projectile-svn-command "fd . -0 --no-ignore-vcs"
        projectile-git-submodule-command nil
        projectile-sort-order 'recentf
        projectile-enable-caching t
        projectile-use-git-grep t)
  (projectile-mode t))

(use-package zenburn-theme
  :demand t
  :config
  (load-theme 'zenburn t))

(add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))
(add-to-list 'default-frame-alist '(ns-appearance . dark))

(scroll-bar-mode -1)

(if (eq system-type 'windows-nt)
    (pixel-scroll-mode -1)
  (pixel-scroll-mode 1))

(use-package key-chord)

(use-package use-package-chords
  :config (key-chord-mode 1))

(use-package which-key
  :config
  (which-key-mode +1))

;; (use-package iy-go-to-char
;;   :chords
;;   (("xf" . iy-go-to-char)
;;    ("xd" . iy-go-to-char-backward)))

(use-package hydra)

(use-package windmove
  :config (windmove-default-keybindings))

(use-package switch-window
  ;; Override global key bindings for switching windows.
  :bind
  (("C-x o" . ace-window)
   ("C-x 1" . switch-window-then-maximize)
   ("C-x 2" . switch-window-then-split-below)
   ("C-x 3" . switch-window-then-split-right)
   ("C-x 0" . switch-window-then-delete)
   ("C-x 4 d" . switch-window-then-dired)
   ("C-x 4 f" . switch-window-then-find-file)
   ("C-x 4 m" . switch-window-then-compose-mail)
   ("C-x 4 r" . switch-window-then-find-file-read-only)
   ("C-x 4 C-f" . switch-window-then-find-file)
   ("C-x 4 C-o" . switch-window-then-display-buffer)
   ("C-x 4 0" . switch-window-then-kill-buffer))
  :demand t
  :config
  (setq switch-window-input-style 'minibuffer)
  (setq switch-window-increase 6)
  (setq switch-window-threshold 2)
  (setq switch-window-shortcut-style 'qwerty)
  ;; Use home row instead of number keys.
  (setq switch-window-qwerty-shortcuts
        '("a" "s" "d" "f" "j" "k" "l" ";" "w" "e" "i" "o")))

(use-package ace-window
  :config
  (setq aw-keys '(?a ?s ?d ?f ?k ?l ?\; ?w ?e ?i)))
;; Set it to also use homerow keys instead of numbers for buffers.
;; TODO: decide which one I like better, e.g.
;; (Super-w v a) or (C-x 2 a) to split window a.

;; Hydra keybinds for ace-window
(global-set-key
 (kbd "C-M-o")
 (defhydra hydra-window (:color red
                                :columns nil)
   "window"
   ("h" windmove-left nil)
   ("j" windmove-down nil)
   ("k" windmove-up nil)
   ("l" windmove-right nil)
   ("H" hydra-move-splitter-left nil)
   ("J" hydra-move-splitter-down nil)
   ("K" hydra-move-splitter-up nil)
   ("L" hydra-move-splitter-right nil)
   ("v" (lambda ()
          (interactive)
          (split-window-right)
          (windmove-right))
    "vert")
   ("x" (lambda ()
          (interactive)
          (split-window-below)
          (windmove-down))
    "horz")
   ("t" transpose-frame "'" :exit t)
   ("o" delete-other-windows "one" :exit t)
   ("a" ace-window "ace")
   ("s" ace-swap-window "swap")
   ("d" ace-delete-window "del")
   ("i" ace-maximize-window "ace-one" :exit t)
   ("b" ido-switch-buffer "buf")
   ("m" headlong-bookmark-jump "bmk")
   ("q" nil "cancel")
   ("u" (progn (winner-undo) (setq this-command 'winner-undo)) "undo")
   ("f" nil)))

;; Multiple cursors
(use-package multiple-cursors
  :demand t
  :bind
  (("C-S-c C-S-c" . mc/edit-lines)
   ;; If nothing is selected, pick the symbol under the cursor.
   ("C->" . mc/mark-next-like-this-symbol)
   ("C-<" . mc/mark-previous-like-this-symbol)
   ("C-c C-<" . mc/mark-all-like-this)
   ("H-SPC" . set-rectangular-region-anchor)
   ;; Special commands for inserting numbers or chars, sorting and reversing.
   ("C-c x n" . mc/insert-numbers)
   ("C-c x l" . mc/insert-letters)
   ("C-c x s" . mc/sort-regions)
   ("C-c x r" . mc/reverse-regions)))

(defun daedreth/kill-inner-word ()
  "Kills the entire word your cursor is in. Equivalent to 'ciw' in vim."
  (interactive)
  (forward-char 1)
  (backward-word)
  (kill-word 1))
(global-set-key (kbd "C-c x w") 'daedreth/kill-inner-word)

;; Another one of Uncle Dave's functions to copy a while line.
(defun daedreth/copy-whole-line ()
  "Copies a line without regard for cursor position."
  (interactive)
  (save-excursion
    (kill-new
     (buffer-substring
      (point-at-bol)
      (point-at-eol)))))
(global-set-key (kbd "C-c x c") 'daedreth/copy-whole-line)

(defun all-over-the-screen ()
  (interactive)
  (delete-other-windows)
  (split-window-horizontally)
  (split-window-horizontally)
  (balance-windows)
  (follow-mode t))

(global-set-key (kbd "C-c x a") 'all-over-the-screen)

(global-set-key (kbd "C-c i") 'imenu-anywhere)
(global-set-key (kbd "C-x \\") 'align-regexp)

;; Font size
(global-set-key (kbd "C-+") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)

;; Window switching. (C-x o goes to the next window)
(global-set-key (kbd "C-x O") (lambda ()
                                (interactive)
                                (other-window -1))) ;; back one

;; Indentation help
(global-set-key (kbd "C-^") 'crux-top-join-line)
;; Start proced in a similar manner to dired
(unless (eq system-type 'darwin)
  (global-set-key (kbd "C-x p") 'proced))

;; Start eshell or switch to it if it's active.
(global-set-key (kbd "C-x m") 'eshell)

;; Start a new eshell even if one is active.
(global-set-key (kbd "C-x M") (lambda () (interactive) (eshell t)))

;; Start a regular shell if you prefer that.
(global-set-key (kbd "C-x M-m") 'shell)

;; If you want to be able to M-x without meta
(global-set-key (kbd "C-x C-m") 'smex)

;; A complementary binding to the apropos-command (C-h a)
(define-key 'help-command "A" 'apropos)

(use-package discover-my-major)
;; A quick major mode help with discover-my-major
(define-key 'help-command (kbd "C-m") 'discover-my-major)

(define-key 'help-command (kbd "C-f") 'find-function)
(define-key 'help-command (kbd "C-k") 'find-function-on-key)
(define-key 'help-command (kbd "C-v") 'find-variable)
(define-key 'help-command (kbd "C-l") 'find-library)

(define-key 'help-command (kbd "C-i") 'info-display-manual)

;; replace zap-to-char functionality with the more powerful zop-to-char
(global-set-key (kbd "M-z") 'zop-up-to-char)
(global-set-key (kbd "M-Z") 'zop-to-char)

;; kill lines backward
(global-set-key (kbd "C-<backspace>") (lambda ()
                                        (interactive)
                                        (kill-line 0)
                                        (indent-according-to-mode)))

(global-set-key [remap kill-whole-line] 'crux-kill-whole-line)

;; Activate occur easily inside isearch
(define-key isearch-mode-map (kbd "C-o") 'isearch-occur)

;; replace buffer-menu with ibuffer
(global-set-key (kbd "C-x C-b") 'ibuffer)

;; toggle menu-bar visibility
(global-set-key (kbd "<f12>") 'menu-bar-mode)

(global-set-key (kbd "C-=") 'er/expand-region)

(global-set-key (kbd "C-c j") 'avy-goto-word-or-subword-1)
(global-set-key (kbd "s-.") 'avy-goto-word-or-subword-1)

;; improved window navigation with ace-window
(global-set-key (kbd "s-w") 'ace-window)
(global-set-key [remap other-window] 'ace-window)

;; Custom shortcut to open this file.
(defun config-visit ()
  (interactive)
  (find-file "~/.emacs.d/config.org"))

(global-set-key (kbd "C-c v c") 'config-visit)

;; Reload config file and refresh quickstart file
(defun config-reload ()
  (interactive)
  (org-babel-load-file "~/.emacs.d/config.org")
  (package-quickstart-refresh))

(global-set-key (kbd "C-c v r") 'config-reload)

;; Visit package list
(defun visit-package-list-buffer ()
  (interactive)
  (crux-start-or-switch-to (lambda ()
                             (package-list-packages))
                           "*Packages*"))

(global-set-key (kbd "C-c v p") 'visit-package-list-buffer)

(defun xref-pop-recenter ()
  "Like xref-pop-marker-stack, but recenters the screen around the cursor after jumping to the position."
  (interactive)
  (xref-pop-marker-stack)
  (recenter-top-bottom))

(global-set-key (kbd "M-,") 'xref-pop-recenter)

(use-package operate-on-number)

(use-package smartrep
  :config
  (smartrep-define-key global-map "C-c ."
    '(("+" . apply-operation-to-number-at-point)
      ("-" . apply-operation-to-number-at-point)
      ("*" . apply-operation-to-number-at-point)
      ("/" . apply-operation-to-number-at-point)
      ("\\" . apply-operation-to-number-at-point)
      ("^" . apply-operation-to-number-at-point)
      ("<" . apply-operation-to-number-at-point)
      (">" . apply-operation-to-number-at-point)
      ("#" . apply-operation-to-number-at-point)
      ("%" . apply-operation-to-number-at-point)
      ("'" . operate-on-number-at-point))))

(defun end-line-with-semicolon ()
  (interactive)
  (move-end-of-line nil)
  (insert-char ?\; 1)
  (crux-smart-open-line nil))

(global-set-key (kbd "C-;") 'end-line-with-semicolon)

(use-package avy
  :config
  (setq avy-background t)
  (setq avy-style 'at-full)
  ;; Bind avy-copy-line. Uses x d because it actually duplicates a line.
  (global-set-key (kbd "C-c x d") 'avy-copy-line))

(use-package anzu
  :diminish t
  :config
  (global-anzu-mode)
  (global-set-key (kbd "M-%") 'anzu-query-replace)
  (global-set-key (kbd "C-M-%") 'anzu-query-replace-regexp))

;; Currently disabed because it doesn't work with mood-line
;; (use-package nyan-mode
;;   :ensure t
;;   :config
;;   (setq nyan-animate-nyancat t
;;         nyan-wavy-trail t
;;         nyan-bar-length 13))

;; (nyan-mode 1)

;; (use-package spaceline
;;   :ensure t
;;   :config
;;   (require 'spaceline-config)
;;   (setq spaceline-buffer-encoding-abbrev-p nil)
;;   (setq spaceline-line-column-p nil)
;;   (setq spaceline-line-p nil)
;;   (setq powerline-default-separator (quote arrow))
;;   (spaceline-emacs-theme))

(use-package mood-line
  :config
  (mood-line-mode))

(setq display-time-24hr-format t)
(setq display-time-format " %H:%M ")
(setq display-time-default-load-average nil)
(display-battery-mode 0)

(display-time-mode 1)

(use-package fancy-battery
  :config
  (setq fancy-battery-show-percentage t)
  (setq battery-update-interval 15)
  (if window-system
      (fancy-battery-mode)
    (display-battery-mode)))

(setq line-number-mode t)
(setq column-number-mode t)

(use-package company
  :bind
  (:map company-active-map
        ("M-n" . nil)
        ("M-p" . nil)
        ("C-n" . company-select-next)
        ("C-p" . company-select-previous)
        ("<return>" . nil)
        ("RET" . nil)
        ("<tab>" . company-complete-selection))
  :hook
  (prog-mode . company-mode)
  :config
  (setq company-minimum-prefix-length 2)
  (setq company-idle-delay 0.0)
  (setq company-tooltip-limit 15)
  (setq company-backends '((:separate company-yasnippet company-capf company-keywords)))
  (setq company-tooltip-align-lsp-annotations t)
  (setq company-tooltip-flip-when-above t))

;; dotenv-mode
(use-package dotenv-mode
  :config
  ;; Also apply to .env with extension such as .env.local)
  (add-to-list 'auto-mode-alist '("\\.env\\..*\\'" . dotenv-mode)))

;; Use swiper for search.
(use-package swiper)

(use-package imenu-anywhere)

;; Swiper do-what-I-mean
;; When text is marked, search for that.
;; When nothing is marked, search for input.
;; Source: https://xenodium.com/emacs-dwim-swiper-vs-isearch-vs-phi-search/
(defun swiper-dwim ()
  "Use current region if active for swiper search"
  (interactive)
  (cond ((and (boundp 'multiple-cursors-mode)
              multiple-cursors-mode
              (fboundp  'phi-search))
         (call-interactively 'phi-search))
        ;; Are we defining a macro?
        (defining-kbd-macro
          (call-interactively 'isearch-forward))
        ;; Fall back to swiper.
        (t
         ;; Wrap around swiper results.
         (let ((ivy-wrap t))
           ;; If region is active, prepopulate swiper's search term.
           (if (and transient-mark-mode mark-active (not (eq (mark) (point))))
               (let ((region (buffer-substring-no-properties (mark) (point))))
                 (deactivate-mark)
                 (swiper-isearch region))
             (swiper-isearch))))))

(global-set-key (kbd "C-s") 'swiper-dwim)

(use-package helm
  :straight t
  :demand t
  :bind
  (("C-h SPC" . helm-all-mark-rings)
   ("M-x"     . helm-M-x)
   ("C-x C-m" . helm-M-x)
   ("M-y"     . helm-show-kill-ring)
   ("C-x b"   . helm-mini)
   ("C-x C-b" . helm-buffers-list)
   ("C-x C-f" . helm-find-files)
   ("C-h f"   . helm-apropos)
   ("C-h r"   . helm-info-emacs)
   ("C-h C-l" . helm-locate-library)
   :map helm-map
   ("<tab>"   . helm-execute-persistent-action)
   ("C-i"     . helm-execute-persistent-action)
   ("C-z"     . helm-select-action)
   :map minibuffer-local-map
   ("C-c C-l" . helm-minibuffer-history))
  :bind*
  (("C-r"     . helm-resume))
  :init
  (setq helm-command-prefix-key "C-c h")
  :config
  ;; (helm-mode 1)
  ;; Fuzzy matching everywhere
  (setq helm-completion-style 'emacs
        completion-styles     '(flex))
  (setq
   ;; Autoresize helm buffer depending on match count
   helm-M-x-fuzzy-match t
   helm-autoresize-max-height 0
   helm-autoresize-min-height 40
   helm-buffers-fuzzy-matching t
   helm-candidate-number-limit 50
   helm-case-fold-search 'smart
   helm-completion-in-region-fuzzy-match t
   helm-ff-file-name-history-use-recentf t
   helm-ff-newfile-prompt-p nil
   helm-ff-search-library-in-sexp t
   helm-ff-transformer-show-only-basename nil
   helm-imenu-fuzzy-match t
   helm-locate-fuzzy-match nil
   helm-move-to-line-cycle-in-source t
   helm-recentf-fuzzy-match t
   helm-semantic-fuzzy-match t
   helm-split-window-inside-p t)
  (helm-autoresize-mode 1))

(use-package helm-projectile
  :config
  (setq projectile-completion-system 'helm)
  (helm-projectile-on)
  (defun helm-projectile-ag (&optional options)
    "Helm version of projectile-ag."
    (interactive (if current-prefix-arg (list (read-string "option: " "" 'helm-ag--extra-options-history))))
    (if (require 'helm-ag nil  'noerror)
        (if (projectile-project-p)
            (let ((helm-ag-command-option options)
                  (current-prefix-arg nil))
              (helm-do-ag (projectile-project-root) (car (projectile-parse-dirconfig-file))))
          (error "You're not in a project"))
      (error "helm-ag not available"))))

;; Additional Helm-related packages
(use-package helm-flx
  :config
  (helm-flx-mode +1)
  (setq helm-flx-for-helm-find-files t
        helm-flx-for-helm-locate t))

(use-package helm-org
  :after helm)

(use-package helm-ag
  :custom
  (helm-ag-base-command "ag -U --vimgrep")
  ;; (helm-ag-base-command "rg --column --no-heading --pcre2 --smart-case --multiline --glob-case-insensitive")
  ;; (helm-ag-success-exit-status '(0 2))
  :bind
  ;; Map C-c p s r to search with ripgrep, but using helm-ag interface
  (:map projectile-command-map
        ("s r" . (lambda ()
                   (interactive)
                   (setq helm-ag-base-command "rg --column --no-heading --pcre2 --smart-case --multiline --glob-case-insensitive")
                   (setq helm-ag-success-exit-status '(0 2))
                   (helm-projectile-ag)
                   (setq helm-ag-base-command "ag -U --vimgrep")
                   (setq helm-ag-success-exit-status nil)))))

(use-package dot-mode
  :config
  (global-dot-mode 1))

(use-package rainbow-delimiters
  :hook
  (prog-mode . rainbow-delimiters-mode))

;; Not yet working!!
;; (use-package rainbow-csv
;;   :load-path "~/projects/rainbow-csv/"
;;   :init
;;   (add-hook 'csv-mode-hook #'rainbow-csv-mode))

(when window-system
  (use-package pretty-mode
    :commands (turn-on-pretty-mode turn-off-pretty-mode)
    :hook
    (haskell-mode . (turn-on-pretty-mode prettify-symbols-mode))))

(use-package yasnippet
  :config
  (add-to-list 'yas-snippet-dirs "~/.emacs.d/personal/snippets")
  (use-package yasnippet-snippets)
  (add-to-list 'yas-snippet-dirs "~/.emacs.d/personal/snippets" t)
  (yas-reload-all))

(use-package auto-yasnippet
  :after yasnippet
  :commands (aya-expand aya-open-line aya-create aya-yank-snippet aya-persist-snippet aya-create-one-line)
  :bind
  ("C-o" . aya-open-line)
  :config
  (setq aya-persist-snippets-dir "~/.emacs.d/personal/snippets"))

(add-hook 'prog-mode-hook 'yas-minor-mode)
(add-hook 'latex-mode-hook 'yas-minor-mode)
(add-hook 'org-mode-hook 'yas-minor-mode)

;; Adapted from abo-abo/function-args
(defun moo-javadoc ()
  "Generate a javadoc yasnippet and expand it with `aya-expand'.
The point should be inside the method to generate docs for"
  (interactive)
  (move-beginning-of-line nil)
  (let ((tag (semantic-current-tag)))
    (unless (semantic-tag-of-class-p tag 'function)
      (error "Expected function, got %S" tag))
    (let* ((name (semantic-tag-name tag))
           (attrs (semantic-tag-attributes tag))
           (args (plist-get attrs :arguments))
           (ord 1))
      (setq aya-current
            (format
             "/**
* $1
*
%s
* @return $%d
*/"
             (mapconcat
              (lambda (x)
                (format "* @param %s $%d"
                        (car x) (incf ord)))
              args
              "\n")
             (incf ord)))
      (senator-previous-tag)
      (crux-smart-open-line-above)
      (aya-expand))))

(use-package magit
  :straight
  :commands
  (magit-status magit-dispatch magit-inside-worktree-p magit-after-save-refresh-status)
  :bind
  (("C-x g"   . magit-status)
   ("C-x M-g" . magit-dispatch))
  :config
  (require 'magit-extras)
  (define-key magit-status-mode-map (kbd "Q") 'magit-toggle-whitespace))

(add-hook 'prog-mode-hook
          (lambda ()
          (if (and (magit-inside-worktree-p t) (not (eq system-type 'windows-nt)))
              (add-hook
               'after-save-hook
               'magit-after-save-refresh-status t t))))

(use-package forge
  :after magit)

(use-package diff-hl
  :hook
  ((magit-pre-refresh  . diff-hl-magit-pre-refresh)
   (magit-post-refresh . diff-hl-magit-post-refresh)
   (dired-mode         . diff-hl-dired-mode))
  :config
  (global-diff-hl-mode +1))

(defun magit-toggle-whitespace ()
  (interactive)
  (if (member "-w" magit-diff-options)
      (magit-dont-ignore-whitespace)
    (magit-ignore-whitespace)))

(defun magit-ignore-whitespace ()
  (interactive)
  (add-to-list 'magit-diff-options "-w")
  (magit-refresh))

(defun magit-dont-ignore-whitespace ()
  (interactive)
  (setq magit-diff-options (remove "-w" magit-diff-options))
  (magit-refresh))

(with-eval-after-load 'god-mode
  (define-key god-local-mode-map (kbd "i") 'god-local-mode)
  (define-key god-local-mode-map (kbd ".") 'repeat))

(use-package nhexl-mode
  :defer t)

;;;; This is currently disabled because of a compilation error in pdf-tools.
;; (use-package pdf-tools
;;   :ensure t
;;   :config
;;   (custom-set-variables
;;    '(pdf-tools-handle-upgrades nil)) ; Use brew upgrade pdf-tools instead.
;;   (setq pdf-info-epdfinfo-program "/usr/local/bin/epdfinfo"))
;; (pdf-tools-install)

(use-package treemacs
  :config
  (setq treemacs-width 50
        treemacs-indentation 2))

(require 'uniquify)
(setq uniquify-buffer-name-style 'forward)
(setq uniquify-separator "/")
(setq uniquify-after-kill-buffer-p t)    ; rename after killing uniquified
(setq uniquify-ignore-buffers-re "^\\*") ; don't muck with special buffers

;; Auto-revert files as they changed on disk
(global-auto-revert-mode t)

;; Global semantic mode
(semantic-mode 1)
(global-semantic-highlight-func-mode 1)

(delete-selection-mode t)

(setq tab-always-indent 'complete)

;; Enable subword-mode for all programming modes
(add-hook 'prog-mode-hook 'subword-mode)

;; String-edit: Edit strings in separate buffer to avoid escape nightmares
(use-package string-edit
  :bind
  (:map c-mode-base-map
        ("C-c '" . string-edit-at-point)))

;; Unfill - opposite to M-q (fill-paragraph)
(use-package unfill
  :bind ([remap fill-paragraph] . unfill-toggle))

;; Source: https://github.com/angrybacon/dotemacs/blob/master/dotemacs.org
(defun me/eval-region-and-kill-mark (beg end)
  "Execute the region as Lisp code.
    Call `eval-region' and kill mark. Move back to the beginning of the region."
  (interactive "r")
  (eval-region beg end)
  (setq deactivate-mark t)
  (goto-char beg))

(global-set-key (kbd "C-:") 'me/eval-region-and-kill-mark)

(use-package move-text
  :commands (move-text-up move-text-down)
  :bind
   (("M-n" . move-text-down)
    ("M-p" . move-text-up)))

;; https://www.masteringemacs.org/article/fixing-mark-commands-transient-mark-mode
(defun push-mark-no-activate ()
  "Pushes `point' to `mark-ring' and does not activate the region
   Equivalent to \\[set-mark-command] when \\[transient-mark-mode] is disabled"
  (interactive)
  (push-mark (point) t nil)
  (message "Pushed mark to ring"))

(global-set-key (kbd "C-`") 'push-mark-no-activate)

(defun jump-to-mark ()
  "Jumps to the local mark, respecting the `mark-ring' order.
  This is the same as using \\[set-mark-command] with the prefix argument."
  (interactive)
  (set-mark-command 1))

(global-set-key (kbd "M-`") 'jump-to-mark)

(defun exchange-point-and-mark-no-activate ()
  "Identical to \\[exchange-point-and-mark] but will not activate the region."
  (interactive)
  (exchange-point-and-mark)
  (deactivate-mark nil))

(define-key global-map [remap exchange-point-and-mark] 'exchange-point-and-mark-no-activate)

(use-package undo-tree
  :diminish t
  :chords
  ("uu" . undo-tree-visualize)
  :config
  (global-undo-tree-mode 1))

(require 'whitespace)
;; Mark lines exceeding 120 columns.
(setq whitespace-line-column 120)
;; Set whitespace style: cleanup empty lines / trailing whitespace, show whitespace characters
(setq whitespace-style '(empty trailing face lines-tail space-mark tab-mark newline newline-mark))
;; Use spaces instead of tabs by default.
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq require-final-newline t)

(global-whitespace-mode 1)
(add-hook 'before-save-hook (lambda () (whitespace-cleanup)))

(use-package super-save
  :config
  (super-save-mode +1)
  (setq super-save-auto-save-when-idle t)
  (setq auto-save-default nil))

(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

(use-package smartparens
  :demand t
  :config
  (require 'smartparens-config)
  (setq sp-base-key-bindings 'paredit)
  (setq sp-autoskip-closing-pair 'always)
  (setq sp-hybrid-kill-entire-symbol nil)
  (sp-use-paredit-bindings)
  (show-smartparens-global-mode +1)
  :hook
  (python-mode . smartparens-mode))

;; I never got smartparens to work properly with cc-mode (formatting etc). So I use the builtins instead, which work nicely.
(defun disable-smartparens ()
  (smartparens-mode 0)
  (show-paren-mode 1)
  (electric-pair-mode 1))

(add-hook 'c++-mode-hook 'disable-smartparens)
(add-hook 'c-mode-hook 'disable-smartparens)
(add-hook 'js-mode-hook #'smartparens-mode)
(add-hook 'python-mode-hook #'smartparens-mode)
(add-hook 'web-mode-hook #'smartparens-mode)

(use-package expand-region
  :config)

(use-package browse-kill-ring
  :config
  (browse-kill-ring-default-keybindings)
  (global-set-key (kbd "s-y") 'browse-kill-ring))

(require 'tabify)
(crux-with-region-or-buffer indent-region)

(use-package easy-kill
  :config
  (global-set-key [remap kill-ring-save] 'easy-kill)
  (global-set-key [remap mark-sexp] 'easy-mark))

(use-package hl-todo
  :config
  (global-hl-todo-mode 1))

(use-package flycheck
  :demand t
  :hook
  (prog-mode . flycheck-mode)
  :config
  (setq flycheck-checker-error-threshold 5000
        flycheck-display-errors-function #'flycheck-display-error-messages-unless-error-list
        flycheck-check-syntax-automatically '(mode-enabled save)
        flycheck-error-list-format `[("File" 40)
                                     ("Line" 5 flycheck-error-list-entry-< :right-align t)
                                     ("Col" 3 nil :right-align t)
                                     ("Level" 8 flycheck-error-list-entry-level-<)
                                     ("ID" 10 t)
                                     (#("Message (Checker)" 0 7
                                        (face flycheck-error-list-error-message)
                                        9 16
                                        (face flycheck-error-list-checker-name))
                                      0 t)])
  (define-key flycheck-mode-map flycheck-keymap-prefix nil)
  (setq flycheck-keymap-prefix (kbd "C-c f"))
  (define-key flycheck-mode-map flycheck-keymap-prefix
    flycheck-command-map))

(use-package helm-lsp
  :commands helm-lsp-workspace-symbol helm-lsp-global-workspace-symbol helm-lsp-code-actions)

(use-package lsp-mode
  :demand t
  :hook
  ((c++-mode
    c-mode
    objc-mode
    java-mode
    sh-mode) . lsp)
  :commands (lsp lsp-deferred)
  :bind
  (:map lsp-mode-map
        ("M-/"     . helm-lsp-code-actions)
        ("C-c l s" . lsp-ivy-global-workspace-symbol)
        ("C-c l j" . moo-javadoc)
        ("C-c l o" . lsp-organize-imports)
        ("C-c l r" . lsp-rename)
        ("C-c l x" . lsp-workspace-restart)
        ("C-c l d" . lsp-describe-thing-at-point)
        ("C-c l h" . lsp-treemacs-call-hierarchy))
  :init
  (setq read-process-output-max (* 1024 1024 5))
  :custom
  (lsp-checker-enable t)
  (lsp-keymap-prefix "C-c l")
  (lsp-before-save-edits nil)
  (lsp-eldoc-render-all nil)
  (lsp-enable-file-watchers nil)
  (lsp-enable-folding nil)
  (lsp-enable-indentation nil)
  (lsp-enable-links nil)
  (lsp-enable-on-type-formatting nil)
  (lsp-enable-semantic-highlighting nil)
  (lsp-enable-text-document-color nil)
  (lsp-modeline-code-actions-enable nil)
  (lsp-modeline-diagnostics-enable nil)
  (lsp-treemacs-theme "Iconless")
  ;; (lsp-prefer-capf t)
  (lsp-signature-auto-activate nil)
  (lsp-headerline-breadcrumb-enable-diagnostics nil)
  (lsp-headerline-breadcrumb-segments '(project file symbols))
  :config
  (require 'lsp-lens)
  (require 'lsp-modeline)
  (require 'lsp-completion)
  (require 'lsp-diagnostics)
  (require 'lsp-headerline)
  (require 'lsp-lens)
  (setq lsp-idle-delay 0.250)
  (setq lsp-log-io nil)
  (setq-local gcmh-high-cons-threshold (* 2 gcmh-high-cons-threshold)))

(use-package lsp-treemacs
  :demand t
  :after lsp)

(use-package lsp-ui
  :after lsp-mode
  :commands (lsp-ui-mode)
  :hook
  ((c++-mode
    c-mode
    objc-mode
    python-mode
    java-mode) . lsp-ui-mode)
  :bind
  (:map lsp-ui-mode-map
        ([remap xref-find-definitions] . lsp-ui-peek-find-definitions)
        ([remap xref-find-references]  . lsp-ui-peek-find-references)
        ("C-c l ." . lsp-ui-peek-find-definitions)
        ("C-c l ?" . lsp-ui-peek-find-references)
        ("C-c l w" . lsp-ui-peek-find-workspace-symbol)
        ("C-c l i" . lsp-ui-peek-find-implementation)
        ("M-#"     . lsp-ui-doc-show)
        ("C-c l m" . lsp-ui-imenu))
  :custom
  (lsp-ui-sideline-enable nil)
  (lsp-ui-sideline-update-mode 'line)
  (lsp-ui-peek-enable nil)
  (lsp-ui-peek-always-show nil)
  (lsp-ui-doc-enable nil))

(use-package origami)
(use-package lsp-origami
  :hook
  (lsp-after-open . lsp-origami-try-enable))

;; (use-package tree-sitter
;;   :hook
;;   (tree-sitter-after-on . tree-sitter-hl-mode)
;;   :config
;;   (global-tree-sitter-mode t))

;; (use-package tree-sitter-langs)

;; Some C/C++ settings
(require 'lsp-mode)
(use-package clang-format)

(defun clang-format-save-hook-for-this-buffer ()
  "Create a buffer local save hook."
  (add-hook 'before-save-hook
            (lambda ()
              (progn
                (when (locate-dominating-file "." ".clang-format")
                  (clang-format-buffer))
                ;; Continue to save.
                nil))
            nil
            ;; Buffer local hook.
            t))

(setq lsp-clients-clangd-executable "c:/Users/moroth/scoop/apps/llvm/current/bin/clangd.exe")

(add-hook 'c++-mode-hook 'lsp)

;; (use-package ccls
;;   :hook ((c-mode c++-mode objc-mode) .
;;          (lambda () (require 'ccls) (lsp))))
;; (setq ccls-executable "c:/prj/ccls/Release/ccls.exe")
;; (setq ccls-args '("--log-file=c:/prj/ccls/ccls.log"))
(setq lsp-diagnostic-provider :flycheck)
(setq-default flycheck-disabled-checkers '(c/c++-clang c/c++-cppcheck c/c++-gcc))

;; Use clang for formatting and flycheck in C/C++.
(use-package flycheck-clang-analyzer
  :after flycheck
  :config (flycheck-clang-analyzer-setup))

(global-set-key (kbd "C-c x f") 'clang-format-region)
(global-set-key (kbd "C-c x F") 'clang-format-buffer)

(defun c-set-c-style ()
  (interactive)
  (c-set-style "bsd")
  (setq c-default-style "bsd")
  (setq indent-tabs-mode t)
  (setq tab-width 4)
  (setq c-basic-offset 4)
  (add-to-list 'c-hanging-braces-alist '(substatement-open before after)))

(add-hook 'c-mode-common-hook '(lambda () (c-toggle-hungry-state 1) (c-toggle-auto-newline 1) (c-set-style "bsd")))
(add-hook 'c++-mode-hook '(lambda () (c-set-c-style)))
(add-hook 'c-mode-hook '(lambda () (c-set-c-style)))

(use-package lsp-pyright
  :init
  (setq lsp-python-ms-auto-install-server t)
  :hook
  (python-mode . (lambda ()
                         (setq-default tab-width 4)
                         (require 'lsp-pyright)
                         (lsp))))

(use-package yaml-mode
  :init
  (add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode)))

;; virtualenvwrapper
(use-package virtualenvwrapper
  :hook python-mode
  :demand t
  :config
  ;; virtualenvwrapper init for eshell and interactive shell.
  (venv-initialize-interactive-shells) ;; if you want interactive shell support
  (venv-initialize-eshell) ;; if you want eshell support
  (setq projectile-switch-project-action
        '(lambda()
           (venv-projectile-auto-workon)
           (projectile-find-file))))

;; py-isort
(use-package py-isort
  :hook
  (python-mode . (lambda () (add-hook 'before-save-hook 'py-isort-before-save t t))))

;; yapf
(use-package yapfify
  :hook
  (python-mode . yapf-mode))

(defalias 'perl-mode 'cperl-mode)

(defun c-set-cperl-style ()
  (interactive)
  ;; Indentation
  (setq cperl-indent-level 4)
  (setq cperl-indent-parens-as-block t)
  (setq cperl-continued-statement-offset 4)
  (setq cperl-brace-offset -4)
  (setq cperl-close-paren-offset -4)
  (setq cperl-extra-newline-before-brace t)
  (setq cperl-merge-trailing-else nil)
  (setq cperl-tab-always-indent t)
  ;; Use font lock but disable invalid face
  (setq cperl-font-lock t)
  (setq cperl-invalid-face nil)
  ;; Auto-newline and electric parens
  (setq cperl-auto-newline t)
  (setq cperl-electric-parens nil))

(add-hook 'cperl-mode-hook '(lambda ()
                              (disable-smartparens)
                              (c-set-cperl-style)
                              (c-toggle-hungry-state 1)
                              (c-toggle-auto-newline 1)))

(setq lsp-java-java-path (substitute-in-file-name "$JAVA_HOME/bin/java"))

(use-package lsp-java
  :demand t
  :custom
  (lsp-java-format-enabled nil)
  (lsp-java-signature-help-enabled nil)
  (lsp-java-completion-overwrite t)
  (lsp-java-autobuild-enabled nil)
  ;; :config
  ;; (flycheck-add-next-checker 'lsp 'checkstyle-java)
)

(add-hook 'java-mode-hook '(lambda () (c-set-java-style)))

(defun c-set-java-style ()
  (interactive)
  (c-set-style "bsd")
  (setq c-default-style "bsd")
  (setq indent-tabs-mode nil)
  (setq tab-width 4)
  (setq c-basic-offset 4)
  (add-to-list 'c-hanging-braces-alist '(substatement-open before after)))

(defvar checkstyle-jar (expand-file-name "~/.emacs.d/external/checkstyle-10.1-all.jar"))
(defvar checkstyle-cfg (expand-file-name "~/.emacs.d/external/checkstyle.xml"))

(flycheck-define-checker checkstyle-java
  "Runs checkstyle"
  :command ("java" "-jar" (eval checkstyle-jar) "-c" (eval checkstyle-cfg) "-f" "xml" source)
  :error-parser flycheck-parse-checkstyle
  :enable t
  :modes (java-mode))

;; (add-to-list 'flycheck-checkers 'checkstyle-java)

(use-package sqlup-mode
  :hook
  (sql-mode . sqlup-mode))

(add-hook 'sql-interactive-mode-hook
          (lambda () (toggle-truncate-lines t)))

(setq sql-connection-alist
      '((postgres-local (sql-product  'postgres)
                        (sql-port     5432)
                        (sql-server   "localhost")
                        (sql-user     "dev")
                        (sql-password "dev"))))
(defun helm-sql-connect-server (connection)
  "Connect to the input server from sql-connection-alist"
  (interactive
   (helm-comp-read "Select server: " (mapcar (lambda (item)
                                               (list
                                                (symbol-name (nth 0 item))
                                                (nth 0 item)))
                                             sql-connection-alist)))
  ;; get the sql connection info and product from the sql-connection-alist
  (let* ((connection-info    (assoc connection sql-connection-alist))
         (connection-product (nth 1 (nth 1 (assoc 'sql-product  connection-info)))))
    ;; delete the connection info from the sql-connection-alist
    (setq sql-connection-alist (assq-delete-all connection sql-connection-alist))
    ;; add back the connection info to the beginning of sql-connection-alist
    ;; (last used server will appear first for the next prompt)
    (add-to-list 'sql-connection-alist connection-info)
    ;; override the sql-product by the product of this connection
    (setq sql-product connection-product)
    ;; connect
    (if current-prefix-arg
        (sql-connect connection connection)
      (sql-connect connection))))

(define-key helm-command-map (kbd "d") 'helm-sql-connect-server)

(use-package web-mode
  :config
  (add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.tpl\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.hbs\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.blade\\.php\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.jsp\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("/\\(views\\|html\\|theme\\|templates\\)/.*\\.php\\'" . web-mode)))

(use-package typescript-mode)

(defun setup-tide-mode ()
    (interactive)
    (tide-setup)
    (flycheck-mode +1)
    (setq flycheck-check-syntax-automatically '(save mode-enabled))
    (eldoc-mode +1)
    (tide-hl-identifier-mode +1)
    (company-mode +1))

(use-package tide
  :hook
  ((typescript-mode . setup-tide-mode)
   (typescript-mode . tide-hl-identifier-mode)
   (before-save . tide-format-before-save)))

(defun setup-nxml-mode ()
  (interactive)
  (setq indent-tabs-mode t)
  (setq nxml-child-indent 4 nxml-attribute-indent 4))

(add-hook 'nxml-mode-hook '(lambda () (setup-nxml-mode)))

(use-package go-mode)
(use-package company-go)
(use-package go-projectile)

;; https://emacs.stackexchange.com/questions/29214/org-based-init-method-slows-down-emacs-startup-dramaticlly-6-minute-startup-h
(defun my/tangle-dotfiles ()
  "If the current file is this file, the code blocks are tangled"
  (interactive)
  (when (or (equal (buffer-file-name) (file-truename "~/.emacs.d/config.org"))
            (equal (buffer-file-name) (expand-file-name "~/.emacs.d/config.org")))
    (org-babel-tangle nil "~/.emacs.d/config.el")
    (byte-compile-file "~/.emacs.d/config.el")))

;; Snippet for writing elisp like everywhere around this file.

(use-package org
  :hook
  ((org-mode . org-indent-mode)
   (org-mode . smartparens-mode)
   (after-save . my/tangle-dotfiles))

  :config
  (add-to-list 'org-structure-template-alist
               '("el" . "src emacs-lisp"))
  (setq org-src-fontify-natively t
        org-src-tab-acts-natively t
        org-confirm-babel-evaluate nil
        org-export-with-smart-quotes t))

(use-package org-make-toc
  :hook
  (org-mode . org-make-toc-mode))

;; Convert a buffer and associated decorations to HTML.
(use-package htmlize)

;; Don't show temp buffers like *compile-log*
(setq temp-buffer-show-function (function ignore))

;; from enberg on #emacs
(add-hook 'compilation-finish-functions
          (lambda (buf str)
            (if (null (string-match ".*exited abnormally.*" str))
                ;;no errors, make the compilation window go away in a few seconds
                (progn
                  (run-at-time
                   "1 sec" nil 'delete-windows-on
                   (get-buffer-create "*compilation*"))
                  (message "No Compilation Errors!")))))

(load "~/.emacs.d/zz-overrides")
;; (load "~/.emacs.d/elpa/explain-pause-mode/explain-pause-mode")
;; (explain-pause-mode t)
