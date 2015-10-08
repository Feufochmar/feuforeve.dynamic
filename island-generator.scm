(define-module (island-generator)
  #:use-module (island-generator island-generator)
  #:use-module (island-generator island-renderer)
  #:use-module ((srfi srfi-19) #:renamer (symbol-prefix-proc 'time:))
  #:duplicates (merge-generics)
  #:export (main)
)

;; To avoid using the C locale in guile-2.0
(setlocale LC_ALL "")

;; Initialize the random number generator
(set! *random-state* (random-state-from-platform))
(set-port-encoding! (current-output-port) "UTF-8")

(define (main args)
  (let* ((image-width 900)
         (image-height 800)
         (tile-size 6)
         (tomorrow-time (time:add-duration (time:current-time)
                                           (time:make-time time:time-duration 0 (* 24 60 60))))
         (tomorrow-date (time:time-utc->date tomorrow-time))
         (output-dir (if (and (not (null? args)) (not (null? (cdr args)))) (cadr args) "."))
         (island-file-name (string-append output-dir "/island-" (time:date->string tomorrow-date "~Y-~m-~d") ".svg"))
         (island (generate-island image-width image-height tile-size))
         (island-file (open-file island-file-name "w"))
       )
    (render-island
      island
      island-file)
    (close island-file)))
