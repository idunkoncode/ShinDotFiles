;;; init.el --- Emacs Configuration -*- lexical-binding: t -*-

;;; Commentary:
;; A basic Emacs configuration with sensible defaults and useful packages

;;; Code:

;; Basic Settings
(setq inhibit-startup-message t)        ; Disable startup screen
(setq ring-bell-function 'ignore)       ; Disable bell
(setq make-backup-files nil)            ; Don't create backup files
(setq auto-save-default nil)            ; Don't auto-save files

;; UI Settings
(tool-bar-mode -1)                      ; Disable toolbar
(menu-bar-mode -1)                      ; Disable menu bar
(scroll-bar-mode -1)                    ; Disable scroll bar
(column-number-mode 1)                  ; Show column numbers
(global-display-line-numbers-mode 1)    ; Show line numbers
(show-paren-mode 1)                     ; Highlight matching parentheses
(electric-pair-mode 1)                  ; Auto-pair brackets and quotes

;; Indentation
(setq-default indent-tabs-mode nil)     ; Use spaces instead of tabs
(setq-default tab-width 4)              ; Set tab width to 4 spaces

;; Font settings (adjust as needed)
(set-face-attribute 'default nil :font "Fira Code" :height 110)

;; Package management
(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives '("gnu" . "https://elpa.gnu.org/packages/") t)
(package-initialize)

;; Bootstrap use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

;; Theme
(use-package doom-themes
  :config
  (load-theme 'doom-one t)
  (doom-themes-visual-bell-config)
  (doom-themes-org-config))

;; Completion framework
(use-package ivy
  :diminish
  :bind (("C-s" . swiper)
         :map ivy-minibuffer-map
         ("TAB" . ivy-alt-done)
         ("C-l" . ivy-alt-done)
         ("C-j" . ivy-next-line)
         ("C-k" . ivy-previous-line)
         :map ivy-switch-buffer-map
         ("C-k" . ivy-previous-line)
         ("C-l" . ivy-done)
         ("C-d" . ivy-switch-buffer-kill)
         :map ivy-reverse-i-search-map
         ("C-k" . ivy-previous-line)
         ("C-d" . ivy-reverse-i-search-kill))
  :config
  (ivy-mode 1))

(use-package ivy-rich
  :init
  (ivy-rich-mode 1))

(use-package counsel
  :bind (("M-x" . counsel-M-x)
         ("C-x b" . counsel-ibuffer)
         ("C-x C-f" . counsel-find-file)
         :map minibuffer-local-map
         ("C-r" . 'counsel-minibuffer-history)))

;; Better modeline
(use-package doom-modeline
  :init (doom-modeline-mode 1)
  :custom ((doom-modeline-height 15)))

;; Which-key for keybinding help
(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 1))

;; Git integration
(use-package magit
  :commands (magit-status magit-get-current-branch)
  :bind ("C-x g" . magit-status))

;; Project management
(use-package projectile
  :diminish projectile-mode
  :config (projectile-mode)
  :custom ((projectile-completion-system 'ivy))
  :bind-keymap
  ("C-c p" . projectile-command-map))

(use-package counsel-projectile
  :config (counsel-projectile-mode))

;; Programming modes
(use-package company
  :after lsp-mode
  :hook (lsp-mode . company-mode)
  :bind (:map company-active-map
         ("<tab>" . company-complete-selection))
        (:map lsp-mode-map
         ("<tab>" . company-indent-or-complete-common))
  :custom
  (company-minimum-prefix-length 1)
  (company-idle-delay 0.0))

(use-package company-box
  :hook (company-mode . company-box-mode))

;; Syntax checking
(use-package flycheck
  :init (global-flycheck-mode))

;; LSP Mode for language server protocol
(use-package lsp-mode
  :init
  (setq lsp-keymap-prefix "C-c l")
  :hook (;; Add your programming language modes here
         (python-mode . lsp)
         (js-mode . lsp)
         (typescript-mode . lsp)
         (lsp-mode . lsp-enable-which-key-integration))
  :commands lsp)

(use-package lsp-ui :commands lsp-ui-mode)
(use-package lsp-ivy :commands lsp-ivy-workspace-symbol)

;; File tree
(use-package neotree
  :bind ("C-c t" . neotree-toggle)
  :config
  (setq neo-theme 'icons))

;; Icons (requires M-x all-the-icons-install-fonts)
(use-package all-the-icons)

;; Org mode enhancements
(use-package org-bullets
  :hook (org-mode . org-bullets-mode))

;; Terminal
(use-package vterm
  :commands vterm
  :config
  (setq vterm-max-scrollback 10000))

;; Custom key bindings
(global-set-key (kbd "C-c r") 'revert-buffer)
(global-set-key (kbd "C-c c") 'comment-or-uncomment-region)

;; Custom functions
(defun my/reload-init-file ()
  "Reload init.el file."
  (interactive)
  (load-file user-init-file)
  (message "init.el reloaded!"))

(global-set-key (kbd "C-c R") 'my/reload-init-file)

;; Startup message
(message "Welcome to Emacs! Configuration loaded successfully.")

(provide 'init)
;;; init.el ends here
