;;; init-cmake-mode.el --- Initialize cmake-mode.

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
