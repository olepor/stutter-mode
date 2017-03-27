(load-file "stutter-tree.el")

(defvar latex-stutter-mode-map "Keymap for latex-stutter-mode minor map")

(setq latex-stutter-mode-map (make-sparse-keymap))

(defvar latex-stutter-character-expansion-tree nil
  "A tree that holds the expansion structure for stutter mode")

(defun test-pre-command-hook ()
  (interactive)
  (message "pre-command"))

(remove-hook 'post-command-hook 'latex-stutter-electric-expand)

(defun create-stutter (stutter)
  (let (stutter-list)
    (dotimes (i (length stutter))
      (add-to-list 'stutter-list (string-to-char (substring stutter i (1+ i))) t))
    stutter-list))

(create-stutter "abcd")

(define-minor-mode latex-stutter-mode
  "A minor mode to simplify writing certain environments in
LAteX"
  :lighter "LaTeX stutter"
  :require 'latex-mode
  :version "0.1"
  ;; As every insert is simply a command, binding to post-command-hook
  ;;does the trick
  (add-hook 'post-command-hook 'latex-stutter-electric-expand))

(provide 'latex-stutter-minor-mode)
