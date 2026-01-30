;;; packages.el --- Package Loading and Configuration -*- lexical-binding: t; -*-

;;;;;;;;;;;;;;;;;;;;;;;
;;; Package Manager ;;;
;;;;;;;;;;;;;;;;;;;;;;;
;; Initialize Elpaca
(defvar elpaca-installer-version 0.11)
(defvar elpaca-directory (expand-file-name "elpaca/" user-emacs-directory))
(defvar elpaca-builds-directory (expand-file-name "builds/" elpaca-directory))
(defvar elpaca-repos-directory (expand-file-name "repos/" elpaca-directory))
(defvar elpaca-order '(elpaca :repo "https://github.com/progfolio/elpaca.git"
                              :ref nil :depth 1 :inherit ignore
                              :files (:defaults "elpaca-test.el" (:exclude "extensions"))
                              :build (:not elpaca--activate-package)))
(let* ((repo  (expand-file-name "elpaca/" elpaca-repos-directory))
       (build (expand-file-name "elpaca/" elpaca-builds-directory))
       (order (cdr elpaca-order))
       (default-directory repo))
  (add-to-list 'load-path (if (file-exists-p build) build repo))
  (unless (file-exists-p repo)
    (make-directory repo t)
    (when (<= emacs-major-version 28) (require 'subr-x))
    (condition-case-unless-debug err
        (if-let* ((buffer (pop-to-buffer-same-window "*elpaca-bootstrap*"))
                  ((zerop (apply #'call-process `("git" nil ,buffer t "clone"
                                                  ,@(when-let* ((depth (plist-get order :depth)))
                                                      (list (format "--depth=%d" depth) "--no-single-branch"))
                                                  ,(plist-get order :repo) ,repo))))
                  ((zerop (call-process "git" nil buffer t "checkout"
                                        (or (plist-get order :ref) "--"))))
                  (emacs (concat invocation-directory invocation-name))
                  ((zerop (call-process emacs nil buffer nil "-Q" "-L" "." "--batch"
                                        "--eval" "(byte-recompile-directory \".\" 0 'force)")))
                  ((require 'elpaca))
                  ((elpaca-generate-autoloads "elpaca" repo)))
            (progn (message "%s" (buffer-string)) (kill-buffer buffer))
          (error "%s" (with-current-buffer buffer (buffer-string))))
      ((error) (warn "%s" err) (delete-directory repo 'recursive))))
  (unless (require 'elpaca-autoloads nil t)
    (require 'elpaca)
    (elpaca-generate-autoloads "elpaca" repo)
    (let ((load-source-file-function nil)) (load "./elpaca-autoloads"))))
(add-hook 'after-init-hook #'elpaca-process-queues)
(elpaca `(,@elpaca-order))

;; Elpaca helper function 
(defmacro with-after-elpaca-init (&rest body) 
  "Adds @body to `elpaca-after-init-hook`" 
  `(add-hook 'elpaca-after-init-hook (lambda (), @body)))    

;;;;;;;;;;;;;;;;
;;; Packages ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; - Common use-package Keywords                                ;;
;;   - :preface - Evaluated first                               ;;
;;   - :init    - Evalued before loading package                ;;
;;   - :config  - Evalued after loading package                 ;;
;;   - :custom  - Set user-options, evaluted immediately        ;;
;;   - :ensure  - Automatically install package                 ;;
;;   - :demand  - Evaluate package immediately                  ;;
;;   - :defer   - Evaluate package when used (lazy load)        ;;
;; - Elpaca use-package Keywords                                ;;
;;   - :wait    - Blocks until package is installed             ;;
;;     - e.g. (use-package general :ensure (:wait t) :demand t) ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Elpaca Use Package - use-package support for elpaca
;; - Use `:ensure nil` to disable elpaca's use-package mode
(elpaca elpaca-use-package
  (require 'elpaca-use-package)
  (elpaca-use-package-mode)
  (setq elpaca-use-package-by-default t)
  (setq use-package-always-ensure t)
  (setq use-package-always-defer t))

;; Evil Mode - come to the dark side.
(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-vsplit-window-right t)
  (setq evil-split-window-below t)
  (evil-mode)
  :config
  (evil-set-undo-system 'undo-redo))
(use-package evil-collection
  :after evil
  :config
  (setq evil-collection-mode-list '(dashboard dired ibuffer vterm))
  (evil-collection-init))
(use-package evil-org
  :after org
  :diminish
  :hook (org-mode . evil-org-mode)
  :config
  (evil-org-set-key-theme '(textobjects insert navigation additional shift todo heading))
  (require 'evil-org-agenda)
  (evil-org-agenda-set-keys))
(use-package evil-tutor)

;; Org Mode - emacs major mode for notes, lists, etc.
(use-package org
  :ensure nil
  :config
  (setq initial-buffer-choice 'dashboard-open)
  :custom
  (org-startup-with-inline-images t)
  (org-image-actual-width nil))

;; Ultra Scroll - Smooth scrolling plugin
(use-package ultra-scroll
  :init
  (setq scroll-conservatively 3)
  (setq scroll-margin 0)
  :config
  (ultra-scroll-mode 1))

;;;;;;;;;;;;;;;;
;; UI | Icons ;;
;;;;;;;;;;;;;;;;
;; All the Icons - an icon pack for emacs
(use-package all-the-icons
  :if (display-graphic-p))

;;;;;;;;;;;;;;;;;;;;
;; UI | Dashboard ;;
;;;;;;;;;;;;;;;;;;;;
;; Dashboard - an emacs dashboard
(use-package dashboard
  :ensure t
  :config
  (setq dashboard-banner-logo-title "Welcome to hell.")
  (setq dashboard-center-content t)
  (setq dashboard-display-icons-p t)
  (setq dashboard-icon-type 'all-the-icons)
  (add-hook 'elpaca-after-init-hook #'dashboard-insert-startupify-lists)
  (add-hook 'elpaca-after-init-hook #'dashboard-initialize)
  (add-hook 'server-after-make-frame-hook #'dashboard-open)
  (dashboard-setup-startup-hook))

;;;;;;;;;;;;;;;;;;;;;;
;; UI | Mini-Buffer ;;
;;;;;;;;;;;;;;;;;;;;;;
;; Vertico - Vertical Mini-Buffer Completions
(use-package vertico
  :init
  (vertico-mode))

;; Marginalia - Rich annotations for the minibuffer
(use-package marginalia
  :bind (:map minibuffer-local-map
         ("M-A" . marginalia-cycle))
  :init
  (marginalia-mode))

;; Savehist - Persist history over emacs restarting (Vertico sorts by history)
(use-package savehist
  :ensure nil
  :init
  (savehist-mode))

;; Corfu - Completion in Region 
(use-package corfu
  :custom
  (corfu-auto t)
  (corfu-auto-delay 0.2)
  (corfu-quit-no-match t)
  :init
  (global-corfu-mode)
  (corfu-popupinfo-mode))

(use-package emacs
  :ensure nil
  :config
  (setq ring-bell-function #'ignore)
  :custom
  (text-mode-ispell-word-completion nil)                                   ; Disable Ispell completion
  (context-menu-mode t)                                                    ; Enable context menu
  (enable-recursive-minibuffers t)                                         ; Support new minibuffers inside existing ones
  (read-extended-command-predicate #'command-completion-default-include-p) ; Hide commands unusable in the current buffer
  (minibuffer-prompt-properties
   '(read-only t cursor-intangible t face minibuffer-prompt)))             ; Disallow cursor in mini-buffer prompt

(provide 'packages)
