

(defmacro expme (mlist)
  (dotimes (i (length mlist))
    `(cons ,i ,i)))


(macroexpand '(expme (list 1 2)))

(defun update-stutter-pointer (arg)
  (interactive)
  ;; if arg in mlist or arg equals id?
  ;; #1 find the id-cons-cell in the mlist
  (if (consp (car stutter-tree-pointer))
      (if (= arg (caar stutter-tree-pointer))
          (if (functionp (cdar stutter-tree-pointer))
              (progn
                (funcall (cdar stutter-tree-pointer))
                (setq stutter-tree-pointer  mlist))
            (setq stutter-tree-pointer (cdar stutter-tree-pointer)))
        (progn
          (setq stutter-tree-pointer (cdr stutter-tree-pointer))
          (update-stutter-pointer arg)))
    ;; Might not be necessary. we will always be working with mlists
    (setq stutter-tree-pointer  mlist)))

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
         (setcdr mlist (list element))))))
   ((integerp (car mlist))
    (progn
      (message "The car of mlist is an integer")
      ;; the element is either a function, or a cons-cell list
      ;; the id's cdr is either a function or an mlist
      (if (functionp element)
          (setcdr mlist element)
        (if (functionp (cdr mlist))
            (setcdr mlist (list element))
          ;; the element cdr is an mlist and so is the cdr of id
          ;; Thus insert it into the mlist
          (minsert element (cdr mlist))))))
   (t "message The car is neither cons nor integer - error!")))

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

(create-mlists (list 1 2 3 #'test-print))

(update-stutter-pointer 2)

(setq stutter-tree-pointer tlist)

(setq tlist (list (cons 1 #'test-print)))

tlist

stutter-tree-pointer

(minsert (cons 2 (cons 3 #'test-print)))

(minsert (cons 2 (cons 2 #'test-print)) tlist)

(minsert (cons 1 (cons 2 (cons 3 #'test-print))) tlist)
