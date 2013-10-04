;;; prelude-el-get.el --- Initialize el-get.

;;; Commentary:

;; This is better than the first version, but it still stutters a bit
;; when firing up in a new environment.  I've found I have to start
;; and stop emacs a half a dozen times or so to get all the
;; dependencies to work out to el-get's satisfaction.

;;; Code:

(message "starting prelude-el-get")

(add-to-list 'load-path "~/.emacs.d/el-get/el-get")

(defvar el-get-packages nil
  "List of packages for el-get to load.")

(defvar el-get-packages-file
  (expand-file-name "el-get-packages.el" prelude-dir)
  "This file defines the list of packages for el-get to load.

It should contain (setq el-get-packages '(pkg1 pkg2 ...)) to set the
list of packages that will be loaded by el-get.")

;; Bootstrap el-get if it's not installed.
(unless (require 'el-get nil 'noerror)
  (with-current-buffer
      (url-retrieve-synchronously
       "https://raw.github.com/dimitri/el-get/master/el-get-install.el")
    (let (el-get-master-branch)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (setq
   package-archives
   '(("ELPA" . "http://tromey.com/elpa/")
     ("gnu" . "http://elpa.gnu.org/packages/")
     ("marmalade" . "http://marmalade-repo.org/packages/")
     ("melpa" . "http://melpa.milkbox.net/packages/")
     ("SC" . "http://joseito.republika.pl/sunrise-commander/")))
  (el-get-elpa-build-local-recipes))

(add-to-list 'el-get-recipe-path "~/.emacs.d/recipes")
(setq el-get-user-package-directory "~/.emacs.d/inits")

(when (file-exists-p el-get-packages-file)
  (load el-get-packages-file))

(message "calling el-get 'sync")
(el-get 'sync)

(message "making sure all el-get-packages are installed")
(dolist (p el-get-packages)
  (unless (el-get-package-installed-p p)
    (el-get-install p)))

(message "done with prelude-el-get")

(provide 'prelude-el-get)

;;; prelude-el-get.el ends here
