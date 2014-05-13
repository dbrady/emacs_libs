;; Org-mode settings
(require 'org-install)
(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)


(setq org-todo-keywords
       '((sequence "TODO(t)" "NEXT(n)" "STARTED(s)" "WAITING(w)" "APPT(a)" "DELEGATED(l)"
                   "PROJECT(p)" "AGENDA(g)"
       "|" "DONE(d)" "CANCELLED(c)" "DEFERRED(f)")))
(setq org-tag-alist '(("@work" . ?w) ("@home" . ?h) ("computer" . ?c)
          ("errands" . ?e) ("costco" . ?t) ("grocery" . ?g)
          ("project" . ?p) ("agenda" . ?a)))
(setq org-latex-to-pdf-process '("texi2dvi --pdf --clean --verbose --batch %f"))

(setf org-adapt-indentation t)

(add-hook 'org-mode-hook '(lambda ()
                             (show-all)))


;; ----------------------------------------------------------------------
;; Hat Tip to Tim Harper for code to add checkbox to org-mode when
;; hitting M-enter in a checklist
(defadvice org-insert-item (before org-insert-item-autocheckbox activate)
  (save-excursion
    (org-beginning-of-item)
    (when (org-at-item-checkbox-p)
      (ad-set-args 0 '(checkbox)))))

;;if you auto-load emacs... this will patch org-mode after it loads:
(eval-after-load "org-mode"
  '(defadvice org-insert-item (before org-insert-item-autocheckbox activate)
     (save-excursion
       (when (org-at-item-p)
         (org-beginning-of-item)
         (when (org-at-item-checkbox-p)
           (ad-set-args 0 '(checkbox)))))))
;; ----------------------------------------------------------------------

;; ----------------------------------------------------------------------
;; KWM: org-insert-journal-title

;; insert e.g. "* 2014-05-09 Fri TODO\n\n\n" at the top of the
;; document. I usually also begin my journal by copying the previous
;; day's journal, so ideally also search for the existence of "*
;; \d\d\d\d-\d\d-\d\d .* TODO" at the top of the document, and if
;; found, delete that line first.
;; ----------------------------------------------------------------------


;; ----------------------------------------------------------------------
;; KWM: org-uncheck-everything
;;
;; PDI. This is probably just a macro or a search-and-replace. Ideally
;; search for each /^[[:space:]*]- \[X\]/ entry, then C-e, then C-c
;; C-c.
;; C-e is move-end-of-line
;; C-c C-c is org-ctrl-c-ctrl-c
;; ----------------------------------------------------------------------

(provide 'org-config)
