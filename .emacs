(require 'package)

(setq package-archives '(
			 ("gnu" . "https://elpa.gnu.org/packages/")
			 ("melpa" . "https://melpa.org/packages/")
			 ("melpa-stable" . "https://stable.melpa.org/packages/")))
(setq package-check-signature nil)
(package-initialize)

(setq package-install-upgrade-built-in t)

(unless (package-installed-p 'use-package)
   (package-refresh-contents)
   (package-install 'use-package))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(markdown-code-face ((t (:inherit default)))))
(require 'use-package)
(setq use-package-always-ensure t)


(use-package ace-jump-mode
  :ensure t
  :bind (("C-;" . ace-jump-mode))
  )

(use-package lsp-mode
  :ensure t
  :commands (lsp lsp-deferred)
  :hook ((c++-mode . lsp-deferred)
	 (c-mode . lsp-deferred)
	 (lsp-mode . lsp-enable-which-key-integration))
  :init
  (setq lsp-keymap-prefix "C-c l")
  :config
  (setq lsp-enable-on-type-formatting t)

  (add-hook 'before-save-hook
	    (lambda ()
	      (when (and (member major-mode '(c-mode c++-mode))
			 buffer-file-name
			 (bound-and-true-p lsp-mode)
			 (lsp-feature? "textDocument/formatting"))
		(lsp-format-buffer)))
	    nil t)

  (setq lsp-clients-clangd-args
	'("-j=4"
	  "--fallback-style=WebKit"
	  ))

  (setq lsp-enable-document-formatting t)
)

(use-package lsp-ui
  :ensure t
  :after lsp-mode
  :commands lsp-ui-mode
  :hook (lsp-mode . lsp-ui-mode)
  :config
  (setq lsp-ui-doc-show-with-mouse nil)
  (setq lsp-ui-sideline-show-diagnostics t)
  (setq lsp-ui-sideline-show-hover t)
  (setq lsp-ui-sideline-show-code-actions t))

(use-package company
  :ensure t
  :after lsp-mode
  :hook (lsp-mode . company-mode)
  :bind (:map company-mode-map
	      ("M-/" . company-complete))
	(:map company-active-map
	      ("<tab>" . company-complete-common-or-cycle)
	      ("TAB" . company-complete-common-or-cycle)
	      ("<return>" . company-complete-selection)
	      ("RET" . company-complete-selection)
	      )
  :config
  (setq company-idle-delay nil)
  (setq company-minimum-prefix-length 1)
)

(use-package neotree
  :ensure t
  )

(use-package magit
  :ensure t
  )

;; (use-package modus-themes
;;   :ensure t
  ;; )

;(use-package clang-format
;  :ensure t
;  )

(defun my-point-is-at-natural-word-start-p ()
  "Проверяет, находится ли курсор в 'естественном' начале слова.
Это означает, что символ перед курсором не является частью слова
(или это начало буфера)."
  (or (bobp) ; bobp
      (save-excursion
	(backward-char 1)
	(not (looking-at "\\w")))))

(defun select-word-at-point-smart ()
  "Выделяет слово под курсором с учетом его положения.
- Если курсор на знаке препинания или пробеле - ничего не делает.
- Если курсор в начале слова (после пробела/начало буфера) - выделяет текущее слово.
- Если курсор в середине слова - выделяет текущее слово.
- Если курсор встык после другого слова (слово1|слово2) - выделяет предыдущее слово (слово1)."
  (interactive)
  (if (looking-at "\\w")
      (if (my-point-is-at-natural-word-start-p)
	  (mark-word)
	(progn
	  (backward-word)
	  (mark-word)))
    ))


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes '(ef-bio))
 '(custom-safe-themes
   '("36c5acdaf85dda0dad1dd3ad643aacd478fb967960ee1f83981d160c52b3c8ac" "00d7122017db83578ef6fba39c131efdcb59910f0fac0defbe726da8072a0729" "ae20535e46a88faea5d65775ca5510c7385cbf334dfa7dde93c0cd22ed663ba0" "a3a71b922fb6cbf9283884ac8a9109935e04550bcc5d2a05414a58c52a8ffc47" "cd5f8f91cc2560c017cc9ec24a9ab637451e36afd22e00a03e08d7b1b87c29ca" "1ad12cda71588cc82e74f1cabeed99705c6a60d23ee1bb355c293ba9c000d4ac" "ea4dd126d72d30805c083421a50544e235176d9698c8c541b824b60912275ba1" "211621592803ada9c81ec8f8ba0659df185f9dc06183fcd0e40fbf646c995f23" "296dcaeb2582e7f759e813407ff1facfd979faa071cf27ef54100202c45ae7d4" "59c36051a521e3ea68dc530ded1c7be169cd19e8873b7994bfc02a216041bf3b" "d6b369a3f09f34cdbaed93eeefcc6a0e05e135d187252e01b0031559b1671e97" "df39cc8ecf022613fc2515bccde55df40cb604d7568cb96cd7fe1eff806b863b" "e85a354f77ae6c2e47667370a8beddf02e8772a02e1f7edb7089e793f4762a45" "d609d9aaf89d935677b04d34e4449ba3f8bbfdcaaeeaab3d21ee035f43321ff1" "b1791a921c4f38cb966c6f78633364ad880ad9cf36eef01c60982c54ec9dd088" "ac893acecb0f1cf2b6ccea5c70ea97516c13c2b80c07f3292c21d6eb0cb45239" "c038d994d271ebf2d50fa76db7ed0f288f17b9ad01b425efec09519fa873af53" "6af300029805f10970ebec4cea3134f381cd02f04c96acba083c76e2da23f3ec" "aff0396925324838889f011fd3f5a0b91652b88f5fd0611f7b10021cc76f9e09" "90185f1d8362727f2aeac7a3d67d3aec789f55c10bb47dada4eefb2e14aa5d01" "cee5c56dc8b95b345bfe1c88d82d48f89e0f23008b0c2154ef452b2ce348da37" "19b62f442479efd3ca4c1cef81c2311579a98bbc0f3684b49cdf9321bd5dfdbf" "fae5872ff90462502b3bedfe689c02d2fa281bc63d33cb007b94a199af6ccf24" "71b688e7ef7c844512fa7c4de7e99e623de99a2a8b3ac3df4d02f2cd2c3215e7" "3d9938bbef24ecee9f2632cb25339bf2312d062b398f0dfb99b918f8f11e11b1" "b41d0a9413fb0034cea34eb8c9f89f6e243bdd76bccecf8292eb1fefa42eaf0a" default))
 '(fancy-splash-image "/home/lsp10/Pictures/Wallpapers/5.png")
 '(lsp-ui-sideline-show-hover nil)
 '(package-selected-packages
   '(ef-themes which-key counsel projectile dashboard treemacs-dap dap-ui ace-jump-mode clang-format company corfu dap-mode helm-lsp lsp-ivy lsp-treemacs lsp-ui magit neotree yasnippet)))


(when (< 26 emacs-major-version)
 (tab-bar-mode 1)
 (setq tab-bar-show 1)
 (setq tab-bar-close-button-show nil)
 (setq tab-bar-new-tab-choice "*dashboard*")
 (setq tab-bar-tab-hints t)
  (setq tab-bar-format '(tab-bar-format-tabs tab-bar-separator)))


;; (load-theme 'modus-vivendi-tinted t)
(global-set-key (kbd "M-j") 'select-word-at-point-smart)
(global-display-line-numbers-mode 1)
(tool-bar-mode -1)
(global-set-key (kbd "C-x p") 'tab-bar-switch-to-prev-tab)
(global-set-key (kbd "C-x n}") 'tab-bar-switch-to-next-tab)
(global-set-key (kbd "C-t") 'tab-bar-new-tab)
(delete-selection-mode 1)
(global-set-key [f8] 'neotree-toggle)
;;(which-key-mode)

(let ((backup-dir (expand-file-name "~/.emacs.d/saves/backups/"))
      (auto-save-dir (expand-file-name "~/.emacs.d/saves/auto-saves/")))
  (make-directory backup-dir t)
  (make-directory auto-save-dir t)
  (setq backup-directory-alist
	`((".*" . ,backup-dir)))
  (setq auto-save-file-name-transforms
	`((".*" ,auto-save-dir t)))
  )

(setq vc-make-backup-files nil)

(setq frame-resize-pixelwise t)
(setq frame-inhibit-implied-resize t)
(add-to-list 'default-frame-alist '(fullscreen . nil))
(add-to-list 'default-frame-alist '(wait-for-wm . nil))


(add-hook 'prog-mode-hook (lambda () (visual-line-mode -1)))
(add-hook 'text-mode-hook (lambda () (visual-line-mode -1)))
(add-hook 'text-mode-hook (lambda () (auto-fill-mode -1)))
(add-hook 'prog-mode-hook (lambda () (auto-fill-mode -1)))

(use-package lsp-treemacs :commands lsp-treemacs-errors-list)

(add-hook 'c-mode-common-hook
	  (lambda ()
	    (setq c-basic-offset 4)
	    (setq indent-tabs-mode nil)
	    (setq-local tab-width 4)
	    ))


(require 'recentf)
(setq recentf-save-file "~/.emacs.d/recentf")
(recentf-mode 1)
(setq recentf-exclude '("/tmp/" "/ssh:.*" "\\.git/.*" "COMMIT_EDITMSG"))

(unless (package-installed-p 'dashboard)
  (package-refresh-contents)
  (package-install 'dashboard))
(require 'dashboard)
(dashboard-setup-startup-hook)

(setq dashboard-items '((recents . 15)
			(bookmarks . 5)
			(projects . 5)))

(setq dashboard-banner-logo-title "Добро пожаловать в Emacs!")
(setq dashboard-projects-backend 'projectile)

(add-hook 'before-save-hook 'delete-trailing-whitespace)

(use-package ace-window
  :bind
  ("C-x w" . ace-window)
  :config
  (setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l))
  ;; (setq aw-ignore-unmapped-windows nil)
  )

(use-package projectile
  :ensure t
  :init
  (projectile-mode +1)
  :config
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
  (setq projectile-project-search-path '("~/Projects" "~/Projects/unimportant"))
  (setq projectile-switch-project-action 'projectile-dired)
  )



(use-package counsel
  :ensure t)
(use-package which-key
  :ensure t
  :config
  (which-key-mode))

(use-package ef-themes)
(setq lsp-clients-clangd-executable "/usr/bin/clangd-14")

()
