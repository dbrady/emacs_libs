(require 'flymake-jslint)
(add-hook 'js-mode-hook
          (lambda () (flymake-mode 1)))

(add-hook 'js-mode-hook
          (lambda () (linum-mode t)))

(setq js-indent-level 2)

(provide 'javascript-config)
