;;; Tweak tuareg mode to the OCaml coding standards.
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
						(setq tuareg-font-lock-symbols nil)
						))))
