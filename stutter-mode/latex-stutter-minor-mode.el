(defvar latex-stutter-mode-map "Keymap for latex-stutter-mode minor map")

(setq latex-stutter-mode-map (make-sparse-keymap))

(defvar latex-last-input-argument "The last keyboard input, used for comparing the
last two input strokes in electric-stutter-mode")

;; (defconst latex-stutter-mode-keybinding-cons-list
;;   ("," . 'latex-stutter-electric-comma))
  ;; (";" . 'latex-stutter-electric-semicolon)
  ;; ("." . 'latex-stutter-electric-dot)
  ;; ("]" . 'latex-stutter-electric-right-bracket)
  ;; ("[" . 'latex-stutter-electric-left-bracket)
  ;; ("/" . 'latex-stutter-electric-forward-slash))

(defun latex-stutter-electric-comma (count) "`,,' --> ` \( \) '"
       (interactive "p")
       (if (and latex-stutter-mode (= count 1))
           (cond ((= (preceding-char) last-input-event)
                  (progn (delete-char -1)
                         (unless (eq (preceding-char) ? ) (insert " "))
                         (insert "\\(\\)")
                         (backward-char 2)))
                 (t (insert-char ?\, 1)))
         (self-insert-command count)))

;; TODO - Make the environment swallow marked text
(defun latex-stutter-electric-begin-environment-align (count) "`;;' --> ` begin...'"
  (interactive "p")
  (if (and latex-stutter-mode (= count 1))
      (if (= (preceding-char) last-input-event)
          (progn
            (delete-char -1)
           (yas-expand-snippet (yas-lookup-snippet "begin-align" 'latex-mode)))
        (self-insert-command count))
    (message "Not enabled")))

;; (defun latex-stutter-electric-seperate-incoming-dot (count)
;;   (interactive "p")
;;   (if (and latex-stutter-mode (= count 1))))

;; TODO clean this mess!
;; FIXME - Pretty way to seperate different characters into
;; so that we can seperate e.g. ',.' from '..'
(defun latex-stutter-electric-begin-star-section (count) "`,.' --> ` begin sec...'"
       (interactive "p")
       (if (and latex-stutter-mode (= count 1))
           (progn
             (message "pre-char: %d" (preceding-char))
             (message "last-input: %d" last-input-event)
             (if (and (char-equal (preceding-char) 44) (char-equal last-input-event 46) )
                 (progn
                   (if (char-equal (read-event "sub?") 106) ;; j
                       (progn
                         (delete-char -1)
                         (insert "\\section*{}")
                         (backward-char))
                     (progn
                       (delete-char -1)
                       (insert "\\subsection*{}")
                       (backward-char))))
               (self-insert-command count)))
         (message "Not enabled")))

(defun test-pre-command-hook ()
  (interactive)
  (message "pre-command"))

(defvar previous-char-entries nil "A list holding n of the previous chars entered")

(defvar latex-stutter-character-expansion-tree nil
  "A tree that holds the expansion structure for stutter mode")

(defvar max-lookbehind-depht 10
  "The depth of which to look for stutters")


;; TODO - Really need better function names
(defun latex-stutter-electric-expand ()
  "Electrifies fast expansion of certain keysequences in LaTeX-mode
,, -> \(\)
;; -> begin/end align*
,. -> (sub)section)"
  (interactive)
  (if (and
          evil-insert-state-minor-mode
          (string= major-mode "latex-mode"))
    (save-excursion
      (do ((cnt 0 (1+ cnt)))
          ((or (> cnt max-lookbehind-depht) (char-equal (preceding-char) 32)))
        (progn
          (message "%d" (preceding-char))
          (backward-char)
          ))
    )))

(add-hook 'post-command-hook 'latex-stutter-electric-expand)

(define-minor-mode latex-stutter-mode
  "A minor mode to simplify writing certain environments in
LAteX"
  :lighter "LaTeX stutter"
  :require 'latex-mode
  :version "0.1"
  :keymap latex-stutter-mode-map
  (define-key latex-stutter-mode-map "," 'latex-stutter-electric-comma)
  (define-key latex-stutter-mode-map ";" 'latex-stutter-electric-begin-environment-align)
  (define-key latex-stutter-mode-map "." 'latex-stutter-electric-begin-star-section))

(provide 'latex-stutter-minor-mode)
