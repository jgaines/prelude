;;; init-Emacs-Groovy-Mode.el --- Initialize Emacs-Groovy-Mode.

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

;; TODO: Should probably move this into el-get-packages.el.

;;; Code:

(add-to-list 'auto-mode-alist
			 '("\\.gradle\\'" groovy-mode groovy-mode))

(provide 'init-Emacs-Groovy-Mode)

;;; init-Emacs-Groovy-Mode.el ends here
