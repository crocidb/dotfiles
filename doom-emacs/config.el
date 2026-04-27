;; GENERAL
(setq user-full-name "Bruno Croci"
      user-mail-address "bruno@croci.me")

(setq confirm-kill-emacs nil)

;; APPEARANCE
(setq doom-font (font-spec :family "FiraCode Nerd Font" :size 14 :weight 'semi-light))
(setq doom-theme 'doom-1337)
(setq display-line-numbers-type 'relative)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; HELPER FUNCTIONS
(defun +my/comment-dwim ()
  "Toggle comment on the active region, or on the current line."
  (interactive)
  (if (or (use-region-p) (evil-visual-state-p))
      (comment-or-uncomment-region (region-beginning) (region-end))
    (comment-or-uncomment-region (line-beginning-position) (line-end-position))))

(defun +my/opencode-send-region-with-prompt ()
  "Prompt for input and send it with the active region as context to opencode."
  (interactive)
  (unless (use-region-p)
    (user-error "No active region"))
  (let ((region (buffer-substring-no-properties (region-beginning) (region-end)))
        (prompt (read-string "OpenCode: ")))
    (with-last-opencode-session
     (opencode-api-send-message (opencode-session-id)
                                `((agent . ,(alist-get 'name opencode-session-agent))
                                  ,(assoc 'model opencode-session-agent)
                                  (variant . ,(or opencode-session-variant ""))
                                  (parts . (((type . text) (text . ,prompt))
                                            ((type . text) (text . ,(concat "<region>" region "</region>"))
                                             (synthetic . t)
                                             (metadata . ((region-id . ,(gensym))))))))
                                _result))))


;; MAPS
(map! :leader
      :desc "Live grep"                          "f z" #'consult-ripgrep
      :desc "Find file in project"               "f f" #'projectile-find-file
      :desc "All commands"                       "t t" #'execute-extended-command
      :desc "Notifications/warnings/errors"      "t e" #'+doom/popup-messages-buffer
      :desc "Document symbols"                   "s s" #'consult-imenu
      :desc "Diagnostics"                        "d d" #'consult-lsp-diagnostics
      :desc "Functions/methods"                  "m"   #'+default/search-buffer-functions
      :desc "Toggle comment"                     "/"   #'+my/comment-dwim
      :desc "Close buffer"                       "x"   #'kill-current-buffer)

(map! :leader "g r" nil)
(map! :leader
      :desc "Find references"                    "g r r" #'+lookup/references)

(map! :nv "g j" #'evil-next-visual-line
      :nv "g k" #'evil-previous-visual-line)

(map! :n "{" #'better-jumper-jump-backward
      :n "}" #'better-jumper-jump-forward)
(map! :n "(" #'+evil/previous-beginning-of-method
      :n ")" #'+evil/next-beginning-of-method)
(map! :n "<tab>"   (cmd! (call-interactively (key-binding (kbd "g t"))))
      :n "<backtab>" (cmd! (call-interactively (key-binding (kbd "g T")))))
(map! :g "M-1" (cmd! (+workspace/switch-to 0))
      :g "M-2" (cmd! (+workspace/switch-to 1))
      :g "M-3" (cmd! (+workspace/switch-to 2))
      :g "M-4" (cmd! (+workspace/switch-to 3))
      :g "M-5" (cmd! (+workspace/switch-to 4)))

(map! "C-h" nil)
(map! :gnvim "C-h" #'evil-window-left
      :gnvim "C-j" #'evil-window-down
      :gnvim "C-k" #'evil-window-up
      :gnvim "C-l" #'evil-window-right)

(map! :g "M-p" #'opencode
      :g "M-m" #'+my/opencode-send-region-with-prompt)

(define-key evil-normal-state-map (kbd "J") nil)

(setq-default
 save-interrupted-sessions t
 +workspaces-on-switch-project-behavior 'load)

;; Per-directory session persistence: `emacs .` in a folder restores the last
;; session saved for that folder.
(defvar +my/startup-session-file nil)

(defun +my/session-file-for (dir)
  (expand-file-name
   (concat "project-sessions/" (secure-hash 'md5 (expand-file-name dir)))
   doom-data-dir))

(add-hook 'emacs-startup-hook
          (lambda ()
            (setq +my/startup-session-file (+my/session-file-for default-directory))
            (when (file-exists-p +my/startup-session-file)
              (doom-load-session +my/startup-session-file))))

(add-hook 'kill-emacs-hook
          (lambda ()
            (when +my/startup-session-file
              (make-directory (file-name-directory +my/startup-session-file) t)
              (doom-save-session +my/startup-session-file))))

;; PLUGIN SETUP
(add-to-list 'display-buffer-alist
             '("\\*OpenCode" (display-buffer-reuse-window display-buffer-pop-up-window)))

(use-package! wakatime-mode
  :when (file-directory-p "~/.wakatime")
  :hook (after-init . global-wakatime-mode)
  :config
  (setq wakatime-cli-path (expand-file-name "~/.wakatime/wakatime-cli")))
