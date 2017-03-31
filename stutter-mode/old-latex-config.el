(require 'latex-stutter-minor-mode)
;; Requires evil and spacemacs (How to handle this?)

;; j = 106_(ascii)
(defvar ls-subsection-trigger 106 "The key that triggers a subsection, keys are read as ascii values")

;; Simple method for inserting a section or subsection depending on keypress
(defun latex-snippet-sub-s ()
  (interactive)
  (if (char-equal (read-key "sub?") ls-subsection-trigger)
      (progn (insert "\\section*{}") (backward-char))
  (progn (insert "\\subsection*{}") (backward-char))))

(spacemacs|define-transient-state latex-snippet-insert
  :title "LaTeX snippet insert state"
  :doc "\n [_s_]"
  :bindings
  ("0" spacemacs//transient-state-0)
  ("s" latex-snippet-sub-s))

;; Changes TeX-command-master to yas-insert-snippet, far more useful
(spacemacs/set-leader-keys-for-major-mode 'latex-mode "," 'yas-insert-snippet)
(spacemacs/set-leader-keys-for-major-mode 'latex-mode "C-8" 'spacemacs/latex-snippet-insert-transient-state/body)


(defun latex-config-hook-functions ()
  (progn
    (setq-default evil-surround-pairs-alist (cons '(?\\ . ("\\\(" . "\\\)")) evil-surround-pairs-alist))
    (latex-stutter-mode)
    (message "Latex stutter mode enabled")))

;; Add stutter-mode and \( \) to latex mode for increased math pleasure
;; add a hook to latex, to push \ as a marker for \( \) to evil surround
(add-hook 'LaTeX-mode-hook 'latex-config-hook-functions)

;; Yasnippet cheats

(defvar lc-yas-snippet-dir "~/.snippets/latex-mode/"
  "The directory where I keep my latex snippets")

(defun lc-insert-newcommand-from-selection (first-point last-point)
  (interactive "r")
  (kill-ring-save first-point last-point)
  (search-backward-regexp "newcommand-marker" nil t) ;; Match marker, noerror
  (evil-insert-newline-below)
  (let* ((snipp (yas-lookup-snippet "newcommand" 'latex-mode t))
         (name (read-string "name: "))
         (string-format "# -*- mode: snippet -*-\n#name : %s\n#key : %s\n#contributor : %s\n# --\n")
         (vector (replace-regexp-in-string "\n\\'" "" (evil-vector-to-string (current-kill 0 t))))
         (final-snippet (replace-regexp-in-string "name" name (replace-regexp-in-string "$0" vector snipp nil t))))
    ;; (message snipp)
    (message "vector")
    (message vector)
    ;; (replace-regexp-in-string "$0" vector snipp nil t)
    (message "Final snippet")
    (message final-snippet)
    (message (yas-lookup-snippet "newcommand" 'latex-mode t))
    ;; (yas-expand-snippet (yas-lookup-snippet "newcommand" 'latex-mode t))
    (yas-expand-snippet final-snippet)
    (with-temp-file (concat lc-yas-snippet-dir (concat name ".yasnippet"))
      (insert (format string-format name name user-full-name) vector))
    ;; (yas-expand-snippet snipp)
    (yas-reload-all)
    ;; (yas-load-directory lc-yas-snippet-dir)
    ))

(spacemacs/set-leader-keys-for-major-mode 'latex-mode "n" 'lc-insert-newcommand-from-selection)
