

(defmacro expme (mlist)
  (dotimes (i (length mlist))
    `(cons ,i ,i)))


(macroexpand '(expme (list 1 2)))
