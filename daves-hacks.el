;; THIS FILE IS FOR HACKS ONLY

;; Don't put "keeper" code in here--this file is for crap like
;; patching up version conflicts, e.g. silencing mumamo warnings in
;; emacs 24 and the like

;; ----------------------------------------------------------------------
;; Turno off annoying mumamo warning that cropped up in 24.2 and is
;; still around in 24.3. NB: I believe this is because mumamo is using
;; deprecated calls, not because emacs is "teh dubm and cannot brane".

;; https://gist.github.com/tkf/3951163/raw/d900d37cbf7b05c6d94f3104f8aad46184c532ab/workaround-mumamo-buffer-file-name-warnings.el
;;
;; Workaround the annoying warnings:
;;    Warning (mumamo-per-buffer-local-vars):
;;    Already 'permanent-local t: buffer-file-name
(when (and (equal emacs-major-version 24)
           ;; dbrady - change equal to >= -- still borked in 24.3.1
           (>= emacs-minor-version 2))
  (eval-after-load "mumamo"
    '(setq mumamo-per-buffer-local-vars
           (delq 'buffer-file-name mumamo-per-buffer-local-vars))))


;; ---------------------------------------------------------------------
;; make-emacs-shutup-about-font-lock-syntactic-keywords
;;
;; Run this if you open a mixed-mode (html+js+erb, usually) file and
;; get these errors:
;;
;; Warning: `font-lock-beginning-of-syntax-function' is an obsolete variable (as
;; of 23.3); use `syntax-begin-function' instead.
;; Warning: `font-lock-syntactic-keywords' is an obsolete variable (as of 24.1);
;; use `syntax-propertize-function' instead.
;;
;;
;; Fixes emacs 24 bug when opening erb/js/html mixed-mode files. I
;; haven't figured out how to run this automatically; the bug occurs
;; in some code that is lazily loaded AFTER emacs has finished
;; starting up (well, after all hookable methods I could find have
;; already finished at any rate). You can run this at any time after
;; startup has finished (i.e. as soon as you have control of emacs).
;; Once you run this function you won't get those font-lock- syntax
;; errors for the rest of your emacs session.
(defun make-emacs-shutup-about-font-lock-syntactic-keywords ()
  (interactive)
  (add-to-list 'byte-compile-not-obsolete-vars
               'font-lock-beginning-of-syntax-function)
  (add-to-list 'byte-compile-not-obsolete-vars
               'font-lock-syntactic-keywords))
;; ----------------------------------------------------------------------


;; dbrady/init - server-start and make-emacs-shutup are things
;; that don't work well until after emacs has finished initializing,
;; so make an init method
(defun dbrady/init ()
  (interactive)
  (server-start)
  (make-emacs-shutup-about-font-lock-syntactic-keywords))


(provide 'daves-hacks)
