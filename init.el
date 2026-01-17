;;; init.el --- Emacs Init File -*- lexical-binding: t -*-

;; Add external configuration
(add-to-list 'load-path "~/.emacs.d")
(add-to-list 'load-path "~/.emacs.d/lisp")

;; Add local PATH directories
(setq my:path-prepends
      (concat
       "~/.local/bin" path-separator))
(setenv "PATH"
	(concat my:path-prepends (getenv "PATH")))
(message "PATH: %s" (getenv "PATH"))

;;; General Configuration
(setq inhibit-startup-message t) ; Disable splash screen
(recentf-mode 1)                 ; Remember recently edited file
(setq history-length 25)         ; Maximum minibuffer history length
(savehist-mode 1)                ; Remember minibuffer history
(save-place-mode 1)              ; Remember and restore the last cursor position in a file
(setq use-dialog-box nil)        ; Don't show pop-up UI dialogs when prompting
(global-auto-revert-mode 1)      ; Refresh buffer on external file change

;;; UI Elements
(menu-bar-mode -1)               ; Disable menu bar
(tool-bar-mode -1)               ; Disable tool bar
(scroll-bar-mode -1)             ; Disable scroll bar

;;; UI Theme
(load-theme 'modus-vivendi t)    ; UI Theme

;; Initialize Package Manager [Elpaca]
(load "elpaca")
(elpaca elpaca-use-package ; Enable use-package support
	(elpaca-use-package-mode)) ; Enable use-pacakge :ensure

;; "Import" packages from packages.el
(require 'packages)
