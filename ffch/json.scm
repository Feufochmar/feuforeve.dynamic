;; Transform a s-expr into a JSON string
(define-module (ffch json)
  #:version (0 0 1)
  #:use-module (oop goops)
  #:use-module (ice-9 regex)
  #:export (json)
)

;; json-escape transforms basic datatypes into json
(define-method (json-escape (data <string>))
  (let* ((pass-1 (regexp-substitute/global #f "\\\\" data 'pre "\\\\" 'post))
         (pass-2 (regexp-substitute/global #f "\"" pass-1 'pre "\\\"" 'post)))
    (string-append "\"" pass-2 "\"")))

(define-method (json-escape (data <number>))
  (number->string data))

(define-method (json-escape (data <boolean>))
  (if data
      "true"
      "false"))

(define-method (json-escape (data <symbol>))
  (json-escape (symbol->string data)))

(define-method (json-escape (data <keyword>))
  (json-escape (keyword->symbol data)))

;; json is the main macro to transform objects expressions into json strings
(define-syntax json
  (syntax-rules ()
    ((_) "")
    ((_ #(val ...))
     (string-append "[" (string-join (list (json val) ...) ",") "]"))
    ((_ key val)
     (string-append (json-escape key) ":" (json val)))
    ((_ ((key val) ...))
     (string-append "{" (string-join (list (json key val) ...) ",") "}"))
    ((_ val) (json-escape val))
  ))
