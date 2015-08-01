;; Webcontents
(define-module (ffch weblets)
  #:version (0 0 1)
  #:use-module (oop goops)
  #:use-module (web server)
  #:use-module (web request)
  #:use-module (web response)
  #:use-module (web http)
  #:use-module (web uri)
  #:export (weblet webcontainer
            add-weblet run-webcontainer
           )
)

;; Weblet : web page handling
(define-class <weblet> (<object>)
  (content-type #:getter content-type #:init-keyword #:content-type #:init-form #f)
  (output-writer #:getter output-writer #:init-keyword #:output-writer #:init-from (lambda (path query port) port))
  (error-code #:getter error-code #:init-keyword #:error-code #:init-form 200)
  (location #:getter location #:init-keyword #:location #:init-form #f)
)

;; Web container : the webserver
(define-class <webcontainer> (<object>)
  (server-port #:getter server-port #:init-keyword #:server-port #:init-form 8080)
  (weblets #:getter weblets #:init-form (make-hash-table))) ;; map of string -> weblet

;;;;
;; Weblet methods

;; Constructor
(define-syntax weblet
  (syntax-rules ()
   ((_ ((slot value) ...) ((params* ...) cmd cmd* ...))
    (let ((wlet (make <weblet> #:output-writer (lambda (params* ...) cmd cmd* ...))))
      (begin
        (weblet-slot-set! wlet (quote slot) value) ...
      )
      wlet
    ))))

;; Slot set
(define-method (weblet-slot-set! (wlet <weblet>) (slot <symbol>) value)
  (cond
    ((eq? slot 'error-code) (slot-set! wlet 'error-code value))
    ((eq? slot 'content-type) (slot-set! wlet 'content-type (parse-header 'content-type value)))
    ((eq? slot 'location) (slot-set! wlet 'location (parse-header 'location value)))
    (#t (error "Unkown weblet slot: " slot))))

;; Build the header of a weblet
(define-method (build-headers (wlet <weblet>))
  (let ((headers (list)))
    (if (content-type wlet)
        (set! headers (cons (cons 'content-type (content-type wlet)) headers)))
    (if (location wlet)
        (set! headers (cons (cons 'location (location wlet)) headers)))
    headers))

;;;;
;; Webcontainer methods

;; Constructor
(define-method (webcontainer (port <integer>))
  (make <webcontainer> #:server-port port))

;; Add weblet to webcontainer
(define-method (add-weblet (wcontainer <webcontainer>) (page <string>) (wlet <weblet>))
  (hash-set! (weblets wcontainer) page wlet))

;; Helper for transforming the query into a map
(define (split-and-decode-uri-query query)
  (if query
      (let ((items (map (lambda (item) (string-split item #\=)) (string-split query #\&)))
            (h (make-hash-table))
           )
        (map
          (lambda (elem)
            (if (and (not (null? elem)) (not (null? (cdr elem))))
                (hash-set! h (uri-decode (car elem)) (uri-decode (cadr elem)))))
          items)
        h)
      (make-hash-table)
  ))

;; Run a container
(define-method (run-webcontainer (wcontainer <webcontainer>))
  (let ((handler
          (lambda (request request-body)
            (let* ((uri (request-uri request))
                   (path (split-and-decode-uri-path (uri-path uri)))
                   (query (split-and-decode-uri-query (uri-query uri)))
                   (page (if (null? path) "" (car path)))
                   (wlet (hash-ref (weblets wcontainer) page))
                   (wlet404 (hash-ref (weblets wcontainer) "404"))
                   (real-wlet (if wlet wlet wlet404))
                  )
              (if real-wlet
                  (values
                    (build-response #:code (error-code real-wlet)
                                    #:headers (build-headers real-wlet))
                    (lambda (port)
                      (set-port-encoding! port "UTF-8")
                      ((output-writer real-wlet) path query port)
                      (newline port)))
                  (values
                    (build-response #:code 404
                                    #:headers '((content-type . (text/plain (charset . "UTF-8")))))
                    (lambda (port)
                      (set-port-encoding! port "UTF-8")
                      (display "Nothing found here. Try elsewhere." port)
                      (newline port)))
              )
            ))))
    (run-server handler 'http `(#:port ,(server-port wcontainer)))
  ))
