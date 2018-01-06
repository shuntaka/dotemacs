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
;;----------------------------------------------
(add-to-list 'default-frame-alist
	     '(font . "DejaVu Sans Mono-10"))
(set-face-attribute 'default nil
                    :family "Ricty Diminished Discord"
		    :height 240)


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
;; highlight between two parens
;; http://syohex.hatenablog.com/entry/20110331/1301584188
;;----------------------------------------------
(show-paren-mode 1)
(setq show-paren-delay 0)
(setq show-paren-style 'expression)
(set-face-attribute 'show-paren-match-face nil
                    :background nil :foreground nil
                    :underline "#ffff00" :weight 'extra-bold)

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
(set-face-attribute 'show-paren-match-face nil
                    :background nil :foreground nil
                    :underline "#ffff00" :weight 'extra-bold)


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
;; 5. Moving Cursor
;;=============================================
;;----------------------------------------------
;; Vim H, M, L
;;----------------------------------------------

(global-set-key (kbd "C-M-h") (lambda () (interactive) (move-to-window-line 0)))
(global-set-key (kbd "C-M-m") (lambda () (interactive) (move-to-window-line nil)))
(global-set-key (kbd "C-M-l") (lambda () (interactive) (move-to-window-line -1)))


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
;; hippie-exp-ext
;;----------------------------------------------
(require 'hippie-exp-ext)
(KEYBOARD-translate ?\C-i ?\H-i) ;;C-i と Tabの被りを回避
(global-set-key (kbd "H-i") 'hippie-expand-dabbrev-limited-chars)
(global-set-key (kbd "M-/") 'hippie-expand-file-name)



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
 '(package-selected-packages (quote (zenburn-theme use-package helm))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(define-key global-map (kbd "C-x C-f") 'helm-find-files)
(define-key global-map (kbd "C-x C-r") 'helm-recentf)
(define-key global-map (kbd "M-y") 'helm-show-kill-ring)
