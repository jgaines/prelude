;;; jgaines.el --- personal settings common to all platforms

(set-language-environment "English")

(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/") t)

;;; This makes sure the .emacs.d/elpa/archive lists exist:
(when (not (assoc 'cygwin-mount package-archive-contents))
  (package-refresh-contents))

(defvar jgaines-required-packages '(carton pallet))


;;; Make sure carton & pallet are installed
(dolist (p jgaines-required-packages)
  (when (not (package-installed-p p))
    (package-install p)))

;;; Run pallet-install to make sure we have all packages installed.
(require 'pallet)
(pallet-install)


;;; Add a few more auto-installed modes
;;; Format is (extension package mode)
;;; NOTE: This does not do anything if the package is already
;;; installed, so if a package needs to be added to auto-mode-list
;;; manually, add a (when (package-installed-p 'foo) (add-to-list
;;; ...)) block after this.
(defvar jgaines-auto-install-alist
  '(
    ("CMakeLists\\.txt\\'" cmake-mode cmake-mode)
    ("\\.cmake\\'" cmake-mode cmake-mode)
    ))

(-each jgaines-auto-install-alist
       (lambda (entry)
         (let ((extension (car entry))
               (package (cadr entry))
               (mode (cadr (cdr entry))))
           (unless (package-installed-p package)
             (prelude-auto-install extension package mode)))))

(when (package-installed-p 'cmake-mode)
  (autoload 'cmake-mode "cmake-mode" "\
Major mode for editing CMake files.

The hook `cmake-mode-hook' is run with no args at mode
initialization.

\(fn)" t nil)
  (add-to-list 'auto-mode-alist
			   '("CMakeLists\\.txt\\'" . cmake-mode))
  (add-to-list 'auto-mode-alist
			   '("\\.cmake\\'" . cmake-mode)))

(when (package-installed-p 'crontab-mode)
  (add-to-list 'auto-mode-alist
			   '("\\.cron\\(tab\\)?\\'" . crontab-mode))
  (add-to-list 'auto-mode-alist
			   '("cron\\(tab\\)?\\." . crontab-mode)))

(when (package-installed-p 'groovy-mode)
  (add-to-list 'auto-mode-alist
			   '("\\.gradle\\'" groovy-mode groovy-mode)))

;; ntcmd doesn't set up auto-modes
(when (package-installed-p 'ntcmd)
  (add-to-list 'auto-mode-alist
			   '("\\.\\(cmd\\|bat\\)\\'" . ntcmd-mode)))

;; These modes are part of the std load for 24.x
(add-to-list 'auto-mode-alist '("\\.pc\\'" . c-mode))
(add-to-list 'auto-mode-alist '("_make\\'" . makefile-mode))

;;; Makes working with old Severstal code a little easier.
(setq c-default-style "k&r"
      c-basic-offset 4
      c-tab-always-indent nil
      perl-tab-always-indent nil)

(when (package-installed-p 'tuareg)
  (add-hook 'tuareg-mode-hook
			(function (lambda ()
						(setq tuareg-in-indent 0)
						(setq tuareg-let-always-indent t)
						(setq tuareg-let-indent tuareg-default-indent)
						(setq tuareg-with-indent 0)
						(setq tuareg-function-indent 0)
						(setq tuareg-fun-indent 0)
						;;(setq tuareg-parser-indent 0)
						(setq tuareg-match-indent 0)
						(setq tuareg-begin-indent tuareg-default-indent)
						;;(setq tuareg-parse-indent tuareg-default-indent); .mll
						(setq tuareg-rule-indent  tuareg-default-indent)
						(setq tuareg-font-lock-symbols nil)
						))))

;;; Use smex for M-x
(setq smex-save-file (concat user-emacs-directory ".smex-items"))
(smex-initialize)
(global-set-key (kbd "M-x") 'smex)

;;; Forces tabs to 8 spaces in all comint derived modes (shells,
;;; compiler, etc.)
(defun force-tabs-to-eight ()
  (setq tab-width 8))
(add-hook 'comint-mode-hook 'force-tabs-to-eight)

;;; Major environment settings here, hopefully I can limit Cygwin
;;; vs. Windoze config issues to here. If IGNORE_CYGWIN is set to
;;; anything in the environment, don't use Cygwin.
(defvar use-cygwin-flag (not (getenv "IGNORE_CYGWIN"))
  "By default, use Cygwin.")

(defun path-equal (path1 path2)
  "Compare two paths for equality on Windows it also does a
case-insensitive comparrison."
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
 ;; ========== Cygwin specific setup code ==========
 ((and (eq window-system 'w32)
       use-cygwin-flag
       (file-directory-p "c:/cygwin/bin"))
  ;; Add cygwin to /bin to exec-path, from:
  ;; http://gregorygrubbs.com/emacs/10-tips-emacs-windows/
  (add-to-list 'exec-path "c:/cygwin/bin" nil 'path-equal)
  (add-to-list 'exec-path "c:/cygwin/usr/local/bin" nil 'path-equal)
  (when (not (package-installed-p 'cygwin-mount))
    (package-install 'cygwin-mount))
  (require 'cygwin-mount)              ; lets Emacs grok Cygwin mounts
  (cygwin-mount-activate)
  ;; have to fix paths for pylint or it barfs
  (setq py-pylint-command (concat prelude-personal-dir "cygpylint"))
  ;; Set up TRAMP (requires Cygwin) from:
  ;; http://gregorygrubbs.com/emacs/10-tips-emacs-windows/
  (setq shell-file-name "bash")
  (setq explicit-shell-file-name shell-file-name)
  ;; sshx or scpx
  ;; sshx seems more stable, so I use it for most things
  ;; scpx appears to work better for SCO
  (eval-after-load 'tramp
    '(progn
       (setq tramp-default-method "sshx")
       (add-to-list 'tramp-default-method-alist
                    '("\\`ccarc[1-4]\\'" nil "scpx")) 
       (add-to-list 'tramp-default-method-alist
                    '("\\`Lmm3\\'" nil "scpx"))))

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
  ))
