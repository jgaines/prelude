;;; jgaines.el --- personal settings common to all platforms

;;; Commentary:

;;; Code:

(set-language-environment "English")

(require 'prelude-editor)

;; Override some Prelude settings:
;; turn off global guru-mode
(setq prelude-guru nil)
;; turn menu back on
(menu-bar-mode +1)
;; use jgaines theme (a tweaked cyperpunk theme)
(require 'jgaines-theme)
(load-theme 'jgaines t)
;; set fringe (gutter) back to 8 pixels
(if (fboundp 'fringe-mode)
    (fringe-mode 8))

;; turn on rainbow delimiters in all programming modes
(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)
;; some programming modes need their own hooks called
(if (fboundp 'd-mode)
	(add-hook 'd-mode-hook 'rainbow-delimiters-mode))
(if (fboundp 'erlang-mode)
	(add-hook 'erlang-mode-hook 'rainbow-delimiters-mode))
(if (fboundp 'js3-mode)
	(add-hook 'js3-mode-hook 'rainbow-delimiters-mode))

(autoload 'cflow-mode "cflow-mode")
(setq auto-mode-alist (append auto-mode-alist
			      '(("\\.cflow$" . cflow-mode))))

;; These modes are part of the std load for 24.x
(add-to-list 'auto-mode-alist '("\\.pc\\'" . c-mode))
(add-to-list 'auto-mode-alist '("_make\\'" . makefile-mode))

;;; Makes working with old Severstal code a little easier.
(setq c-default-style "k&r"
      c-basic-offset 4
      c-tab-always-indent nil
      perl-tab-always-indent nil)
(add-hook 'c-mode-hook (lambda ()
			 (setq tab-width 4)))

;; Force tabs to 8 spaces in all comint derived modes.  (shells,
;; compiler, etc.)
(defun force-tabs-to-eight ()
  "Set tab to 8 spaces."
  (setq tab-width 8))
(add-hook 'comint-mode-hook 'force-tabs-to-eight)

(defun goto-matching-bracket (arg)
  "Go to the matching bracket if on a bracket, otherwise insert % * ARG.

vi style of % jumping to matching bracket."
  (interactive "p")
  (cond ((looking-at "\\s\(") (forward-list 1) (backward-char 1))
	((looking-at "\\s\)") (forward-char 1) (backward-list 1))
	(t (self-insert-command (or arg 1)))))
(global-set-key (kbd "%") 'goto-matching-bracket)

;; Set this again because el-get resets it after loading package.
(setq
 package-archives
 '(("ELPA" . "http://tromey.com/elpa/")
   ("gnu" . "http://elpa.gnu.org/packages/")
   ("marmalade" . "http://marmalade-repo.org/packages/")
   ("melpa" . "http://melpa.milkbox.net/packages/")
   ("SC" . "http://joseito.republika.pl/sunrise-commander/")))

;;; Major environment settings here, hopefully I can limit Cygwin
;;; vs. Windoze config issues to here. If IGNORE_CYGWIN is set to
;;; anything in the environment, don't use Cygwin.
(defvar use-cygwin-flag (not (getenv "IGNORE_CYGWIN"))
  "Non-nil means use Cygwin.")

(defun path-equal (path1 path2)
  "Compare PATH1 and PATH2 for equality.

On Windows it also does a case-insensitive comparison."
  (and (stringp path1) ; make sure they're both strings
       (stringp path2)
       (or
        (equal path1 path2)
        (equal (expand-file-name path1)
               (expand-file-name path2))
        (and (eq window-system 'w32)
             (equal (downcase (expand-file-name path1))
                    (downcase (expand-file-name path2)))))))

;;; Environment specific settings.  If these blocks get much bigger,
;;; it would probably make sense to factor them out into separate
;;; files which we just require.
(cond
 ;; ========== Cygwin Emacs-w32 ==========
 ((and (eq window-system 'w32)
	   (equal (getenv "SHELL") "/bin/bash"))

  ;; sshx or scpx
  ;; sshx seems more stable, so I use it for most things
  ;; scpx appears to work better for SCO
  ;; (eval-after-load 'tramp
  ;;   '(progn
  ;;      (setq tramp-default-method "sshx")))
  (setq tramp-default-method "scpc")

  (let ((gambit-path "/drive/c/Program Files (x86)/Gambit-C/v4.6.7-gcc/"))
	(add-to-list 'load-path
				 (expand-file-name "share/emacs/site-lisp" gambit-path))
	(add-to-list 'exec-path (expand-file-name "bin" gambit-path) nil 'path-equal))
  (autoload 'gambit-inferior-mode
	"gambit" "Hook Gambit mode into cmuscheme.")
  (autoload 'gambit-mode
	"gambit" "Hook Gambit mode into scheme.")
  (add-hook 'inferior-scheme-mode-hook
			(function gambit-inferior-mode))
  (add-hook 'scheme-mode-hook
			(function gambit-mode))
  (setq scheme-program-name "gsi -:d-")

  (server-start)
  )
 ;; ========== NTEmacs & Cygwin specific setup code ==========
 ((and (eq window-system 'w32)
       use-cygwin-flag
       (file-directory-p "c:/cygwin/bin"))
  ;; Add cygwin to /bin to exec-path, from:
  ;; http://gregorygrubbs.com/emacs/10-tips-emacs-windows/
  (add-to-list 'exec-path "c:/cygwin/bin" nil 'path-equal)
  (add-to-list 'exec-path "c:/cygwin/usr/local/bin" nil 'path-equal)
  (when (not (el-get-package-installed-p 'cygwin-mount))
    (el-get-install 'cygwin-mount))
  (require 'cygwin-mount)              ; lets Emacs grok Cygwin mounts
  (cygwin-mount-activate)
  ;; have to fix paths for pylint or it barfs
  (setq py-pylint-command (concat prelude-personal-dir "cygpylint"))
  ;; Set up TRAMP (requires Cygwin) from:
  ;; http://gregorygrubbs.com/emacs/10-tips-emacs-windows/
  (setq shell-file-name "bash")
  (setq explicit-shell-file-name shell-file-name)
  ;; Emacs gets this wrong.
  (grep-apply-setting 'grep-use-null-device nil)
  (add-to-list 'Info-additional-directory-list "c:/cygwin/usr/share/info" t)
  ;; sshx or scpx
  ;; sshx seems more stable, so I use it for most things
  ;; scpx appears to work better for SCO
  (eval-after-load 'tramp
    '(progn
       (setq tramp-default-method "sshx")
       ;(add-to-list 'tramp-default-method-alist
       ;             '("\\`ccarc[1-4]\\'" nil "scpx"))
       ;(add-to-list 'tramp-default-method-alist
       ;             '("\\`lmm3\\'" nil "scpx"))
	   ))

  ;; This lets woman (emacs built-in man clone) find all the man files
  ;; I've got scattered all over my machine.
  (setq woman-manpath
		'(
		  "c:/cygwin/usr/share/man"
		  "c:/cygwin/usr/share/doc/man"
		  "c:/cygwin/usr/ssl/man"
		  "c:/cygwin/usr/share/texmf/doc/man"
		  "c:/chicken/man"
		  "c:/chicken/share/man"
		  "c:/D/dmd2/man"
		  "c:/Ruby/v1.9.3-p0/share/man"
		  "c:/Program Files (x86)/DreamPie/share/man"
		  "c:/Program Files/erl5.10.1/erts-5.10.1/man"
		  "c:/Python27/man"
		  "c:/Python27/share/man"
		  "c:/projects/gtk/man"
		  "c:/projects/gtk/share/man"
		  "c:/cygwin/usr/man"
		  "c:/cygwin/usr/X11R6/share/man"
		  "c:/cygwin/usr/X11R6/man"
		  "c:/cygwin/usr/local/share/man"
		  "c:/cygwin/usr/local/man"
		  "c:/cygwin/opt/gnome/man"
		  "c:/cygwin/usr/i686-pc-mingw32/sys-root/mingw/share/man"
		  "c:/cygwin/usr/local/mercury-11.01/man"
		  "c:/msysgit/mingw/man"
		  "c:/msysgit/mingw/share/man"
		  ))

  (add-to-list 'load-path
			   "C:/Program Files (x86)/Gambit-C/v4.6.7-gcc/share/emacs/site-lisp")
  (autoload 'gambit-inferior-mode
	"gambit" "Hook Gambit mode into cmuscheme.")
  (autoload 'gambit-mode
	"gambit" "Hook Gambit mode into scheme.")
  (add-hook 'inferior-scheme-mode-hook
			(function gambit-inferior-mode))
  (add-hook 'scheme-mode-hook
			(function gambit-mode))
  (setq scheme-program-name "gsi -:d-")

  ;; Setup up emacs-w3m package.
  ;; (add-to-list 'load-path
  ;;              (concat user-emacs-directory "manual/w3m/")
  ;;              nil 'path-equal)
  ;; (require 'w3m-load)
  )
 ;; ========== Windows (no-cygwin) specific setup code ==========
 ((eq window-system 'w32)
  ;; TODO: Need some functions for locating executables so that I
  ;; don't have to hard-code things like "C:/Program Files (x86)"
  ;; which is liable to be different between work/home.  Also having
  ;; some functions for manipulating the exec-path list might be nice
  ;; since it bothers me to have the same dir twice in it. ;)

  ;; don't think I need these now that I set up path properly in the
  ;; startup scripts
  ;; (add-to-list 'exec-path "c:/ezwinports/bin")
  ;; (add-to-list 'exec-path "c:/GnuWin32/bin")

  ;; To make Emacs work the way I want it under Windows 7 (without
  ;; causing grief with win7 or cygwin, set the following registry
  ;; key:
  ;;   HKCU\SOFTWARE\GNU\Emacs\HOME
  ;;   HKCU\SOFTWARE\GNU\Emacs\LANG
  ;;   HKCU\SOFTWARE\GNU\Emacs\PRELOAD_WINSOCK
  ;; Load order is environment, HKCU, HKLM, compiled-in defaults.

  (add-to-list 'exec-path "C:/Program Files (x86)/PuTTY/" nil 'path-equal)
  (setq tramp-default-method "pscp")
  (setq-default ispell-program-name "C:/Program Files (x86)/aspell/bin/aspell")
  )
 ;; ========== Unix specific setup code ==========
 (t
  (setq tramp-default-method "scpc")

  (server-start)
  ))

(provide 'jgaines)

;;; jgaines.el ends here
