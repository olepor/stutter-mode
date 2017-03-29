
(defvar stutter-tree-head nil
  "Head of the stutter tree")

(defvar stutter-tree-pointer nil
  "points to the last entered item of a sequence, or at the root of the tree")

(defvar latex-stutter-character-expansion-tree nil
  "A tree to hold the stutter items")

;; Needed, as minsert does not handle inserts into empty lists
(setq latex-stutter-character-expansion-tree (list (cons 1 #'test-print)))

(defun latex-stutter-electric-expand ()
  (interactive)
  (when evil-insert-state-minor-mode
    (let ((prev-char (preceding-char)))
      (message "working")
      (message "%d" prev-char)
      (update-stutter-pointer prev-char))))

(add-hook 'post-command-hook 'latex-stutter-electric-expand)

(remove-hook 'post-command-hook 'latex-stutter-electric-expand)

(defun create-mlists (tlists)
  (let* (
         (mlists (list (cons (car tlists) nil)))
         (temp-list-pointer (car mlists)))
    (setq tlists (cdr tlists))
    (dotimes (i (1- (length tlists)))
      (message "Hmm")
      (message "%d" (car temp-list-pointer))
      (setcdr temp-list-pointer (list (cons (car tlists) nil)))
      (message "%d" (caadr temp-list-pointer))
      (setq temp-list-pointer (cadr temp-list-pointer))
      (message "well")
      (message "%d" (car temp-list-pointer))
      (setq tlists (cdr tlists)))
    (progn
      (setcdr temp-list-pointer (car tlists))
      mlists)))

(defun minsert (element mlist)
  (cond
   ((consp (car mlist))
    (progn
      (message "The car of mlist is a cons cell")
      ;; Check id's towards element id
      (if (= (car element) (caar mlist))
          (progn
            (message "inserting with a matching id")
            (minsert (cdr element) (car mlist)))
        (if (cdr mlist)
            ;; mlist has a cdr
            (minsert element (cdr mlist))
         (setcdr mlist (create-mlists element))))))
   ((integerp (car mlist))
    (progn
      (message "The car of mlist is an integer")
      ;; the element is either a function, or a cons-cell list
      ;; the id's cdr is either a function or an mlist
      (if (functionp (car element))
          (progn
            (message "functionp element")
           (setcdr mlist (car element))
           )
        (if (functionp (cdr mlist))
            ;; (progn
            ;;   (message "adding cdr to list")
            ;;   (setcdr mlist element))
            (progn
              (message "well")
             (if (> (length element) 1)
                 (setcdr mlist (create-mlists element))
               (setcdr mlist (list element)))
             )
          ;; the element cdr is an mlist and so is the cdr of id
          ;; Thus insert it into the mlist
          (minsert element (cdr mlist))))))
   (t "message The car is neither cons nor integer - error!")))

(defun update-stutter-pointer (arg)
  (interactive)
  ;; if arg in mlist or arg equals id?
  ;; #1 find the id-cons-cell in the mlist
  (if (consp (car stutter-tree-pointer))
      (if (= arg (caar stutter-tree-pointer))
          (if (functionp (cdar stutter-tree-pointer))
              (progn
                (funcall (cdar stutter-tree-pointer))
                (setq stutter-tree-pointer latex-stutter-character-expansion-tree))
            (setq stutter-tree-pointer (cdar stutter-tree-pointer)))
        (progn
          (setq stutter-tree-pointer (cdr stutter-tree-pointer))
          (update-stutter-pointer arg)))
    ;; Might not be necessary. we will always be working with mlists
    (setq stutter-tree-pointer latex-stutter-character-expansion-tree)))

(defun create-stutter (stutter function)
  (let (stutter-list)
    (dotimes (i (length stutter))
      (add-to-list 'stutter-list (string-to-char (substring stutter i (1+ i))) t))
    (progn
      (setcdr (last stutter-list) (cons function nil))
      stutter-list)))
