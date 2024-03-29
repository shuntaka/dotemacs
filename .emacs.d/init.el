;;##########################################################################
;; Index
;;##########################################################################
;; 1. debug
;; 2. Basic Settings
;; 3. Key Binding
;; 4. Manipulating Buffers and Files
;; 5. Moving Cursor
;; 6. Input Support
;; 7. Search and Replace
;; 8. Making Emacs Even More Convinient
;; 9. External Program
;; 11. View Mode
;; 13. For Programming
;; 14. Create Documents
;; 15. Helm & Anything
;; Color Theme and Font
;; Manipulating Frame and Window
;; For HTML and CSS
;; For SCSS
;; For JavaScript
;; For Perl
;; For Yaml
;; For SQLPlus
;; Miscellenious


;;===========================================================================
;; 1. debug
;;===========================================================================
;;----------------------------------------------
;; debug
;;http://stackoverflow.com/questions/5413959/wrong-type-argument-stringp-nil
;;----------------------------------------------
;; (setq debug-on-error t)


;;=================================================================
;; 2. Basic Settings
;;=================================================================
;;----------------------------------------------
;; append the  directory and its subdirectoreis to the load-path
;;----------------------------------------------
;; define add-to-load-path
(defun add-to-load-path (&rest paths)
  (let (path)
    (dolist (path paths paths)
      (let ((default-directory
              (expand-file-name (concat user-emacs-directory path))))
        (add-to-list 'load-path default-directory)
        (if (fboundp 'normal-top-level-add-subdirs-to-load-path)
            (normal-top-level-add-subdirs-to-load-path))))))

;; add directories under "elisp", "elpa", "conf", "public_repos"
;;(add-to-load-path "el-get" "auto-install" "elisp" "elpa" "conf" "public_repos")
(add-to-load-path "elpa" "public_repos")

;;----------------------------------------------
;; elpa
;;----------------------------------------------
(package-initialize)
(setq package-archives
      '(("gnu" . "http://elpa.gnu.org/packages/")
        ("melpa" . "http://melpa.org/packages/")
        ("org" . "http://orgmode.org/elpa/")))

;;----------------------------------------------
;; color-theme(zenburn)
;;----------------------------------------------
;; set color-theme here before any style settings
;; since this would overwrite any style changes made before this
(use-package zenburn-theme
  :ensure t
  :config
  (load-theme 'zenburn t))

;;----------------------------------------------
;;font
;; https://gist.github.com/mitukiii/4365568
;;----------------------------------------------
;; (add-to-list 'default-frame-alist
;; 	     '(font . "DejaVu Sans Mono-10"))
;; (set-face-attribute 'default nil
;;                     :family "Ricty Diminished Discord"
;; 		    :height 240)

;; Monaco 12pt をデフォルトにする
(set-face-attribute 'default nil
                    :family "Monaco"
                    :height 200)
;; 日本語をヒラギノ角ゴProNにする
(set-fontset-font "fontset-default"
                  'japanese-jisx0208
                  '("Hiragino Maru Gothic ProN"))
;; 半角カナをヒラギノ角ゴProNにする
(set-fontset-font "fontset-default"
                  'katakana-jisx0201
                  '("Hiragino Maru Gothic ProN"))

;;----------------------------------------------
;; from Emacs Technique Bible Basic Setting
;;----------------------------------------------
;;; 履歴を次回Emacs起動時にも保存する
(savehist-mode 1)

;;; ファイル内のカーソル位置を記憶する
(setq-default save-place t)
(require 'saveplace)

;;; 対応する括弧を光らせる
(show-paren-mode t)

;;; auto paren 括弧自動補完 
;; (electric-pair-mode 1)


;;; シェルに合わせるため、C-hは後退に割り当てる
;;; ヘルプは<f1>
(global-set-key (kbd "C-h") 'delete-backward-char)

;;; モードラインに時刻を表示する
(display-time)

;;; 行番号・桁番号を表示する
(line-number-mode 1)
(column-number-mode 1)

;;; リージョンに色をつける
(transient-mark-mode 1)

;;; GCを減らして軽くする（デフォルトの10倍）
(setq gc-cons-threshold (* 10 gc-cons-threshold))

;;; ログの記録行数を増やす
(setq message-log-max 10000)

;;; ミニバッファを再起的に呼び出す
(setq enable-recursive-minibuffers t)

;;; ダイアログボックスを使わないようにする
(setq use-dialog-box nil)
(defalias 'message-box 'message)

;;; 履歴をたくさん保存する
(setq history-length 1000)

;;; キーストロークをエコーエリアに早く表示する
(setq echo-keystrokes 0.1)

;;; 大きいファイルを開くときに警告を表示する 10MBから25MBへ
(setq large-file-warning-threshold (* 25 1024 1024))

;;; ミニバッファで入力を取り消しても履歴に残す
;;; 誤って取り消して入力が失われるのを防ぐため
(defadvice abort-recursive-edit (before minibuffer-save activate)
  (when (eq (selected-window) (active-minibuffer-window))
    (add-to-history minibuffer-history-variable (minibuffer-contents))))

;;; yesをyで応答するように
(defalias 'yes-or-no-p 'y-or-n-p)

;;; goto-line ショートカット
(global-set-key "\M-g" 'goto-line)

;;----------------------
;; Hilight the current line
;;----------------------
(defface my-hl-line-face
  '((((class color) (background dark))
     (:background "NavyBlue" t))
    (((class color) (background light))
     (:background "LightGoldenrodYellow" t))
    (t (:bold t)))
  "hl-line's my face")
(setq hl-line-face 'my-hl-line-face)
(global-hl-line-mode t)

;;----------------------------------------------
;; make highlight the current line light
;; http://rubikitch.com/2015/05/14/global-hl-line-mode-timer/
;;----------------------------------------------
(defun global-hl-line-timer-function ()
  (global-hl-line-unhighlight-all)
  (let ((global-hl-line-mode t))
    (global-hl-line-highlight)))
(setq global-hl-line-timer
      (run-with-idle-timer 0.03 t 'global-hl-line-timer-function))
;; (cancel-timer global-hl-line-timer)

;;----------------------------------------------
;; show-paren-match
;; https://typeinf-memo.blogspot.com/2016/06/emacsshow-paren-match-faceremoved.html
;;----------------------------------------------
(set-face-attribute 'show-paren-match nil
      :background 'unspecified
      :underline "turquoise")

;;----------------------------------------------
;; highlight between two parens
;; http://syohex.hatenablog.com/entry/20110331/1301584188
;;----------------------------------------------
;; (show-paren-mode 1)
;; (setq show-paren-delay 0)
;; (setq show-paren-style 'expression)
;; (set-face-attribute 'show-paren-match-face nil
;;                     :background nil :foreground nil
;;                     :underline "#ffff00" :weight 'extra-bold)

;;----------------------------------------------
;; ターミナル以外はツーバーとスクロールバーを消す
;;----------------------------------------------
(when window-system
  (tool-bar-mode 0)
  (scroll-bar-mode 0))
(when (eq system-type 'darwin)
  (tool-bar-mode -1)
  (scroll-bar-mode -1))

;;----------------------
;; show the file path for the currently opned file
;;----------------------
(setq frame-title-format "%f")

(show-paren-mode 1)
(setq show-paren-delay 0)
(setq show-paren-style 'expression)
;; (set-face-attribute 'show-paren-match-face nil
;;                     :background nil :foreground nil
;;                     :underline "#ffff00" :weight 'extra-bold)


(setq redisplay-dont-pause nil)

;;=============================================
;; 3. Key Binding
;;=============================================

;;----------------------
;; use command key as meta key
;;----------------------
(setq ns-command-modifier (quote meta))
(setq ns-alternate-modifier (quote super))

;;----------------------
;; map C-h to backspace
;;----------------------
(keyboard-translate ?\C-h ?\C-?)

;;----------------------
;; use C-c l for toggle-truncate-lines
;;----------------------
(define-key global-map (kbd "C-c l") 'toggle-truncate-lines)

;;----------------------
;; use C-t for toggling the windows
;;----------------------
(define-key global-map (kbd "C-t") 'other-window)


;;----------------------
;;sequential.command.el
;;----------------------
;; (require 'sequential-command-config)
;; (sequential-command-setup-keys)

;;----------------------------------------------
;; 3.6 define-key
;;----------------------------------------------
(defun line-to-top-of-window () (interactive) (recenter 0))
(global-set-key (kbd "C-z") 'line-to-top-of-window)

;;=============================================
;; 4. Manipulating Buffers and Files
;;=============================================
;;----------------------------------------------
;; wdired.el
;; http://emacs.rubikitch.com/sd1411-dired-wdired/
;;----------------------------------------------
(require 'wdired)
(setq wdired-allow-to-change-permissions t)
(define-key dired-mode-map "e" 'wdired-change-to-wdired-mode)


;;=============================================
;; 5. Moving Cursor
;;=============================================
;;----------------------------------------------
;; point-undo
;;----------------------------------------------
(require 'point-undo)
(define-key global-map (kbd "M-p") 'point-undo)
(define-key global-map (kbd "M-n") 'point-redo)


;;----------------------------------------------
;; goto-chg.el
;;----------------------------------------------
(require 'goto-chg)
(global-set-key (kbd "M-i") 'goto-last-change)
(global-set-key (kbd "M-j") 'goto-last-change-reverse)

;;----------------------------------------------
;; Vim H, M, L
;;----------------------------------------------

(global-set-key (kbd "C-M-h") (lambda () (interactive) (move-to-window-line 0)))
(global-set-key (kbd "C-M-m") (lambda () (interactive) (move-to-window-line nil)))
(global-set-key (kbd "C-M-l") (lambda () (interactive) (move-to-window-line -1)))

;;----------------------------------------------
;; ace-jump-mode
;;http://rubikitch.com/2014/10/09/ace-jump-mode/
;;----------------------------------------------
;; ヒント文字に使う文字を指定する
(require 'ace-jump-mode)
(setq ace-jump-mode-move-keys
      (append "asdfghjkl;:]qwertyuiop@zxcvbnm,." nil))
;; ace-jump-word-modeのとき文字を尋ねないようにする
(setq ace-jump-word-mode-use-query-char nil)
(global-set-key (kbd "C-o") 'ace-jump-char-mode)
;; (global-set-key (kbd "C-;") 'ace-jump-word-mode)
(global-set-key (kbd "C-M-;") 'ace-jump-line-mode)



;;=============================================
;; 6. Input Support
;;=============================================
;;----------------------------------------------
;; 6.2 redo+
;;----------------------------------------------
(require 'redo+)
(global-set-key (kbd "C-M-/") 'redo)
(setq undo-no-redo t) ; 過去のundoがredoされないようにする
(setq undo-limit 600000)
(setq undo-strong-limit 900000)

;;----------------------------------------------
;; 6.7 yasnippet.el
;; http://emacs.rubikitch.com/sd1512-dabbrev-hippie-skeleton-yasnippet/
;; http://emacs.rubikitch.com/sd1601-auto-yasnippet-2/
;; http://vdeep.net/emacs-yasnippet

;;----------------------------------------------
(yas-global-mode 1)
;;; スニペット名をidoで選択する
(setq yas-prompt-functions '(yas-ido-prompt))
;; ("~/.emacs.d/snippets" yas-installed-snippets-dir)



;;----------------------------------------------
;; hippie-exp-ext
;;----------------------------------------------
(require 'hippie-exp-ext)
(keyboard-translate ?\C-i ?\H-i) ;;C-i と Tabの被りを回避
(global-set-key (kbd "H-i") 'hippie-expand-dabbrev-limited-chars)
(global-set-key (kbd "M-/") 'hippie-expand-file-name)

;;----------------------------------------------
;; kill-line and delete indent
;;http://dev.ariel-networks.com/wp/documents/aritcles/emacs/part16
;;----------------------------------------------
(defadvice kill-line (before kill-line-and-fixup activate)
  (when (and (not (bolp)) (eolp))
    (forward-char)
    (fixup-whitespace)
    (backward-char)))


;;=============================================
;; 14. Create Documents
;;=============================================
(require 'org)
(add-hook 'org-mode-hook
          (lambda ()
            (setq-default indent-tabs-mode nil)))

;;----------------------------------------------
;; pomodoro
;; https://www.youtube.com/watch?v=JbHE819kVGQ
;;----------------------------------------------
(setq org-clock-sound "./sounds/bell.mp3")

;;----------------------------------------------
;; org-mode keybind
;;----------------------------------------------
;; (define-key org-mode-map (kbd "<C-tab>") 'elscreen-next)
;; (define-key org-mode-map (kbd "<C-S-tab>")'elscreen-previous)
;; (define-key org-mode-map (kbd "C-'")'helm-elscreen)
;; (define-key org-mode-map (kbd "C-M-t") 'elscreen-kill)
;; (define-key org-mode-map (kbd "C-M-i") 'company-complete)
(define-key org-mode-map (kbd "C-M-i") 'helm-dabbrev)
(define-key org-mode-map (kbd "C-M-m") (lambda () (interactive) (move-to-window-line nil)))

;;----------------------
;; 14.2
;;----------------------
(require 'org)
(defun org-insert-upheading (arg)
  (interactive "P")
  (org-insert-heading arg)
  (cond ((org-on-heading-p) (org-do-promote))
        ((org-at-item-p) (org-indent-item -1 ))))
(defun org-insert-heading-dwim (arg)
  (interactive "p")
  (case arg
    (4  (org-insert-subheading nil))
    (16 (org-insert-upheading nil))
    (t  (org-insert-heading nil))))
(define-key org-mode-map (kbd "<C-return>") 'org-insert-heading-dwim)

;;----------------------
;; 14.6
;;----------------------
(require 'org)
(setq org-use-fast-todo-selection t)
(setq org-todo-keywords
      '((sequence "TODO(t)" "WIP(w)" "AWAIT(a)" "|" "DONE(x)")
        ;; '((sequence "TODO(t)" "WAITING(w)" "PROJECT(p)" "SUBPROJECT(s)" "|" "DONE(x)" "CANCEL(c)")
        (sequence "APPT(a)" "|" "DONE(x)" "CANCEL(c)")))


;;----------------------------------------------
;; insert code block
;; http://wenshanren.org/?p=334
;;----------------------------------------------
;; func to insert
(defun org-insert-src-block (src-code-type)
  "Insert a `SRC-CODE-TYPE' type source code block in org-mode."
  (interactive
   (let ((src-code-types
          '("emacs-lisp" "python" "C" "sh" "java" "js" "clojure" "C++" "css"
            "calc" "asymptote" "dot" "gnuplot" "ledger" "lilypond" "mscgen"
            "octave" "oz" "plantuml" "R" "sass" "screen" "sql" "awk" "ditaa"
            "haskell" "latex" "lisp" "matlab" "ocaml" "org" "perl" "ruby"
            "scheme" "sqlite")))
     (list (ido-completing-read "Source code type: " src-code-types))))
  (progn
    (newline-and-indent)
    (insert (format "#+BEGIN_SRC %s\n" src-code-type))
    (newline-and-indent)
    (insert "#+END_SRC\n")
    (previous-line 2)
    (org-edit-src-code)))

;; keybind
(add-hook 'org-mode-hook '(lambda ()
                            ;; turn on flyspell-mode by default
                            (flyspell-mode 1)
                            ;; C-TAB for expanding
                            ;; (local-set-key (kbd "C-<tab>")
                            ;;                'yas/expand-from-trigger-key)
                            ;; keybinding for editing source code blocks
                            (local-set-key (kbd "C-c s e")
                                           'org-edit-src-code)
                            ;; keybinding for inserting code blocks
                            (local-set-key (kbd "C-c s i")
                                           'org-insert-src-block)
                            ))

;; syntax highlight
(setq org-src-fontify-natively t)

;;===================================================================
;; 15. Helm & Anything
;;===================================================================
;;----------------------------------------------
;; helm keybind
;;----------------------------------------------
(define-key global-map (kbd "C-;") 'helm-for-files);
(define-key global-map (kbd "C-x C-x") 'helm-M-x)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(highlight-indent-guides yasnippet neotree helm-swoop zenburn-theme use-package helm)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(define-key global-map (kbd "C-x C-f") 'helm-find-files)
(define-key global-map (kbd "C-x C-r") 'helm-recentf)
(define-key global-map (kbd "M-y") 'helm-show-kill-ring)

;;----------------------------------------------
;; helm-swoop
;; https://github.com/ShingoFukuyama/helm-swoop
;;----------------------------------------------
(require 'helm-swoop)
;; disable pre-input
(setq helm-swoop-pre-input-function
      (lambda () ""))
(global-set-key (kbd "C-s") 'helm-swoop)
;;; isearchからの連携を考えるとC-r/C-sにも割り当て推奨
(define-key helm-swoop-map (kbd "C-r") 'helm-previous-line)
(define-key helm-swoop-map (kbd "C-s") 'helm-next-line)


;;=============================================
;; Manipulating Frame and Window
;;=============================================
;;----------------------------------
;; tab-bar-mode
;;----------------------------------
(define-key global-map (kbd "C-'") 'tab-switcher)
(define-key global-map (kbd "M-t") 'tab-new)
(define-key global-map (kbd "<C-tab>") 'tab-next)
(define-key global-map (kbd "<C-S-tab>")'tab-previous)
(define-key global-map (kbd "C-M-t") 'tab-close)

;;----------------------------------
;; neotree
;; https://github.com/jaypei/emacs-neotree
;;----------------------------------
(require 'neotree)
(global-set-key [f8] 'neotree-toggle)

;;----------------------------------
;; elscreen
;;----------------------------------
(require 'elscreen)

;; ;;; プレフィクスキーはC-z
;; (setq elscreen-prefix-key (kbd "C-'"))
;; (elscreen-start)
;; ;;; タブの先頭に[X]を表示しない
;; (setq elscreen-tab-display-kill-screen nil)
;; ;;; header-lineの先頭に[<->]を表示しない
;; (setq elscreen-tab-display-control nil)
;; ;;; バッファ名・モード名からタブに表示させる内容を決定する(デフォルト設定)
;; (setq elscreen-buffer-to-nickname-alist
;;       '(("^dired-mode$" .
;;          (lambda ()
;;            (format "Dired(%s)" dired-directory)))
;;         ("^Info-mode$" .
;;          (lambda ()
;;            (format "Info(%s)" (file-name-nondirectory Info-current-file))))
;;         ("^mew-draft-mode$" .
;;          (lambda ()
;;            (format "Mew(%s)" (buffer-name (current-buffer)))))
;;         ("^mew-" . "Mew")
;;         ("^irchat-" . "IRChat")
;;         ("^liece-" . "Liece")
;;         ("^lookup-" . "Lookup")))
;; (setq elscreen-mode-to-nickname-alist
;;       '(("[Ss]hell" . "shell")
;;         ("compilation" . "compile")
;;         ("-telnet" . "telnet")
;;         ("dict" . "OnlineDict")
;;         ("*WL:Message*" . "Wanderlust")))

;; タブ移動を簡単に
;; (define-key global-map (kbd "M-t") 'elscreen-next)

;;----------------------------------------------
;; elscreen keybind
;;http://qiita.com/saku/items/6ef40a0bbaadb2cffbce
;;http://blog.iss.ms/2010/02/25/121855
;;http://d.hatena.ne.jp/kobapan/20090429/1259971276
;;http://sleepboy-zzz.blogspot.co.uk/2012/11/emacs.html
;;----------------------------------------------
;; (define-key global-map (kbd "M-t") 'elscreen-create)
;; (define-key global-map (kbd "M-T") 'elscreen-clone)
;; (define-key global-map (kbd "<C-tab>") 'elscreen-next)
;; (define-key global-map (kbd "<C-S-tab>")'elscreen-previous)
;; (define-key global-map (kbd "C-M-t") 'elscreen-kill)
;;----------------------------------------------
;; helm-elscreen kenbind
;;----------------------------------------------
;; (define-key global-map (kbd "C-'") 'helm-elscreen)

;;----------------------------------------------
;; elscreen resume the last buffer on kill buffer
;; http://qiita.com/fujimisakari/items/d7f1b904de11dcb018c3
;;----------------------------------------------
;; ;; 直近バッファ選定時の無視リスト
;; (defvar elscreen-ignore-buffer-list
;;   '("*scratch*" "*Backtrace*" "*Colors*" "*Faces*" "*Compile-Log*" "*Packages*" "*vc-" "*Minibuf-" "*Messages" "*WL:Message"))
;; ;; elscreen用バッファ削除
;; (defun kill-buffer-for-elscreen ()
;;   (interactive)
;;   (kill-buffer)
;;   (let* ((next-buffer nil)
;;          (re (regexp-opt elscreen-ignore-buffer-list))
;;          (next-buffer-list (mapcar (lambda (buf)
;;                                      (let ((name (buffer-name buf)))
;;                                        (when (not (string-match re name))
;;                                          name)))
;;                                    (buffer-list))))
;;     (dolist (buf next-buffer-list)
;;       (if (equal next-buffer nil)
;;           (setq next-buffer buf)))
;;     (switch-to-buffer next-buffer)))
;; (global-set-key (kbd "C-x k") 'kill-buffer-for-elscreen)             ; カレントバッファを閉じる

;;=============================================
;; Misc
;;=============================================
;;----------------------------------
;; insert date
;; https://crosshope.hatenadiary.org/entry/20110602/1306947203
;;----------------------------------
(defun insert-current-time()
  (interactive)
  (insert (format-time-string "%Y-%m-%d(%a) %H:%M:%S" (current-time))))

(define-key global-map "\C-cd" `insert-current-time)


