(defun edit-init ()
  "hotkey to access initialisation"
  (interactive)
  (find-file "~/.emacs.d/init.el"))

(defun kill-other-buffers ()
  "kills all execpt current buffer"
  (interactive)
  (mapc 'kill-buffer (delq (current-buffer) (buffer-list)))
  (message "Cleared other buffers"))

(defun switch-to-scratch ()
  "switches to the scratch buffer"
  (interactive)
  (switch-to-buffer "*scratch*"))

(use-package restart-emacs :ensure t)

(use-package general
  :ensure t
  :config

  ;; SUPER
  (general-create-definer super-leader-def :prefix "SPC")
  (super-leader-def 'normal 'override
    "SPC" 'helm-M-x
    "e"   'edit-init
    "r"   'restart-emacs
    "/"   'toggle-comment)

  ;; BUFFERS
  (general-create-definer buffer-leader-def :prefix "SPC b")
  (buffer-leader-def 'normal 'override
    "d" 'evil-delete-buffer
    "l" 'helm-buffers-list
    "n" 'next-buffer
    "p" 'previous-buffer
    "s" 'switch-to-scratch
    "w" 'write-file
    "x" 'kill-other-buffers)
  
  ;; FILES
  (general-create-definer file-leader-def :prefix "SPC f")
  (file-leader-def 'normal 'override
    "f" 'helm-find-files)

  ;; MODES
  (general-create-definer mode-leader-def :prefix "SPC m")
  (mode-leader-def 'normal 'override
    "o" 'org-mode) 

  ;; WINDOWS CURRENT
  (general-create-definer window-leader-def :prefix "SPC w")
  (window-leader-def 'normal 'override
    "h" 'evil-window-left
    "j" 'evil-window-down
    "k" 'evil-window-up
    "l" 'evil-window-right
    "d" 'delete-window
    "x" 'delete-other-windows
    "-" 'evil-window-split
    "|" 'evil-window-vsplit)

  ;; WINDOWS NEW
  (general-create-definer window-new-leader-def :prefix "SPC w n")
  (window-new-leader-def 'normal 'override
    "-" 'evil-window-new
    "|" 'evil-window-vnew))
