;;; jgaines.el --- personal settings common to all platforms

;; Add a few more auto-installed modes
(defvar jgaines-auto-install-alist
  '(("\\.fs\\'" fsharp-mode fsharp-mode)
    ("CMakeLists\\.txt\\'" cmake-mode cmake-mode)
    ("\\.cmake\\'" cmake-mode cmake-mode)
    ("\\.\\(cmd\\|bat\\)\\'" ntcmd-mode ntcmd-mode)
    ("\\.gradle\\'" groovy-mode groovy-mode)
    ("\\.[Cc][Ss][Vv]\\'" csv-mode csv-mode)
    ("\\.cron\\(tab\\)?\\'" crontab-mode crontab-mode)
    ("cron\\(tab\\)?\\." crontab-mode crontab-mode)
    ))

(-each jgaines-auto-install-alist
       (lambda (entry)
         (let ((extension (car entry))
               (package (cadr entry))
               (mode (cadr (cdr entry))))
           (unless (package-installed-p package)
             (prelude-auto-install extension package mode)))))

(defvar jgaines-required-packages '(carton pallet))

;; Make sure carton & pallet are installed
(dolist (p jgaines-required-packages)
  (when (not (package-installed-p p))
    (package-install p)))

(when (package-installed-p 'pallet)
  (require 'pallet))
