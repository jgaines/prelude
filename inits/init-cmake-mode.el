;;; init-cmake-mode.el --- Initialization for cmake-mode.

;;; Commentary:
;; Set up autoload and filename associations for cmake-mode.

;;; Code:

(autoload 'cmake-mode "cmake-mode" "\
Major mode for editing CMake files.

The hook `cmake-mode-hook' is run with no args at mode
initialization.

\(fn)" t nil)

(add-to-list 'auto-mode-alist
			 '("CMakeLists\\.txt\\'" . cmake-mode))
(add-to-list 'auto-mode-alist
			 '("\\.cmake\\'" . cmake-mode))

(provide 'init-cmake-mode)

;;; init-cmake-mode.el ends here
