;;; Introduction
;;; ------------

;; Repositories
(require 'package)
(setq package-enable-at-startup nil) ; no automatic package loading
(add-to-list 'package-archives '("org" . "https://orgmode.org/elpa/"))
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(package-initialize) ; explicitly load files in init.el

;; Remove the ugly defaults
(setq blink-cursor-mode nil)
(setq inhibit-splash-screen t)
(setq visible-bell t)
(setq use-dialog-box nil)
(setq sentence-end-double-space nil)
(customize-set-variable 'menu-bar-mode nil)
(customize-set-variable 'tool-bar-mode nil)
(customize-set-variable 'scroll-bar-mode nil)

;; Fonts
(set-frame-font "Meslo LG S")
(custom-theme-set-faces
 'user
 '(variable-pitch ((t (:family "Open Sans" :height 120))))
 '(fixed-pitch ((t (:family "Meslo LG S" :height 102)))))

;; Remove messages
(setq-default message-log-max nil)
(when (get-buffer "*Messages*")
  (kill-buffer "*Messages*"))

;; Autosave & Backups
(defvar backup-dir (expand-file-name "~/.emacs.d/backup/"))
(defvar autosave-dir (expand-file-name "~/.emacs.d/autosave/"))
(setq backup-directory-alist (list (cons ".*" backup-dir)))
(setq auto-save-list-file-prefix autosave-dir)
(setq auto-save-file-name-transforms `((".*" ,autosave-dir t)))

;; Custom config - this file must be present
(setq custom-file "~/.emacs.d/custom.el")
(load custom-file)

(setq debug-on-error t)

;;; Use-package
;;; -----------


;; Ensure use-package is installed and used
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-when-compile (require 'use-package))
(customize-set-variable 'use-package-always-ensure t)

;; Doom Theme
(use-package doom-themes
  :ensure t
  :init
  (load-theme 'doom-one t))

;; Evil
(defvar normal-colour "#51AFEF")
(defvar insert-colour "#00cd00")
(defvar visual-colour "#e5c100")
(defvar emacs-colour "purple")
(defvar motion-colour "#e50000")
(defun evil-space ()
  "inserts a space before the cursor in normal mode"
  (interactive)
  (insert " "))
(use-package evil
  :ensure t
  :config
  (define-key evil-normal-state-map "[" 'evil-space)
  (setq evil-normal-state-cursor `(box ,normal-colour))
  (setq evil-insert-state-cursor `(bar ,insert-colour))
  (setq evil-insert-state-message nil)
  (setq evil-visual-state-cursor `(box ,visual-colour))
  (setq evil-visual-state-message nil)
  (setq evil-emacs-state-cursor `(bar ,emacs-colour))
  (setq evil-motion-state-cursor `(box ,motion-colour))
  (evil-mode t))
(use-package evil-surround
  :ensure t
  :config
  (global-evil-surround-mode t))

;; General
 (setq keymappings-file "~/.emacs.d/keymappings.el")
 (load keymappings-file)

;; Helm
(use-package helm :ensure t)

;; Markdown
(use-package markdown-mode :ensure t)

;; Olivetti
(defun my-olivetti ()
  "My custom olivetti setup"
  (interactive)
  (olivetti-set-width 100)
  (olivetti-mode))
(use-package olivetti
  :ensure t
  :config
  (add-hook 'org-mode-hook 'my-olivetti))

;; Org
(use-package org
  :ensure t
  :config
  (setq org-hide-emphasis-markers t)
  (font-lock-add-keywords 'org-mode
			  '(("^ *\\([-]\\) "
			     (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))
  (setq org-todo-keywords '((sequence "TODO" "IN-PROGRESS" "|" "DONE" "INACTIVE")))
  (setq org-log-done 'time) ; timestamp when done or inactive
  (setq org-confirm-babel-evaluate nil)
  (require 'ob-js) ; needed for evaluating javascript (not documented anywhere?!)
 
  ;; Fixed & Variable
  (custom-theme-set-faces
   'user
   '(org-block ((t (:inherit fixed-pitch))))
   '(org-code ((t (:inherit (shadow fixed-pitch)))))
   '(org-document-info-keyword ((t (:inherit (shadow fixed-pitch)))))
   '(org-link ((t (:inherit link :weight regular))))
   '(org-indent ((t (:inherit (org-hide fixed-pitch)))))
   '(org-meta-line ((t (:inherit (font-lock-comment-face shadow fixed-pitch)))))
   '(org-property-value ((t (:inherit fixed-pitch))) t)
   '(org-special-keyword ((t (:inherit (font-lock-comment-face fixed-pitch)))))
   '(org-table ((t (:inherit fixed-pitch))))
   '(org-tag ((t (:inherit (shadow fixed-pitch) :weight bold :height 0.8))))
   '(org-verbatim ((t (:inherit (shadow fixed-pitch))))))

  (add-hook 'org-mode-hook 'org-indent-mode)
  (add-hook 'org-mode-hook 'variable-pitch-mode)
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((js . t) (python . t))))

(use-package org-journal
  :ensure t
  :defer t
  :config
  (setq org-journal-dir "~/Documents/journal/"
        org-journal-date-format "%A %d %B"
        org-journal-file-format "%Y-%m-%d.org"))

;; Telephone line
(use-package telephone-line
  :ensure t
  :config
  (set-face-attribute 'telephone-line-evil-normal nil
		      :foreground "white"
		      :background normal-colour)
  (set-face-attribute 'telephone-line-evil-insert nil
		      :foreground "white"
		      :background insert-colour)
  (set-face-attribute 'telephone-line-evil-visual nil
		      :foreground "white"
		      :background visual-colour)
  (set-face-attribute 'telephone-line-evil-emacs nil
		      :foreground "white"
		      :background emacs-colour)
  (set-face-attribute 'telephone-line-evil-motion nil
		      :foreground "white"
		      :background motion-colour)
  (telephone-line-mode t))

;;; Startup
;;; -------


(defun display-startup-echo-area-message ()
  (message "Emacs has loaded successfully"))

(setq initial-scratch-message ";; Remember: nothing in this buffer will be saved!\n")

;; Copy and paste from other applications
(set 'x-select-enable-clipboard t)
(set 'x-select-enable-primary t)
