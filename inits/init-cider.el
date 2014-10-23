;;; init-cider.el --- CIDER is a Clojure IDE mode.

;; Copyright (C) 2013 John Gaines, Jr.

;; Author: John Gaines, Jr.
;; Maintainer: John Gaines, Jr.

;; This file is not part of GNU Emacs.

;; This program is free software: you can redistribute it and/or
;; modify it under the terms of the GNU General Public License as
;; published by the Free Software Foundation, either version 3 of the
;; License, or (at your option) any later version.

;; This program is distributed in the hope that it will be useful, but
;; WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;;

;;; Code:

(add-hook 'cider-repl-mode-hook
          (function (lambda ()
                      (rainbow-delimiters-mode +1)
                      (smartparens-strict-mode +1))))

(setq cider-interactive-eval-result-prefix ";; => ")
(setq cider-repl-result-prefix ";; => ")
(setq cider-repl-use-clojure-font-lock t)

(provide 'init-cider)

;;; init-cider.el ends here
