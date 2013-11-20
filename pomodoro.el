;; Kudos to Eric Davis for these macros.
;; Yanked from http://theadmin.org/articles/pomodoro-emacs-with-orgmode/
;; Emacs macro to add a pomodoro table
;;

;; M-x pomodoro will create a new pomodoro table
;; 1st column is a category column
;; 2nd column is task name
;; 3rd column is pomodoro list
;; | G | Organization | [ ] |
;; |   |              |     |

;; This crap blows up Emacs 24.3.1 HARD. Sorry, Eric, looks like I'm writing my own pom mode :-(
;; (fset 'pomodoro-table
;;       [?| ?  ?G ?  ?| ?  ?O ?r ?g ?a ?n ?i ?z ?a ?t ?i ?o ?n ?  ?| ?  ?\[ ?  ?\] ?  ?| tab])

;; Emacs macro to add a pomodoro item
;; E.g. C-u 5 pomodoro will add a [ ] [ ] [ ] [ ] [ ] pom
;; (fset 'pomodoro
;;       "[ ]")

;; Todo: Write something like how C-c C-c changes [ ] -> [X], only that crosses off the next available pom
;; (defun mark-pomodoro-finished ()
;;   (interactive)
;;   (save-excursion
;;     (select-current-line)
;;     (replace-in-selection "[ ]" "[X]")))
;; TODO: add some equivalent of (if (all-poms-complete-p) (mark-task-done))


;; THE PLAN!!!

;; Start with org-tbl-mode because yeah, it actually makes sense.
;; --
;; General Notes:
;;
;; - Use (insert "...") instead of fset 'macro [...]
;;
;; - Read the Clojure book before starting this. I'm sketching in
;;   notes right now that are VERY procedural-looking and I would like
;;   them to be composable and functional.
;;
;; - I don't like spaces between my pom brackets, but others might. I
;;   prefer empty-bottomed brackets, but other may prefex
;;   underscores. Allow for these with settings, so add-pom now would
;;   look like (insert (concat (pom-bracket) (interpom-space)))
;;
;; - I want column 1 to be category, 2 to be name and 3 to be the
;;   brackets. Consider making a setting for this, and/or a
;;   template. The tick and complete code will need to know how to
;;   find the bracket column and task name column respectively. The
;;   pomodoro-table method must know how many columns to start with
;;   and what to initialize them with.
;;
;; - C-c C-p is taken in org-mode, and C-c p has child actions but I
;;   can't find them with C-h m. HOWEVER: x is available/unassigned as
;;   a child of C-x p, as are -, [ and (. These could be bound to
;;   tick-pom, complete-task, insert-pomodoro-estimate and
;;   insert-pomodoro-reestimate. Complete task could also be bound to
;;   c (complete), d (done) or + (strikeout), whichever makes the most
;;   sense. I kind of like - for strikeout. To be honest I would love
;;   it if C-c C-c worked here; this is a MASSIVELY overloaded defun
;;   so I would only approach with great caution. OTOH, it looks like
;;   C-c p C-c is open (now I'm wondering what IS taken under C-c p?)
;;
;; <PREFIX> will probably be C-c p
;;
(defun narrow-to-line ()
  (interactive)
  (beginning-of-line)
  (let ((beg (point)))
    (end-of-line)
    (narrow-to-region beg (point))))

;; pomodoro-table - Creates same default table as Eric Davis, but
;; without the crashiness.
(defun pomodoro-table ()
  (interactive)
  (insert "| M | Plan Pomodoros   | [ ] |")
  (org-table-align)
  (insert "\nS)hiny O)SS M)isc L)earning"))


;;
;; add-task - ??? - Add a new table line, add 1 or the C-u prefix
;; number of poms, realign the table and move point to the task name
;; column. This might work better as a snippet.
;;
;; add-pom - <PREFIX> [ - (insert "[ ]") and realign table. Optional
;; later optimization: If prefixed with a count, insert that many
;; times but only realign table once.
(defun add-pom ()
  (interactive)
  (insert "[ ]")
  (org-table-align))

;;
;; remove-pom - remove last [ ] or ( ) and realign table. Optional
;; later optimization: If prefixed with a count, insert that many
;; times but only realign table once.
;;
;; add-reestimated-pom - <PREFIX> ( - (insert "( )") and realign
;; table. Prefactoring: identical to add-pom in all ways except "( )"
;; instead of "[ ]"
(defun add-reestimated-pom ()
  (interactive)
  (insert "( )")
  (org-table-align))

;;
;; tick-pom - <PREFIX> x - Find first [ ] or ( ) in bracket column and
;; change it to [X] or (X), respectively. Optional: After ticking pom,
;; if no [ ] or ( )'s remain, ask user if pom is complete
;; (Y/n/r/?). If Y, say "Great!"  and call complete-task. If n,
;; return. If r, ask user to input number of reestimated poms to add,
;; then call add-reestimated-pom. If ? explain what Y/n/r mean and ask
;; again.
(defun tick-pom ()
  (interactive)
  (save-excursion
    (beginning-of-line)
    (search-forward "|")
    (search-forward "|")
    (search-forward "|")
    (search-forward "[ ]")
    (search-backward "[")
    (forward-char)
    (delete-char 1)
    (insert "X")))

;;
;; Allow an autocomplete setting with values of always, never, ask.
;;
;; complete-task - <PREFIX> <HYPHEN> - Select all text in second
;; column, wrap it in +'s, and realign the table.
(defun mark-task-complete ()
  (interactive)
  (save-excursion
    (beginning-of-line)
    (search-forward "|")
    (search-forward "|")
    (forward-char)
    (insert "+")
    (search-forward "|")
    (backward-word)
    (forward-word)
    (insert "+")
    (org-table-align)))

;;
;; uncomplete-task - <PREFIX> S-<HYPHEN> - Select all text in second
;; column and strip off +'s at ends, then realign the table.
;;
;; complete-task-dwim - <PREFIX> <HYPHEN> - Optional upgrade to
;; complete task, replaces its keybinding. Detects whether the current
;; task is complete, and if so marks it
