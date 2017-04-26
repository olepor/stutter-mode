;; Requires YaSnippet

;; expands and sets point inside inline math-mode
(defun latex-stutter-expand-inline-math-mode ()
  (interactive)
  (insert "\\\(\\\)")
  (backward-char 4)
  (delete-char -2)
  (forward-char 2))

(defun latex-stutter-expand-math-mode ()
  (interactive)
  (delete-char -2)
  (insert "\\\[")
  (newline 2)
  (insert "\\]")
  (previous-line))

(defun latex-stutter-expand-section-sub-section ()
  (interactive)
  (delete-char -2)
  (if (not (char-equal (read-event "sub?") 106)) ;; 106 = ascii j
      (progn
        (insert "\\section*{}")
        (backward-char))
    (progn
      (insert "\\subsection*{}")
      (backward-char))))

(defun latex-stutter-expand-begin-align ()
  (interactive)
  (delete-char -2)
  (yas-expand-snippet (yas-lookup-snippet "begin-align" 'latex-mode)))


