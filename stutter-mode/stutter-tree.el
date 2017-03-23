
(defvar stutter-tree-head nil
  "Head of the stutter tree")

(defvar tree-stutter-items-list nil
  "A tree to hold the stutter items")

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


mlist

(cdadr mlist)

(append (cons 2 #'test-print) mlist)

(cdr mlist)


(minsert (cons 1 (cons 2 #'test-print)) mlist)

(setq mlist (list (cons 1  #'test-print)))

(setq in-list (cons 1 (list (cons 2 #'test-print))))

(m-insert in-list mlist)

(m-insert (cons 2 #'test-print) mlist)

(m-insert (cons 3 #'test-print) mlist)

(m-insert (cons 1 #'test-print) mlist)


(m-insert (cons 1 (cons 2 #'test-print)) mlist)

(m-insert (cons 3 (cons 2 'message-test)) mlist)
