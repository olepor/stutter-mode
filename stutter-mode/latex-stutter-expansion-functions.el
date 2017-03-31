
;; expands and sets point inside inline math-mode
(defun latex-stutter-expand-inline-math-mode ()
  (interactive)
  (insert "\\\(\\\)")
  (backward-char 4)
  (delete-char -2)
  (forward-char 2))
