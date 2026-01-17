;;; packages.el --- Package Loading and Configuration -*- lexical-binding: t; -*-

;; Org Mode - emacs major mode for notes, lists, etc.
(elpaca org)

;; No Littering - keep emacs clean
(use-package no-littering
  :ensure t
  :init
  (setq no-littering-etc-directory (expand-file-name "~/.cache/emacs/etc")
        no-littering-var-directory (expand-file-name "~/.cache/emacs/var"))
  :config
  (no-littering-theme-backups) ; Set sensible default for backups
  (setq url-history-file (no-littering-expand-etc-file-name "url/history")
	custom-file (no-littering-expand-etc-file-name "custom.el"))

;; Vim Bindings [Evil]
(use-package evil :ensure t :demand t)
(require 'evil)
(evil-mode 1)

;; Vertical Mini-Buffer Completions (Vertico)
(use-package vertico
  :init
  (vertico-mode))
;; Persist history over emacs restarting (Vertico sorts by history)
(use-package savehist
  :init
  (savehist-mode))
;; Emacs mini-buffer configuration
(use-package emacs
  :custom
  (context-menu-mode t) ; Enable context menu
  (enable-recursive-minibuffers t) ; Support opening new minibuffers from inside existing ones
  (read-extended-command-prediate #'command-completion-default-include-p) ; Hide commands unusable in the current buffer
  (minibuffer-prompt-properties
   '(read-only t cursor-intangible t face minibuffer-prompt))) ; Disallow cursor in mini-buffer prompt



(provide 'packages)
