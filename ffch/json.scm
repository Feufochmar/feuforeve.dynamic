;; Transform a s-expr into a JSON string
(define-module (ffch json)
  #:version (0 0 1)
  #:use-module (oop goops)
  #:use-module (ice-9 regex)
  #:export (json)
)

;; json-escape transforms basic datatypes into json
(define-method (json (data <string>))
  (let* ((pass-1 (regexp-substitute/global #f "\\\\" data 'pre "\\\\" 'post))
         (pass-2 (regexp-substitute/global #f "\"" pass-1 'pre "\\\"" 'post)))
    (string-append "\"" pass-2 "\"")))

(define-method (json (data <number>))
  (number->string data))

(define-method (json (data <boolean>))
  (if data
      "true"
      "false"))

(define-method (json (data <symbol>))
  (json (symbol->string data)))

(define-method (json (data <keyword>))
  (json (keyword->symbol data)))

(define-method (json (data <vector>))
  (string-append "[" (string-join (map json (vector->list data)) ",") "]"))

(define-method (json (data <list>))
  (cond
    ((and (not (null? data)) (list? (car data)))
     (string-append "{" (string-join (map json data) ",") "}"))
    ((eq? 2 (length data))
     (string-append (json (car data)) ":" (json (cadr data))))
    (#t (error "Invalid list for json translation: " data))))
