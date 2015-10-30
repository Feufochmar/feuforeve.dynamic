(define-module (configuration)
  #:export (static-files-server generated-islands-path
           )
)

(define (static-files-server) "http://static.feuforeve.fr")
;(define (static-files-server) "http://localhost:8081")
(define (generated-islands-path) "../feuforeve.static/islands/")
