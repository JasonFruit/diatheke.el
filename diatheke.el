;;; diatheke.el --- A minor mode using the diatheke command-line Bible tool

;; Copyright: (C) 2011-2012 Jason R. Fruit
;; URL: https://github.com/JasonFruit/diatheke.el
;; Version: 1.0

;;
;;     This program is free software; you can redistribute it and/or
;;     modify it under the terms of the GNU General Public License as
;;     published by the Free Software Foundation; either version 2 of
;;     the License, or (at your option) any later version.
;;     
;;     This program is distributed in the hope that it will be useful,
;;     but WITHOUT ANY WARRANTY; without even the implied warranty of
;;     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
;;     GNU General Public License for more details.
;;     
;;     You should have received a copy of the GNU General Public License
;;     along with GNU Emacs; if not, write to the Free Software
;;     Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
;;     02110-1301 USA

;;; Commentary
;;
;; To use this minor mode, you must have diatheke properly installed
;; and on your PATH; you must also have installed at least one bible
;; translation.  Diatheke can be retrieved from:
;; http://www.crosswire.org/wiki/Frontends:Diatheke
;;
;; To install diatheke.el, save this file somewhere in your Emacs load
;; path and put the following in your .emacs:
;;
;;   (require 'diatheke)
;;
;; To toggle diatheke-mode, which is initially off, do:
;;
;;   M-x diatheke-mode
;;
;; Once diatheke-mode is active, the following default keybindings
;; will be created:
;;
;;   C-c C-b: select a bible translation
;;   C-c C-i: insert a passage
;;   C-c C-p: search for a phrase
;;   C-c C-m: search for multiple words
;;   C-c C-r: search by regex

(defun diatheke-extract-bibles (lst)
  "Extract a list of installed bible modules from diatheke output."
  (if (not lst) '()
    (let ((first-parts (split-string (car lst) " : ")))
      (if (= (length first-parts) 2)
	  (cons (car first-parts) (diatheke-extract-bibles (cdr lst)))
	(diatheke-extract-bibles (cdr lst))))))

(defun diatheke-get-bible-list ()
  "Return a list of installed bible modules."
  (with-temp-message "Retrieving bible list . . . "
    (let ((lines (split-string
		  (shell-command-to-string
		   "diatheke -b system -k modulelist")
		  "\n")))
      (diatheke-extract-bibles lines))))

(defun diatheke-set-bible ()
  "Set the active bible module from an autocompletion list."
  (interactive)
  (let ((bibles (diatheke-get-bible-list)))
    (setq diatheke-bible
	  (minibuffer-with-setup-hook 'minibuffer-complete
	    (completing-read "Bible: "
			     bibles nil t)))))

(defun diatheke-insert-passage (key)
  "Insert a passage by reference into the current buffer."
  (interactive "sKey: ")
  (shell-command (concat "diatheke -b " diatheke-bible " -k " key) 1))

(defun diatheke-choose-result (results)
  "Choose a search result from an autocompletion list."
  (let ((history (split-string
		  (cadr (split-string results "-- "))
		  " ; ")))
    (minibuffer-with-setup-hook 'minibuffer-complete
      (completing-read "Passage: "
		       history nil t))))

(defun diatheke-search (key type)
  "Do a search of the specified type for the key."
  (let ((results
	 (with-temp-message "Retrieving search results . . ."
	   (shell-command-to-string
	    (concat "diatheke -s " type " -b " diatheke-bible " -k " key)))))
    (diatheke-insert-passage (diatheke-choose-result results))))

(defun diatheke-multiword-search (key)
  "Do a multiword search."
  (interactive "sSearch terms: ")
  (diatheke-search key "multiword"))

(defun diatheke-phrase-search (key)
  "Do a phrase search."
  (interactive "sSearch terms: ")
  (diatheke-search key "phrase"))

(defun diatheke-regex-search (key)
  "Do a search by regular expression."
  (interactive "sSearch terms: ")
  (diatheke-search key "regex"))

(provide 'diatheke)

(define-minor-mode diatheke-mode
  "Toggle diatheke-mode.

     With no argument, this command toggles the mode.  Non-null
     prefix argument turns on the mode.  Null prefix argument
     turns off the mode.
     
     When diatheke-mode is enabled, several keybindings are made
     to insert bible passages by several kinds of search and by
     reference.

     Also, the variable diatheke-bible is set to the name of the
     alphabetically first diatheke module."
  
  ;; The initial value.
  :init-value nil
  ;; The indicator for the mode line.
  :lighter " diatheke"
  ;; The minor mode bindings.
  :keymap
  '(("\C-\c\C-b" . diatheke-set-bible)
    ("\C-\c\C-i" . diatheke-insert-passage)
    ("\C-\c\C-m" . diatheke-multiword-search)
    ("\C-\c\C-p" . diatheke-phrase-search)
    ("\C-\c\C-r" . diatheke-regex-search))
  (setq diatheke-bible (car (diatheke-get-bible-list))))
;;; diatheke.el ends here
