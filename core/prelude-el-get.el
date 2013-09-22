;;; prelude-el-get.el --- Initialize el-get.

;;; Commentary:
;;; Code:

(message "Starting el-get init")

(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/") t)
(package-initialize)

(add-to-list 'load-path "~/.emacs.d/el-get/el-get")

(defvar el-get-packages-file 
  (expand-file-name "el-get-packages.el" prelude-dir)
  "This file defines the list of packages for el-get to load.

It should contain (setq el-get-packages '(pkg1 pkg2 ...)) to set the
list of packages that will be loaded by el-get.")

(unless (require 'el-get nil 'noerror)
  (with-current-buffer
      (url-retrieve-synchronously
       "https://raw.github.com/dimitri/el-get/master/el-get-install.el")
    (let (el-get-master-branch)
      (goto-char (point-max))
      (eval-print-last-sexp))))

(add-to-list 'el-get-recipe-path "~/.emacs.d/recipes")
(setq el-get-user-package-directory "~/.emacs.d/inits")

(defvar el-get-packages nil
  "List of packages for el-get to load.")

(when (file-exists-p el-get-packages-file)
  (load el-get-packages-file))

(el-get el-get-packages)

(provide 'prelude-el-get)

;;; prelude-el-get.el ends here
