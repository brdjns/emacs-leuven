;;;; org-test-fni.el --- Extra tests for Org mode

;; Copyright (C) 2014-2015  Fabrice Niessen

;; Author: Fabrice Niessen

;; This file is not part of GNU Emacs.

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; Command:
;; emacs -Q --batch -L lisp/ -L testing/ -l ~/src/emacs-leuven/org-test-fni.el --eval '(setq org-confirm-babel-evaluate nil)' -f ert-run-tests-batch-and-exit

;;; Code:

(require 'ert)
(require 'ox)

;;; Functions for writing tests

(defun compare-org-html-export-files (org-file)
  "Compare current export of ORG-FILE with HTML file already present on disk."
  (require 'ox-html)
  (let* ((html-file (concat (file-name-directory org-file)
                            (file-name-base org-file) ".html"))
         html-contents)
    ;; should have a .html file
    (should (file-exists-p html-file))
    ;; should have the same .html exported file
    (should (equal
             ;; new export
             (with-temp-buffer
               (insert-file-contents org-file)
               (setq html-contents (org-export-as 'html))
               (delete-region (point-min) (point-max))
               (insert html-contents)
               (buffer-string))
             ;; old export
             (with-temp-buffer
               (insert-file-contents html-file)
               (buffer-string))))))

;;; Internal Tests

(ert-deftest test-org-export/export-html-backend-test-file ()
  "Compare current export of ORG-FILE with HTML file already present on disk."
  (compare-org-html-export-files "~/src/emacs-leuven/org-test-sample.org"))

;; (ert 'test-org-export/export-html-backend-test-file)

(ert-deftest test-org-export/export-html-backend-example-file ()
  "Compare current export of ORG-FILE with HTML file already present on disk."
  (compare-org-html-export-files "~/src/org-style/example.txt"))

;; (ert 'test-org-export/export-html-backend-example-file)

(ert-deftest test-org-export/export-html-backend-ERT-refcard-file ()
  "Compare current export of ORG-FILE with HTML file already present on disk."
  (compare-org-html-export-files "~/src/reference-cards/ERT-refcard.txt"))

;; (ert 'test-org-export/export-html-backend-ERT-refcard-file)

;; For inspiration:
;;
;; (ert-deftest test-ob-exp/org-babel-exp-src-blocks/w-no-headers ()
;;   "Testing export without any headlines in the Org mode file."
;;   (require 'ox-html)
;;   (let ((html-file (concat (file-name-sans-extension org-test-no-heading-file)
;; 			   ".html")))
;;     (when (file-exists-p html-file) (delete-file html-file))
;;     (org-test-in-example-file org-test-no-heading-file
;;       ;; Export the file to HTML.
;;       (org-export-to-file 'html html-file))
;;     ;; should create a .html file
;;     (should (file-exists-p html-file))
;;     ;; should not create a file with "::" appended to it's name
;;     (should-not (file-exists-p (concat org-test-no-heading-file "::")))
;;     (when (file-exists-p html-file) (delete-file html-file))))
;;
;; (ert-deftest test-ob-exp/org-babel-exp-src-blocks/w-no-file ()
;;   "Testing export from buffers which are not visiting any file."
;;   (require 'ox-html)
;;   (let ((name (generate-new-buffer-name "*Org HTML Export*")))
;;     (org-test-in-example-file nil
;;       (org-export-to-buffer 'html name nil nil nil t))
;;     ;; Should create a HTML buffer.
;;     (should (buffer-live-p (get-buffer name)))
;;     ;; Should contain the content of the buffer.
;;     (with-current-buffer (get-buffer name)
;;       (should (string-match (regexp-quote org-test-file-ob-anchor)
;; 			    (buffer-string))))
;;     (when (get-buffer name) (kill-buffer name))))

(provide 'org-test-fni)

;;; org-test-fni.el ends here
