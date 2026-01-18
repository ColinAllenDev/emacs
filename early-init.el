;; early-init.el --- Early Init File -*- lexical-binding: t; -*-

;;; General Configuration
;; Identification
(setq user-full-name "Colin Allen"
      user-mail-address "colinallen.dev@gmail.com")
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
;; Inhibit some warning messages
(setq byte-compile-warnings '(not obsolete))
(setq warning-suppress-log-types '((comp) (bytecomp)))
(setq native-comp-async-report-warnings-errors 'silent)

;;; Performance Tweaks
(customize-set-variable 'native-comp-speed 2)
(customize-set-variable 'native-comp-deferred-compilation t)
;; Skip regexpr searching in file-name-handler-alist to improve start time
(defvar default-file-name-handler-alist file-name-handler-alist)
(setq file-name-handler-alist nil)

;; Local Variables:
;; no-byte-compile: t
;; no-native-compile: t
;; no-update-autoloads: t
;; End:
