(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives '("gnu" . "https://elpa.gnu.org/packages/") t)
(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

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
         (c-mode . lsp-deferred))
  :init
  (setq lsp-keymap-prefix "C-c l")
;;  :config
;;  (define-key lsp-mode-map (kbd "M-,") 'lsp-closeness-navigator-backward) ;
;;  (define-key lsp-mode-map (kbd "M-<") 'lsp-closeness-navigator-forward)
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

(use-package modus-themes
  :ensure t
  )

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
 '(package-selected-packages
   '(ace-jump-mode company corfu lsp-ui magit modus-themes neotree)))
(custom-set-faces
 )

(when (< 26 emacs-major-version)
 (tab-bar-mode 1)
 (setq tab-bar-show 1)
 (setq tab-bar-close-button-show nil)
 (setq tab-bar-new-tab-choice "*dashboard*")
 (setq tab-bar-tab-hints t)
  (setq tab-bar-format '(tab-bar-format-tabs tab-bar-separator)))


(load-theme 'modus-vivendi-tinted t)
(global-set-key (kbd "M-j") 'select-word-at-point-smart)
(global-display-line-numbers-mode 1)
(tool-bar-mode -1)
(global-set-key (kbd "C-x p") 'tab-bar-switch-to-prev-tab)
(global-set-key (kbd "C-x n}") 'tab-bar-switch-to-next-tab)
(global-set-key (kbd "C-t") 'tab-bar-new-tab)
(delete-selection-mode 1)
(global-set-key [f8] 'neotree-toggle)
(which-key-mode)

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
