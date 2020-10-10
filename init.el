;;(setq emacs-user-directory (concat (getenv "HOME") "/emacs-from-scratch"))
;;(setq package-user-dir (concat emacs-user-directory "/elpa"))
(setq inhibit-startup-message t)
(setq visible-bell nil)
(setq ring-bell-function 'ignore)

(setq make-backup-files nil
      auto-save-default nil
      create-lockfiles nil)

(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

(set-face-attribute 'default nil :family "JuliaMono" :height 120 :weight 'regular)

(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
			 ("org" . "https://orgmode.org/elpa/")
			 ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))

(setq use-package-always-ensure t
      use-package-verbose t)

(setq custom-file (expand-file-name "custom.el" (file-name-directory load-file-name)))
(load custom-file 'noerror)

(column-number-mode)
(global-display-line-numbers-mode t)

(defun rtj/kill-this-buffer ()
  (interactive)
  (kill-buffer (current-buffer)))
(global-set-key (kbd "C-x k") 'rtj/kill-this-buffer)

(use-package delight)
(use-package flx)

(use-package ivy
  :diminish
  :bind (:map ivy-minibuffer-map
	      ("TAB" . ivy-alt-done)
	      ("C-l" . ivy-alt-done)
	      ("C-j" . ivy-next-line)
	      ("C-k" . ivy-previous-line)
	      :map ivy-switch-buffer-map
	      ("C-k" . ivy-previous-line)
	      ("C-l" . ivy-done)
	      ("C-d" . ivy-switch-buffer-kill))
  :config
  (setq ivy-re-builders-alist '((swiper . ivy--regex-plus)
				(ivy-switch-buffer . ivy--regex-plus)
				(t . ivy--regex-fuzzy)))
  (add-to-list 'ivy-initial-inputs-alist '(counsel-M-x . ""))
  (ivy-mode))

(use-package swiper
  :bind
  (("C-s" . swiper)))

(use-package counsel
  :bind (("C-x b" . counsel-buffer-or-recentf)
	 ("C-x C-b" . counsel-ibuffer)
	 ("C-x C-f" . counsel-find-file)
	 ("C-c t" . counsel-load-theme)
	 ("M-y" . counsel-yank-pop))
  :config (counsel-mode))

(defun rtj/load-theme (theme)
  (interactive)
  (mapc #'disable-theme custom-enabled-themes)
  (load-theme theme t))

(use-package base16-theme
  :init (rtj/load-theme 'base16-espresso))

(use-package doom-modeline
  :init (doom-modeline-mode))

(defun rtj/load-init-file ()
  (interactive)
  (load-file (expand-file-name "init.el" emacs-user-directory)))

(use-package magit
  :bind (("C-c g g". magit-status)))

(use-package general
  :config
  (general-create-definer rtj/leader-keys
    :keymaps '(normal insert visual emacs)
    :prefix "SPC"
    :global-prefix "C-SPC")
  
  (rtj/leader-keys
    "f" '(:ignore t :which-key "file")
    "ff" '(find-file :which-key "find-file")
    "ww" '(save-buffer :which-key "save-buffer")
    "qq" '(save-buffers-kill-terminal :which-key "Quit")
    "rr" '(rtj/load-init-file :which-key "Reload Init")
    "t" '(:ignore t :which-key "toggles")
    "tt" '(counsel-load-theme :which-key "choose-theme")))

(use-package evil
  :init
  (setq evil-want-integration t
	evil-want-keybinding nil
	evil-want-C-u-scroll t
	evil-want-C-i-jump nil)
  :config (evil-mode))

(use-package which-key
  :init
  (which-key-mode)
  :diminish which-key-mode)

(use-package macrostep
  :bind (:map emacs-lisp-mode-map
	      ("C-c e" . macrostep-expand)))

