;;; init-tuareg-mode.el --- Tweak tuareg mode to the OCaml coding standards.

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

;; From posting by Christophe TROESTLER:
;; http://caml.inria.fr/pub/ml-archives/caml-list/2006/08/20a1076c4d8dc87e379ae7d0713b8c14.fr.html

;;; Code:

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
						(setq tuareg-font-lock-symbols nil)))))

(provide 'init-tuareg-mode)

;;; init-tuareg-mode.el ends here
