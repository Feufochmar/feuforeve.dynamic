;; Loading every file of a directory
(define-module (ffch load-all)
  #:version (0 0 1)
  #:use-module (oop goops)
  #:export (load-all load-all-from-path)
)

; Helping function
(define-method (on-every-file (directory <string>) fun)
  (map
    (lambda (file)
      (fun (string-append directory "/" file)))
    (scandir directory (lambda (x) (string-suffix? ".scm" x)))))

;;;;
;; Load every scm file from a directory
(define-method (load-all (directory <string>))
  (on-every-file directory load))

;;;;
;; Load from a directory, relative to the guile load path
(define-method (load-all-from-path (directory <string>))
  (on-every-file directory load-from-path))
