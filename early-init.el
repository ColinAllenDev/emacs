;;; early-init.el --- Early Init File -*- lexical-binding t -*-

;; Disable built-in pacakge.el in favor of elpaca.el
(setq package-enable-at-startup nil)
;; Disable default init
(setq inhibit-default-init nil)
;; Silence native comp warnings and error from main Emacs session
(setq native-comp-async-report-warnings-error nil)
;; Inhibit frame resizing on startup
(setq frame-inhibit-implied-resize t)
;; Silence bells
(setq ring-bell-function #'ignore
      inhibit-startup-screen t)

;; Set default and backup fonts
(push '(font . "Lilex") default-frame-alist)
(set-face-font 'default "Lilex")
(set-face-font 'variable-pitch "Lilex")
(copy-face 'default 'fixed-pitch)
k
;; Inhibit some warning messages
(setq byte-compile-warnings '(not obsolete))
(setq warning-suppress-log-types '((comp) (bytecomp)))
(setq native-comp-async-report-warnings-errors 'silent)

(provide 'early-init)
