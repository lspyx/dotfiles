(require 'package)
(setq package-archives '(("nongnu" . "https://elpa.nongnu.org/nongnu/")
                         ("gnu" . "https://elpa.gnu.org/packages/")
                         ("melpa" . "https://melpa.org/packages/")
                         ("melpa-stable" . "https://stable.melpa.org/packages/")))
(package-initialize)
(setq package-install-upgrade-built-in t)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t)

(use-package gcmh
  :init
  (gcmh-mode 1))
(setq native-comp-async-report-warnings-errors nil)

(use-package vertico
  :init
  (vertico-mode))

(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))

(use-package marginalia
  :init
  (marginalia-mode))

(use-package consult
  :bind (("C-s" . consult-line)
         ("C-x b" . consult-buffer)
         ("M-y" . consult-yank-pop)
         ("M-g g" . consult-goto-line)
         ("M-g i" . consult-imenu)
         ("M-s r" . consult-ripgrep)))

(use-package avy
  :bind ("C-;" . avy-goto-char-timer))

(use-package multiple-cursors
  :bind (("C->" . mc/mark-next-like-this)
         ("C-<" . mc/mark-previous-like-this)
         ("C-c C-<" . mc/mark-all-like-this)
         ("C-S-c C-S-c" . mc/edit-lines))
  :config
  (global-set-key (kbd "M-<mouse-1>") 'mc/add-cursor-on-click))

(use-package expand-region
  :bind ("C-=" . er/expand-region))

(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :hook ((c++-mode . lsp-deferred)
         (c-mode . lsp-deferred)
         (lsp-mode . lsp-enable-which-key-integration))
  :init
  (setq lsp-keymap-prefix "C-c l")
  :config
  (setq lsp-enable-on-type-formatting t)
  (setq lsp-clients-clangd-executable "/usr/bin/clangd-17")
  (setq lsp-clients-clangd-args '("-j=4" "--fallback-style=WebKit" "--query-driver=/usr/bin/g++*"))
  (setq lsp-enable-document-formatting t)
  (setq lsp-inlay-hints-mode t))

(use-package lsp-ui
  :after lsp-mode
  :hook (lsp-mode . lsp-ui-mode)
  :config
  (setq lsp-ui-doc-show-with-mouse nil)
  (setq lsp-ui-sideline-show-diagnostics t)
  (setq lsp-ui-sideline-show-hover t))

(use-package company
  :after lsp-mode
  :hook (lsp-mode . company-mode)
  :bind (:map company-active-map
              ("<tab>" . company-complete-common-or-cycle)
              ("TAB" . company-complete-common-or-cycle)
              ("<return>" . company-complete-selection)
              ("RET" . company-complete-selection))
  :config
  (setq company-idle-delay 0.1)
  (setq company-minimum-prefix-length 1))

(use-package magit)

(use-package diff-hl
  :init
  (global-diff-hl-mode)
  :config
  (add-hook 'magit-pre-refresh-hook 'diff-hl-magit-pre-refresh)
  (add-hook 'magit-post-refresh-hook 'diff-hl-magit-post-refresh))

(use-package projectile
  :init
  (projectile-mode +1)
  :config
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map))

(use-package vterm
  :commands vterm
  :config
  (setq vterm-max-scrollback 10000))

(use-package dashboard
  :config
  (dashboard-setup-startup-hook)
  (setq dashboard-items '((recents . 15) (bookmarks . 5) (projects . 5)))
  (setq dashboard-banner-logo-title "Have fun while you can")
  (setq dashboard-projects-backend 'projectile))

(use-package which-key
  :config
  (which-key-mode))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))


(defun my-point-is-at-natural-word-start-p ()
  (or (bobp)
      (save-excursion
        (backward-char 1)
        (not (looking-at "\\w")))))

(defun select-word-at-point-smart ()
  (interactive)
  (if (looking-at "\\w")
      (if (my-point-is-at-natural-word-start-p)
          (mark-word)
        (progn (backward-word) (mark-word)))))

(global-set-key [f8] 'neotree-toggle)

(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq c-basic-offset 4)
(global-display-line-numbers-mode 1)
(tool-bar-mode -1)
(delete-selection-mode 1)
(setq frame-resize-pixelwise t)

(let ((backup-dir (expand-file-name "~/.emacs.d/saves/backups/"))
      (auto-save-dir (expand-file-name "~/.emacs.d/saves/auto-saves/")))
  (make-directory backup-dir t)
  (make-directory auto-save-dir t)
  (setq backup-directory-alist `((".*" . ,backup-dir)))
  (setq auto-save-file-name-transforms `((".*" ,auto-save-dir t))))

(when (< 26 emacs-major-version)
  (tab-bar-mode 1)
  (setq tab-bar-new-tab-choice "*dashboard*")
  (global-set-key (kbd "C-x p") 'tab-bar-switch-to-prev-tab)
  (global-set-key (kbd "C-x n") 'tab-bar-switch-to-next-tab)
  (global-set-key (kbd "C-t") 'tab-bar-new-tab))

(add-hook 'before-save-hook 'delete-trailing-whitespace)
(add-hook 'before-save-hook
          (lambda ()
            (when (and (member major-mode '(c-mode c++-mode))
                       (bound-and-true-p lsp-mode))
              (lsp-format-buffer))))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes '(ef-spring))
 '(custom-safe-themes
   '("b3ba955a30f22fe444831d7bc89f6466b23db8ce87530076d1f1c30505a4c23b" "541282f66e5cc83918994002667d2268f0a563205117860e71b7cb823c1a11e9" "da69584c7fe6c0acadd7d4ce3314d5da8c2a85c5c9d0867c67f7924d413f4436" "a0e9bc5696ce581f09f7f3e7228b949988d76da5a8376e1f2da39d1d026af386" "2551f2b4bc12993e9b8560144fb072b785d4cddbef2b6ec880c602839227b8c7" "7de64ff2bb2f94d7679a7e9019e23c3bf1a6a04ba54341c36e7cf2d2e56e2bcc" "b5fd9c7429d52190235f2383e47d340d7ff769f141cd8f9e7a4629a81abc6b19" "720838034f1dd3b3da66f6bd4d053ee67c93a747b219d1c546c41c4e425daf93" "f253a920e076213277eb4cbbdf3ef2062e018016018a941df6931b995c6ff6f6" "b754d3a03c34cfba9ad7991380d26984ebd0761925773530e24d8dd8b6894738" "5c7720c63b729140ed88cf35413f36c728ab7c70f8cd8422d9ee1cedeb618de5" "0325a6b5eea7e5febae709dab35ec8648908af12cf2d2b569bedc8da0a3a81c1" "2ab8cb6d21d3aa5b821fa638c118892049796d693d1e6cd88cb0d3d7c3ed07fc" "d12b1d9b0498280f60e5ec92e5ecec4b5db5370d05e787bc7cc49eae6fb07bc0" "9d5124bef86c2348d7d4774ca384ae7b6027ff7f6eb3c401378e298ce605f83a" "3061706fa92759264751c64950df09b285e3a2d3a9db771e99bcbb2f9b470037" "e8ceeba381ba723b59a9abc4961f41583112fc7dc0e886d9fc36fa1dc37b4079" "9e5e0ff3a81344c9b1e6bfc9b3dcf9b96d5ec6a60d8de6d4c762ee9e2121dfb2" "921f165deb8030167d44eaa82e85fcef0254b212439b550a9b6c924f281b5695" "e14289199861a5db890065fdc5f3d3c22c5bac607e0dbce7f35ce60e6b55fc52" "93011fe35859772a6766df8a4be817add8bfe105246173206478a0706f88b33d" "f64189544da6f16bab285747d04a92bd57c7e7813d8c24c30f382f087d460a33" "0c83e0b50946e39e237769ad368a08f2cd1c854ccbcd1a01d39fdce4d6f86478" "21d2bf8d4d1df4859ff94422b5e41f6f2eeff14dd12f01428fa3cb4cb50ea0fb" "d97ac0baa0b67be4f7523795621ea5096939a47e8b46378f79e78846e0e4ad3d" "0f1341c0096825b1e5d8f2ed90996025a0d013a0978677956a9e61408fcd2c77" "0d2c5679b6d087686dcfd4d7e57ed8e8aedcccc7f1a478cd69704c02e4ee36fe" "77fff78cc13a2ff41ad0a8ba2f09e8efd3c7e16be20725606c095f9a19c24d3d" "4594d6b9753691142f02e67b8eb0fda7d12f6cc9f1299a49b819312d6addad1d" "5c8a1b64431e03387348270f50470f64e28dfae0084d33108c33a81c1e126ad6" "7771c8496c10162220af0ca7b7e61459cb42d18c35ce272a63461c0fc1336015" "4d5d11bfef87416d85673947e3ca3d3d5d985ad57b02a7bb2e32beaf785a100e" "1f292969fc19ba45fbc6542ed54e58ab5ad3dbe41b70d8cb2d1f85c22d07e518" "7c3d62a64bafb2cc95cd2de70f7e4446de85e40098ad314ba2291fc07501b70c" "b99ff6bfa13f0273ff8d0d0fd17cc44fab71dfdc293c7a8528280e690f084ef0" "e4a702e262c3e3501dfe25091621fe12cd63c7845221687e36a79e17cf3a67e0" "e8bd9bbf6506afca133125b0be48b1f033b1c8647c628652ab7a2fe065c10ef0" "b07d6ffc0e06dc400d623d0efc05a8c9043b4c33cfd1c85cca76f174d8ea246d" "0e4a97c12619ddf2892b0de051512ecc3c4d896042a4392b052177bfab23a6e4" "4fea1174a6eaba952c2c61cfbe4ec9aef5c81836d84a4b16149f3d97e8bae022" "36c5acdaf85dda0dad1dd3ad643aacd478fb967960ee1f83981d160c52b3c8ac" "00d7122017db83578ef6fba39c131efdcb59910f0fac0defbe726da8072a0729" "ae20535e46a88faea5d65775ca5510c7385cbf334dfa7dde93c0cd22ed663ba0" "a3a71b922fb6cbf9283884ac8a9109935e04550bcc5d2a05414a58c52a8ffc47" "cd5f8f91cc2560c017cc9ec24a9ab637451e36afd22e00a03e08d7b1b87c29ca" "1ad12cda71588cc82e74f1cabeed99705c6a60d23ee1bb355c293ba9c000d4ac" "ea4dd126d72d30805c083421a50544e235176d9698c8c541b824b60912275ba1" "211621592803ada9c81ec8f8ba0659df185f9dc06183fcd0e40fbf646c995f23" "296dcaeb2582e7f759e813407ff1facfd979faa071cf27ef54100202c45ae7d4" "59c36051a521e3ea68dc530ded1c7be169cd19e8873b7994bfc02a216041bf3b" "d6b369a3f09f34cdbaed93eeefcc6a0e05e135d187252e01b0031559b1671e97" "df39cc8ecf022613fc2515bccde55df40cb604d7568cb96cd7fe1eff806b863b" "e85a354f77ae6c2e47667370a8beddf02e8772a02e1f7edb7089e793f4762a45" "d609d9aaf89d935677b04d34e4449ba3f8bbfdcaaeeaab3d21ee035f43321ff1" "b1791a921c4f38cb966c6f78633364ad880ad9cf36eef01c60982c54ec9dd088" "ac893acecb0f1cf2b6ccea5c70ea97516c13c2b80c07f3292c21d6eb0cb45239" "c038d994d271ebf2d50fa76db7ed0f288f17b9ad01b425efec09519fa873af53" "6af300029805f10970ebec4cea3134f381cd02f04c96acba083c76e2da23f3ec" "aff0396925324838889f011fd3f5a0b91652b88f5fd0611f7b10021cc76f9e09" "90185f1d8362727f2aeac7a3d67d3aec789f55c10bb47dada4eefb2e14aa5d01" "cee5c56dc8b95b345bfe1c88d82d48f89e0f23008b0c2154ef452b2ce348da37" "19b62f442479efd3ca4c1cef81c2311579a98bbc0f3684b49cdf9321bd5dfdbf" "fae5872ff90462502b3bedfe689c02d2fa281bc63d33cb007b94a199af6ccf24" "71b688e7ef7c844512fa7c4de7e99e623de99a2a8b3ac3df4d02f2cd2c3215e7" "3d9938bbef24ecee9f2632cb25339bf2312d062b398f0dfb99b918f8f11e11b1" "b41d0a9413fb0034cea34eb8c9f89f6e243bdd76bccecf8292eb1fefa42eaf0a" default))
 '(fancy-splash-image "/home/lsp10/Pictures/Wallpapers/5.png")
 '(lsp-ui-sideline-show-hover nil)
 '(package-selected-packages
   '(nerd-icons doom-themes modus-themes gnu-elpa-keyring-update rainbow-delimiters vterm diff-hl expand-region consult marginalia orderless vertico gcmh multiple-cursors which-key counsel projectile dashboard treemacs-dap dap-ui ace-jump-mode clang-format company corfu dap-mode helm-lsp lsp-ivy lsp-treemacs lsp-ui magit neotree yasnippet))
 '(warning-suppress-types '((use-package))))

(setq-default line-spacing 0.025)
(global-set-key (kbd "M-j") 'mc/mark-next-like-this-word)

(use-package doom-themes
  :ensure t
  :config
  (doom-themes-treemacs-config)
  (doom-themes-org-config))

(add-to-list 'default-frame-alist '(font . "Monaspace Neon Var-12"))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(setq lsp-ui-sideline-show-hover nil)
