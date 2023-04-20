(setq user-full-name "replit"
      user-mail-address "replit@haedosa.xyz")

(setq default-input-method "korean-hangul3f")

(setq-default backup-directory-alist '(("" . "~/.backup"))
              make-backup-files t
              vc-make-backup-files t
              backup-by-copying t
              version-control t
              delete-old-versions t
              kept-new-versions 99
              kept-old-versions 0
)

(defun force-backup-of-buffer ()
  (setq buffer-backed-up nil)
  (backup-buffer))
(add-hook 'before-save-hook  'force-backup-of-buffer)

(setq doom-theme 'doom-one)

(setq doom-font (font-spec :family "Mononoki Nerd Font" :size 22)
      doom-big-font (font-spec :family "Mononoki Nerd Font" :size 36)
      doom-variable-pitch-font (font-spec :family "Mononoki Nerd Font" :size 22))

(setq display-line-numbers-type t)

(use-package! windsize
  :custom
  (windsize-cols 1)
  (windsize-rows 1)
  :commands windsize-left windsize-right
            windsize-up windsize-down
)

(map!
  "C-S-h" #'windsize-left
  "C-S-l" #'windsize-right
  "C-S-k" #'windsize-up
  "C-S-j" #'windsize-down
)

(use-package! winum
  :config
  (winum-mode 1)
)

(add-to-list 'default-frame-alist '(alpha 97 80))

(defun my/display-transparency (a b)
  (interactive "nAlpha Active:\nnAlpha Inactive:")
  (set-frame-parameter nil 'alpha `(,a . ,b)))

(use-package! envrc
  :hook (after-init . envrc-global-mode))

(use-package! lsp-mode
  :custom
  (lsp-completion-enable-additional-text-edit nil)
  (lsp-lens-enable nil)
  (lsp-keymap-prefix "C-c l")
  (lsp-headerline-breadcrumb-enable nil)
  (lsp-ui-sideline-enable nil)
  (lsp-ui-sideline-show-diagnostics nil)
  (lsp-modeline-diagnostics-enable nil)
  ;;(lsp-eldoc-enable-hover nil)
  :config
  (map! "C-,"       #'lsp-execute-code-action)
)

(use-package! lsp-ui
  :disabled t)

(after! lsp-ui
  (setq lsp-ui-doc-position 'top)
  (setq lsp-ui-doc-show-with-cursor t)
  (setq lsp-ui-sideline-show-code-actions t))

(defun my/cycle-lsp-ui-doc-position ()
  (interactive)
  (setq lsp-ui-doc-position
     (let ((x lsp-ui-doc-position))
        (cond ((eq x 'top) 'bottom)
              ((eq x 'bottom) 'at-point)
              ((eq x 'at-point) 'top))))
)

(defun set-lsp-ui-doc-size()
  (interactive)
  (setq lsp-ui-doc-text-scale-level 2)
  (setq lsp-ui-doc-max-width 300)
  (setq lsp-ui-doc-max-height 50))

(use-package! haskell-mode
  :hook ((haskell-mode . lsp-deferred)
         (haskell-mode . (lambda ()
                           (set-tab-width)
                           (turn-off-smartparens-mode)
                           (setq lsp-haskell-formatting-provider "fourmolu")
                           (global-subword-mode)
                           ))))

(add-hook 'lsp-after-open-hook (lambda ()
   (lsp-ui-mode -1)
   ))

;; add to $DOOMDIR/config.el
(after! lsp-mode
  (advice-remove #'lsp #'+lsp-dont-prompt-to-install-servers-maybe-a))

  (defun my/org-archive()
    (setq
      org-archive-mark-done nil
      org-archive-location "%s_arxiv::"
    )
  )

  (defun my/org-capture()
    (setq org-capture-templates `(
      ("h" "Haedosa" entry
        (file+olp+datetree ,(concat org-directory "/haedosa/README.org"))
        "* %? %U\n%a\n%i"
      )
      ("m" "Memo" entry
        (file+olp+datetree ,(concat org-directory "/memo/memo.org"))
        "* %? %U\n%a\n%i"
      )
      ("s" "Self" entry
        (file+olp+datetree ,(function buffer-file-name))
        "* %? %U\n%a\n%i"
      )
  )))

  (defun my/org-agenda()
    (setq org-agenda-files
       (list
          (concat org-directory "/haedosa/README.org")
          (concat org-directory "/memo/memo.org")
       )
    )

    (setq org-agenda-ndays 7
          org-agenda-show-all-dates t)
  )

  (defun my/org-babel()

    (org-babel-do-load-languages
      'org-babel-load-languages
      '((haskell . t)
        (emacs-lisp . t)
        (shell . t)
        (sql . t)
        (ruby . t)
        (python . t)
        (maxima . t)
        (C . t)
        (R . t)
        (latex . t)
        (ditaa . t)
        (java . t))
    )

    (setq org-catch-invisible-edits           'show
          org-src-preserve-indentation        t
          org-src-tab-acts-natively           t
          org-fontify-quote-and-verse-blocks  t
          org-return-follows-link             t
          org-edit-src-content-indentation    0
          org-src-fontify-natively            t
          org-confirm-babel-evaluate          nil
    )
  )

  (defun my/org-id()
    (advice-add 'org-id-new :filter-return #'upcase)
  )

(defun my/org-header-size()
  (dolist (face '((org-level-1 . 1.3)
                  (org-level-2 . 1.2)
                  (org-level-3 . 1.1)
                  (org-level-4 . 1.1)
                  (org-level-5 . 1.1)
                  (org-level-6 . 1.0)
                  (org-level-7 . 1.0)
                  (org-level-8 . 1.0)))
    (set-face-attribute (car face) nil :height (cdr face)))

    (setq org-format-latex-options
      '(:foreground default :background default :scale 4
        :html-foreground "Black" :html-background "Transparent" :html-scale 1.0
        :matchers ("begin" "$1" "$" "$$" "\\(" "\\[")))
)

(use-package! org
  :custom
  (org-directory                       "~/Ocean/Org")
  (org-ellipsis                        " ▾")
  (org-src-fontify-natively            t)
  (org-src-tab-acts-natively           t)
  (org-hide-block-startup              nil)
  (org-src-preserve-indentation        t)
  (org-startup-folded                  'content)
  (org-startup-indented                t)
  (org-startup-with-inline-images      nil)
  (org-hide-leading-stars              t)
  (org-attach-id-dir                   "data/")
  (org-export-with-sub-superscripts (quote {}))
  :config
  (my/org-archive)
  (my/org-capture)
  (my/org-agenda)
  (my/org-babel)
  (my/org-id)
  (my/org-header-size)
)

(use-package! swagger-to-org)

;; (defun my/org-roam-directory ()
;;   (let ((org-roam-directory (expand-file-name "Dropbox/roam" (getenv "HOME"))))
;;     (unless (file-exists-p org-roam-directory)
;;       (make-directory org-roam-directory t))
;;     org-roam-directory))

;; (use-package! org-roam
;;   :ensure t
;;   :custom
;;   (org-roam-directory (my/org-roam-directory))
;;   (org-roam-completion-everywhere t)
;;   :bind (("C-c n b" . org-roam-buffer-toggle)
;;          ("C-c n f" . org-roam-node-find)
;;          ;;("C-c n g" . org-roam-graph)
;;          ("C-c n i" . org-roam-node-insert)
;;          ("C-c n a" . org-roam-alias-add)
;;          ("C-c n u" . org-roam-ui-open)
;;          ("C-c n g" . org-id-get-create)
;;          ("C-c n t" . org-roam-tag-add)
;;          :map org-mode-map
;;          ("C-c n c" . org-roam-capture)
;;          ;; Dailies
;;          ("C-c n j" . org-roam-dailies-capture-today))
;;   :config
;;   ;; If you're using a vertical completion framework, you might want a more informative completion interface
;;     (setq org-roam-node-display-template (concat "${title:*} " (propertize "${tags:10}" 'face 'org-tag)))
;;     (org-roam-db-autosync-mode)
;; ;;   ;; If using org-roam-protocol
;;    (require 'org-roam-protocol))

;; (use-package! websocket
;;     :after org-roam)

;; (use-package! org-roam-ui
;;     :after org-roam ;; or :after org
;; ;;         normally we'd recommend hooking orui after org-roam, but since org-roam does not have
;; ;;         a hookable mode anymore, you're advised to pick something yourself
;; ;;         if you don't care about startup time, use
;; ;;  :hook (after-init . org-roam-ui-mode)
;;     :config
;;     (setq org-roam-ui-sync-theme t
;;           org-roam-ui-follow t
;;           org-roam-ui-update-on-save t
;;           org-roam-ui-open-on-start t))

(setq-default tab-width 2)
(setq-default evil-shift-width tab-width)
(setq-default indent-tabs-mode nil)

(defun set-tab-width()
  (interactive)
  (setq tab-width 2)
  (setq evil-shift-width tab-width)
  (setq indent-tabs-mode nil))

(setq-default evil-snipe-scope 'buffer)

(use-package! company
  ;; :config (company-box-mode)
  :custom (company-idle-delay nil))

(map! :map company-active-map
  "TAB"        #'company-complete-common-or-cycle
  "<tab>"      #'company-complete-common-or-cycle
  "C-SPC"      #'company-complete
  "<C-space>"  #'company-complete
)

(use-package! company-math
  :config
  (defun my/latex-mode-setup ()
    (interactive)
    (setq-local company-backends
                (append '((company-math-symbols-latex company-latex-commands))
                        company-backends)))
  )

(map! :map global-map "C-M-i"   #'completion-at-point)

(use-package! whitespace
  :custom (whitespace-style '(face tabs trailing
                              space-before-tab
                              newline empty
                              space-after-tab))
  :hook (((prog-mode org-mode) . whitespace-mode)
         (before-save . delete-trailing-whitespace))
)

(use-package! string-inflection)

(mapc (lambda (x) (add-to-list '+lookup-provider-url-alist x))
      (list
        '("Hackage"           "http://hackage.haskell.org/package/%s")
        '("Hoogle"            "http://www.haskell.org/hoogle/?q=%s")
        '("Haedosa Gitlab"    "https://gitlab.com/search?group_id=12624055&search=%s")
        '("Dictionary"        "http://dictionary.reference.com/browse/%s")
        '("Thesaurus"         "http://thesaurus.reference.com/search?q=%s")
        '("Google Scholar"    "https://scholar.google.com/scholar?q=%s")
        '("Nix Packages"      "https://search.nixos.org/packages?channel=unstable&query=%s")
        '("Nix Options"       "https://search.nixos.org/options?channel=unstable&query=%s")
        '("Libgen"            "http://libgen.rs/search.php?req=%s")))

(use-package! rg
  :commands (rg rg-menu)
  :bind ("C-c s" . rg-menu)
  :config
  (message "rg loaded")
)

(map! :leader
      (:prefix-map ("a" . "avy")
        :desc "avy-goto-char-2" "2" #'avy-goto-char-2
        :desc "avy-goto-char-timer" "a" #'avy-goto-char-timer
        :desc "avy-goto-line" "l" #'avy-goto-line
        :desc "avy-goto-word-0" "w" #'avy-goto-word-0
        :desc "avy-goto-subword-0" "s" #'avy-goto-subword-0
        :desc "avy-resume" "r" #'avy-resume
        :desc "avy-transpose-lines-in-region" "t" #'avy-transpose-lines-in-region
        (:prefix ("c" . "copy")
           :desc "avy-copy-region" "r" #'avy-copy-region
           :desc "avy-copy-line" "l" #'avy-copy-line)
        (:prefix ("m" . "move")
           :desc "avy-move-region" "r" #'avy-move-region
           :desc "avy-move-line" "l" #'avy-move-line)
      ))

(map! :leader
      (:prefix ("z" . "zoxide/fzf")
        :desc "fzf-directory"     "d" #'fzf-directory
        :desc "fzf-grep"          "g" #'fzf-grep
        :desc "fzf-git-grep"      "G" #'fzf-git-grep
        :desc "fzf-switch-buffer" "b" #'fzf-switch-buffer)
      ">" #'fzf-directory)

  (map! :leader
        (:prefix ("z" . "zoxide/fzf")
          :desc "zoxide-add"                    "a" #'zoxide-add
          :desc "zoxide-cd"                     "c" #'zoxide-cd
          :desc "zoxide-find-file"              "f" #'zoxide-find-file
          :desc "zoxide-travel"                 "t" #'zoxide-travel
          :desc "zoxide-remove"                 "x" #'zoxide-remove
          :desc "zoxide-add-with-query"         "A" #'zoxide-add-with-query
          :desc "zoxide-cd-with-query"          "C" #'zoxide-cd-with-query
          :desc "zoxide-find-file-with-query"   "F" #'zoxide-find-file-with-query
          :desc "zoxide-travel-with-query"      "T" #'zoxide-travel-with-query
        ))

(map! :leader "d" #'dired-jump)

(use-package! dired-hide-dotfiles
  :after dired
  :hook (dired-mode . dired-hide-dotfiles-mode)
  :config
    (map! (:map dired-mode-map
           :n "H" #'dired-hide-dotfiles-mode)))

(use-package! dired-ranger
  :after dired
  :bind (:map dired-mode-map
          ("C-c C-b" . dired-ranger-bookmark)
          ("C-c C-v" . dired-ranger-bookmark-visit)
          ("C-c C-p" . dired-ranger-paste)
          ("C-c C-y" . dired-ranger-copy)
          ("C-c C-x" . dired-ranger-move))
)

(use-package! all-the-icons-dired
  :after all-the-icons dired
  :hook (dired-mode . all-the-icons-dired-mode))

(setq which-key-idle-delay 0.1)

(use-package! vterm
  :bind
    ("C-c C-j" . vterm-send-C-j)
    ("C-c C-k" . vterm-send-C-k)
  :config
    (map! :after vterm
          :map vterm-mode-map
          :ni "C-j"    #'vterm-send-down
          :ni "C-k"    #'vterm-send-up
          :ni "<down>" #'vterm-send-down
          :ni "<up>"   #'vterm-send-up
          :ni "C-r"    #'vterm-send-C-r
          :ni "C-t"    #'vterm-send-C-t
          )   )

(use-package! vterm
  :config
    (defun get-full-list ()
      (let ((program-list (split-string (shell-command-to-string "compgen -c") "\n" t ))
            (file-directory-list (split-string (shell-command-to-string "compgen -f") "\n" t ))
            (history-list (with-temp-buffer
                            (insert-file-contents "~/.bash_history")
                            (split-string (buffer-string) "\n" t))))

        (delete-dups (append program-list file-directory-list history-list))))

    (defun vterm-completion-choose-item ()
      (completing-read "Choose: " (get-full-list) nil nil (thing-at-point 'word 'no-properties)))

    (defun vterm-completion ()
      (interactive)
      (vterm-directory-sync)
      (let ((vterm-chosen-item (vterm-completion-choose-item)))
        (when (thing-at-point 'word)
          (vterm-send-meta-backspace))
        (vterm-send-string vterm-chosen-item)))

    (defun vterm-directory-sync ()
      "Synchronize current working directory."
      (interactive)
      (when vterm--process
        (let* ((pid (process-id vterm--process))
               (dir (file-truename (format "/proc/%d/cwd/" pid))))
              (setq default-directory dir))))

    (map! :after vterm
          :map vterm-mode-map
          :ni "C-TAB"      #'vterm-completion
          :ni "C-<tab>"    #'vterm-completion
          :ni "C-RET"      #'vterm-directory-sync
          :ni "C-<return>" #'vterm-directory-sync))

  (defun get-current-workspace-name()
    (safe-persp-name (get-current-persp)))

  (map! :map (global-map vterm-mode-map org-mode-map)
        "M-["     #'+workspace/switch-left
        "M-]"     #'+workspace/switch-right
        "M-{"     #'+workspace/swap-left
        "M-}"     #'+workspace/swap-right
        "M-`"     #'+workspace/other
        "M-,"     #'+workspace/switch-to
        "M-TAB"   #'+workspace/switch-to
        "M-<tab>" #'+workspace/switch-to)

  (map! "C-{"      #'previous-buffer
        "C-}"      #'next-buffer)

  (map! :leader
        :desc "previous-buffer" "[" #'previous-buffer
        :desc "next-buffer"     "]" #'next-buffer)

  (map! :map (global-map org-mode-map)
        "C-j"  #'forward-paragraph
        "C-K"  #'backward-paragraph)

  (map! :map minibuffer-mode-map
        "M-j"  #'next-history-element
        "M-k"  #'previous-history-element)

  (map! :leader "r" #'consult-ripgrep)
