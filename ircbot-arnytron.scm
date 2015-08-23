(define-module (ircbot-arnytron)
  #:use-module (ffch ircbot)
  #:use-module (arnytron arnytron)
  #:export (main)
  #:duplicates (merge-generics)
)

;; To avoid using the C locale in guile-2.0
(setlocale LC_ALL "")

;; Initialize the random number generator
(set! *random-state* (random-state-from-platform))
(set-port-encoding! (current-output-port) "UTF-8")

(define (parse-args args)
  (letrec ((helper
             (lambda (lst h)
               (cond
                 ((null? lst) h)
                 ((and (string=? (car lst) "--server") (not (null? (cdr lst))))
                  (begin
                    (hash-set! h #:server (cadr lst))
                    (helper (cddr lst) h)))
                 ((and (string=? (car lst) "--port") (not (null? (cdr lst))))
                  (begin
                    (hash-set! h #:port (cadr lst))
                    (helper (cddr lst) h)))
                 ((and (string=? (car lst) "--channels") (not (null? (cdr lst))))
                  (begin
                    (hash-set! h #:channels (string-split (cadr lst) #\:))
                    (helper (cddr lst) h)))
                 ((and (string=? (car lst) "--nick") (not (null? (cdr lst))))
                  (begin
                    (hash-set! h #:nick (cadr lst))
                    (helper (cddr lst) h)))
                 ((and (string=? (car lst) "--command-prefix") (not (null? (cdr lst))))
                  (begin
                    (hash-set! h #:prefix (cadr lst))
                    (helper (cddr lst) h)))
                 ((and (string=? (car lst) "--help") (not (null? (cdr lst))))
                  (begin
                    (hash-set! h #:help #t)
                    (display
                      (string-append
                        "ircbot-arnytron"
                        " --server <server> [--port <port>] [--nick <nick>]"
                        " --channels <channel>[:<channel>[:...]] [--command-prefix <prefix>]\n"
                        "With:\n"
                        " <server> : the server to connect to (required)\n"
                        " <port> : the server port to connect to (optional, default: 6667)\n"
                        " <nick> : the nickname to use (optional, default: ArnYtron)\n"
                        " <channel> : a channel to join, without the beginning # (required)\n"
                        "             Several channel can be joined. The channels must be separed by colons.\n"
                        " <prefix> : the command prefix to use (optional, default: !\n"))
                    h))
                 (#t (error "Invalid arguments. See --help"))
                ))))
    (helper (cdr args) (make-hash-table))))

(define (main args)
  (let* ((hash-args (parse-args args))
         (help? (hash-ref hash-args #:help))
         (server (or help? (hash-ref hash-args #:server) (error "No server given.")))
         (port-str (or help? (hash-ref hash-args #:port) "6667"))
         (port (or help? (string->number port-str) (error "Invalid port")))
         (nick (or help? (hash-ref hash-args #:nick) "ArnYtron"))
         (channels (or help? (hash-ref hash-args #:channels) (error "No channel given.")))
         (prefix (or help? (hash-ref hash-args #:prefix) "!"))
         (ircbot
           (or help?
               (make-ircbot
                 #:nick nick
                 #:server server
                 #:port port
                 #:prefix prefix
                 #:channels (map (lambda (x) (string-append "#" x)) channels))))
         (ArnYtron3000 (or help? (arnytron)))
         )
    (if (not help?)
        (begin
          (add-command-handler!
            ircbot
            "genere"
            (lambda (ircbot channel asker args)
              (send-privmsg ircbot channel (generate-citation ArnYtron3000))))
          (add-command-alias!
            ircbot
            "genere"
            (list "genere!" "genere!!" "genere!!!" "génère" "génère!" "génère!!" "génère!!!"
                  "redige" "redige!" "redige!!" "redige!!!" "rédige" "rédige!" "rédige!!" "rédige!!!"
                  ))
          (add-command-handler!
            ircbot
            "cite"
            (lambda (ircbot channel asker args)
              (let ((arny-quote (pick-citation ArnYtron3000)))
                (send-privmsg ircbot channel
                              (string-append "\"" (citation arny-quote) "\" - ArnY, " (date arny-quote))))))
          (add-command-alias!
            ircbot
            "cite"
            (list "cite!" "cite!!" "cite!!!"))
          (run-bot ircbot)))))
