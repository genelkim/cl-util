
(in-package :util)

;; Reads a file line by line and return a list of strings.
(defun read-file-lines (filename)
  (labels
    ((helper
       (in acc)
       (multiple-value-bind
         (line end?)
         (read-line in nil)
         (if end?
           (cons line acc)
           (helper in (cons line acc))))))
    (reverse (remove-if #'null (helper (open filename) '())))))

;; Reads a file line by line and return a list of strings.
;; Done in a loop so you won't get a stack overflow even with bad compiler
;; parameters.
(defun read-file-lines2 (filename)
  (let ((fh (open filename))
        (done nil)
        acc)
    (loop while (not done)
          do (multiple-value-bind (line end?) (read-line fh nil)
               (setq done end?)
               (setq acc (cons line acc))))
    (reverse acc)))


;; Reads all s-expressions from a character stream until exhausted.
;; It will raise an error if the stream does not represent a sequence of
;; s-expresssions.
(defun read-all-from-stream (s)
  (labels
    ((helper
       (in acc)
       (let ((e (read in nil)))
         (if (null e)
           acc
           (helper in (cons e acc))))))
    (reverse (helper s nil))))

;; Reads all s-expressions from the given file until exhausted.
;; It will raise an error if the file does not contain a string representing
;; a sequence of s-expresssions.
(defun read-all-from-file (filename)
  (with-open-file (s filename)
    (read-all-from-stream s)))

;; TODO: move this to string-ops.lisp or maybe stream.lisp once this directory
;; is packaged and internal dependencies are better managed.
;; Reads all s-expressions from the given string.  Raises an error if the
;; string does not represent a series of valid s-expressions.
;; This corresponds to 'read-file-objects' in file-io.lisp, but for strings.
(defun read-all-from-string (str)
  (with-input-from-string (s str)
    (read-all-from-stream s)))

;; Writes a string to a file.
(defun write-to-file (str filename)
  (with-open-file (file :direction :output)
    (format fh str)))

;; Writes a list to a file.
;; Depends on write-to-file.
(defun write-list-to-file (lst filename &optional (sep "~%"))
  (write-to-file (list-to-string lst sep) filename))

;; Similar to "println" in Java. The name princln is meant to reflect the CL
;; naming conventions for prints.
(defun princln (x)
  (princ x)
  (format t "~%"))

