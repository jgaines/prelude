;;; init-tomorrow-theme.el --- Initialize tomorrow-theme.

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

;; This is necessary because we're pulling in tomorrow-theme from
;; github and it's a multi-editor theme set, so it stores the themes
;; under a subdirectory "GNU Emacs".

;;; Code:

(add-to-list 'custom-theme-load-path "~/.emacs.d/el-get/tomorrow-theme/GNU Emacs")

(provide 'init-tomorrow-theme)

;;; init-tomorrow-theme.el ends here
