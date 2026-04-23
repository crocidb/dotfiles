;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face

;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
(setq doom-font (font-spec :family "FiraCode Nerd Font" :size 14 :weight 'semi-light))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-tomorrow-night)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `with-eval-after-load' block, otherwise Doom's defaults may override your
;; settings. E.g.
;;
;;   (with-eval-after-load 'PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look them up).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
;;
(map! :leader
      :desc "Live grep"                          "f z" #'consult-ripgrep
      :desc "All commands"                       "t t" #'execute-extended-command
      :desc "Notifications/warnings/errors"      "t e" #'+doom/popup-messages-buffer
      :desc "Document symbols"                   "s s" #'consult-imenu
      :desc "Diagnostics"                        "d d" #'consult-lsp-diagnostics
      :desc "Functions/methods"                  "m"   #'+default/search-buffer-functions)
;; config.el

;; Search for selected text (visual //)
(map! :v "//" (cmd! (let ((text (buffer-substring-no-properties (region-beginning) (region-end))))
                      (isearch-forward-regexp nil 1)
                      (isearch-yank-string text))))

;; Search word under cursor (normal //)
(map! :n "//" #'isearch-forward-symbol-at-point)

;; Jump list navigation (replaces C-O / C-I)
(map! :n "{" #'better-jumper-jump-backward
      :n "}" #'better-jumper-jump-forward)

;; Jump to previous/next method
(map! :n "(" #'+evil/previous-beginning-of-method
      :n ")" #'+evil/next-beginning-of-method)

;; Select whole block ahead (like bv -> f{%V%)
(map! :n "bv" (cmd! (evil-find-char 1 ?{)
                    (call-interactively #'evil-jump-item)
                    (evil-visual-line)
                    (call-interactively #'evil-jump-item)))

(map! "C-h" nil)
(map! :g "C-h" #'evil-window-left
      :g "C-j" #'evil-window-down
      :g "C-k" #'evil-window-up
      :g "C-l" #'evil-window-right)

(map! :n "<tab>"   (cmd! (call-interactively (key-binding (kbd "g t"))))
      :n "<backtab>" (cmd! (call-interactively (key-binding (kbd "g T")))))

(map! :g "M-1" (cmd! (+workspace/switch-to 0))
      :g "M-2" (cmd! (+workspace/switch-to 1))
      :g "M-3" (cmd! (+workspace/switch-to 2))
      :g "M-4" (cmd! (+workspace/switch-to 3))
      :g "M-5" (cmd! (+workspace/switch-to 4)))

(define-key evil-normal-state-map (kbd "J") nil)

(setq-default
 save-interrupted-sessions t
 +workspaces-on-switch-project-behavior 'load)
