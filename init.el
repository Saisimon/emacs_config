;; -*- coding: utf-8 -*-
;;(defvar best-gc-cons-threshold gc-cons-threshold "Best default gc threshold value. Should't be too big.")

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(defvar best-gc-cons-threshold 4000000 "Best default gc threshold value. Should't be too big.")
;; don't GC during startup to save time
(setq gc-cons-threshold most-positive-fixnum)

(setq emacs-load-start-time (current-time))

(add-to-list 'load-path (expand-file-name "~/.emacs.d/lisp"))

(add-to-list 'load-path "~/.emacs.d/site-lisp/jdee")
(require 'jdee)

;; 打开配置文件
(defun open-init-file()
  (interactive)
  (find-file "~/.emacs.d/init.el"))

;; 格式化当前缓冲区
(defun indent-buffer ()
  (interactive)
  (indent-region (point-min) (point-max)))

;; 格式化选中区域或当前缓冲区
(defun indent-region-or-buffer ()
  (interactive)
  (save-excursion
    (if (region-active-p)
        (progn
          (indent-region (region-beginning) (region-end)))
      (progn
        (indent-buffer)))))
;; 增强 occur 模式
;; 当选择一段区域时，默认查询选中区域的内容
;; 当光标在某个单词之中时，默认查询该单词的内容
(defun occur-dwim ()
  "Call `occur' with a sane default."
  (interactive)
  (push (if (region-active-p)
	    (buffer-substring-no-properties
	     (region-beginning)
	     (region-end))
	  (let ((sym (thing-at-point 'symbol)))
	    (when (stringp sym)
	      (regexp-quote sym))))
	regexp-history)
  (call-interactively 'occur))

(global-set-key (kbd "<f2>") 'open-init-file)
(global-set-key (kbd "C-M-\\") 'indent-region-or-buffer)
(global-set-key (kbd "C-c o") 'occur-dwim)
(global-set-key (kbd "C-c d a p") 'helm-do-ag-project-root)
(global-set-key (kbd "C-c d a f") 'helm-do-ag-this-file)
(global-set-key (kbd "C-c f f") 'counsel-git)
;; (global-set-key (kbd "C-=") 'er/expand-region)

(delete-selection-mode 1)
(global-hl-line-mode 1)

;;----------------------------------------------------------------------------
;; Which functionality to enable (use t or nil for true and false)
;;----------------------------------------------------------------------------
(setq initial-frame-alist (quote ((fullscreen . maximized))))
;; (setq ring-bell-function 'ignore)
(setq dired-recursive-deletes 'always)
(setq dired-recursive-copies 'always)
;; (set-language-environment "UTF-8")

(setq *is-a-mac* (eq system-type 'darwin))
(setq *win64* (eq system-type 'windows-nt) )
(setq *cygwin* (eq system-type 'cygwin) )
(setq *linux* (or (eq system-type 'gnu/linux) (eq system-type 'linux)) )
(setq *unix* (or *linux* (eq system-type 'usg-unix-v) (eq system-type 'berkeley-unix)) )
(setq *emacs24* (and (not (featurep 'xemacs)) (or (>= emacs-major-version 24))) )
(setq *no-memory* (cond
                   (*is-a-mac*
                    (< (string-to-number (nth 1 (split-string (shell-command-to-string "sysctl hw.physmem")))) 4000000000))
                   (*linux* nil)
                   (t nil)))

;; @see https://www.reddit.com/r/emacs/comments/3kqt6e/2_easy_little_known_steps_to_speed_up_emacs_start/
;; Normally file-name-handler-alist is set to
;; (("\\`/[^/]*\\'" . tramp-completion-file-name-handler)
;; ("\\`/[^/|:][^/|]*:" . tramp-file-name-handler)
;; ("\\`/:" . file-name-non-special))
;; Which means on every .el and .elc file loaded during start up, it has to runs those regexps against the filename.
(let ((file-name-handler-alist nil))
  (require 'init-modeline)
  (require 'cl-lib)
  (require 'init-compat)
  (require 'init-utils)
  (require 'init-site-lisp) ;; Must come before elpa, as it may provide package.el

  ;; Windows configuration, assuming that cygwin is installed at "c:/cygwin"
  ;; (condition-case nil
  ;;     (when *win64*
  ;;       ;; (setq cygwin-mount-cygwin-bin-directory "c:/cygwin/bin")
  ;;       (setq cygwin-mount-cygwin-bin-directory "c:/cygwin64/bin")
  ;;       (require 'setup-cygwin)
  ;;       ;; better to set HOME env in GUI
  ;;       ;; (setenv "HOME" "c:/cygwin/home/someuser")
  ;;       )
  ;;   (error
  ;;    (message "setup-cygwin failed, continue anyway")
  ;;    ))

  (require 'idle-require)
  (require 'init-elpa)
  (require 'init-exec-path) ;; Set up $PATH
  (require 'init-frame-hooks)
  ;; any file use flyspell should be initialized after init-spelling.el
  ;; actually, I don't know which major-mode use flyspell.
  (require 'init-spelling)
  (require 'init-xterm)
  (require 'init-gui-frames)
  (require 'init-ido)
  ;; (require 'init-dired)
  (require 'init-uniquify)
  (require 'init-ibuffer)
  (require 'init-flymake)
  (require 'init-smex)
  (require 'init-ivy)
  (require 'init-hippie-expand)
  (require 'init-windows)
  (require 'init-sessions)
  (require 'init-git)
  (require 'init-crontab)
  (require 'init-markdown)
  (require 'init-erlang)
  (require 'init-javascript)
  (require 'init-org)
  (require 'init-org-mime)
  (require 'init-css)
  (require 'init-python-mode)
  (require 'init-haskell)
  (require 'init-ruby-mode)
  (require 'init-lisp)
  (require 'init-elisp)
  (require 'init-yasnippet)
  ;; Use bookmark instead
  (require 'init-zencoding-mode)
  (require 'init-cc-mode)
  (require 'init-gud)
  (require 'init-linum-mode)
  ;; (require 'init-gist)
  (require 'init-moz)
  (require 'init-gtags)
  ;; use evil mode (vi key binding)
  (require 'init-evil)
  (require 'init-sh)
  (require 'init-ctags)
  (require 'init-bbdb)
  (require 'init-gnus)
  (require 'init-lua-mode)
  (require 'init-workgroups2)
  (require 'init-term-mode)
  (require 'init-web-mode)
  (require 'init-slime)
  (require 'init-clipboard)
  (require 'init-company)
  (require 'init-chinese-pyim) ;; cannot be idle-required
  ;; need statistics of keyfreq asap
  (require 'init-keyfreq)
  (require 'init-httpd)

  ;; projectile costs 7% startup time

  ;; misc has some crucial tools I need immediately
  (require 'init-misc)

  ;; comment below line if you want to setup color theme in your own way
  (if (or (display-graphic-p) (string-match-p "256color"(getenv "TERM"))) (require 'init-color-theme))

  (require 'init-emacs-w3m)
  (require 'init-hydra)

  ;; {{ idle require other stuff
  (setq idle-require-idle-delay 3)
  (setq idle-require-symbols '(init-misc-lazy
                               init-which-func
                               init-fonts
                               init-hs-minor-mode
                               init-textile
                               init-csv
                               init-writting
                               init-doxygen
                               init-pomodoro
                               init-emacspeak
                               init-artbollocks-mode
                               init-semantic))
  (idle-require-mode 1) ;; starts loading
  ;; }}

  (when (require 'time-date nil t)
    (message "Emacs startup time: %d seconds."
             (time-to-seconds (time-since emacs-load-start-time))))

  ;;----------------------------------------------------------------------------
  ;; Locales (setting them earlier in this file doesn't work in X)
  ;;----------------------------------------------------------------------------
  (require 'init-locales)

  ;; my personal setup, other major-mode specific setup need it.
  ;; It's dependent on init-site-lisp.el
  (if (file-exists-p "~/.custom.el") (load-file "~/.custom.el"))
  )

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(column-number-mode t)
 '(display-time-mode t)
 '(git-gutter:handled-backends (quote (svn hg git)))
 '(jdee-server-dir "~/.emacs.d/site-lisp/jdee")
 '(package-selected-packages
   (quote
    (yaml-mode yagist writeroom-mode workgroups2 wgrep w3m unfill tidy textile-mode tagedit swiper simple-httpd session scss-mode scratch rvm robe rinari request regex-tool rainbow-delimiters quack pomodoro pointback paredit page-break-lines nvm neotree mwe-log-commands multiple-cursors multi-term move-text markdown-mode lua-mode link less-css-mode legalese js2-mode idomenu ibuffer-vc hydra htmlize hl-sexp haskell-mode haml-mode groovy-mode gitignore-mode gitconfig-mode git-timemachine git-messenger git-link git-gutter ggtags fringe-helper flyspell-lazy flymake-ruby flymake-lua flymake-jslint flymake-css flymake-coffee flx-ido expand-region exec-path-from-shell erlang emmet-mode elpy dsvn diminish dictionary define-word crontab-mode cpputils-cmake connection company-c-headers color-theme coffee-mode cmake-mode cliphist buffer-move bbdb auto-compile ace-window)))
 '(safe-local-variable-values (quote ((lentic-init . lentic-orgel-org-init))))
 '(session-use-package t nil (session))
 '(show-paren-mode t)
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Consolas" :foundry "outline" :slant normal :weight normal :height 143 :width normal))))
 '(window-numbering-face ((t (:foreground "DeepPink" :underline "DeepPink" :weight bold))) t))

(setq gc-cons-threshold best-gc-cons-threshold)
;;; Local Variables:
;;; no-byte-compile: t
;;; End:
(put 'erase-buffer 'disabled nil)
(put 'dired-find-alternate-file 'disabled nil)
