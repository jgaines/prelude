;;; init-crontab-mode.el --- Initialization for crontab-mode.

;;; Commentary:
;; Set up file associations for crontab-mode.

;;; Code:

(add-to-list 'auto-mode-alist
			 '("\\.cron\\(tab\\)?\\'" . crontab-mode))
(add-to-list 'auto-mode-alist
			 '("cron\\(tab\\)?\\." . crontab-mode))

(provide 'init-crontab-mode)

;;; init-crontab-mode.el ends here
