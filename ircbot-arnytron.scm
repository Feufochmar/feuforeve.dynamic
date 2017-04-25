(define-module (ircbot-arnytron)
  #:use-module (ffch ircbot)
  #:use-module (arnytron arnytron)
  #:use-module (ffch random)
  #:export (main)
  #:duplicates (merge-generics)
)

;; To avoid using the C locale in guile-2.0
(setlocale LC_ALL "")

;; Initialize the random number generator
(set! *random-state* (random-state-from-platform))
(set-port-encoding! (current-output-port) "UTF-8")

(define (add-handlers ircbot ArnYtron3000)
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
    "frappe"
    (lambda (ircbot channel asker args)
      (let* ((slapped (if (not (null? args)) (car args) asker))
             (msg (string-append
                    "\u0001ACTION frappe " slapped " avec "
                    (generate-citation
                      ArnYtron3000
                      (list (pick-from (vector "un" "une" "des" "le" "la" "les" "du"))))
                    "\u0001")))
        (send-privmsg ircbot channel msg))))
  (add-command-alias!
    ircbot
    "frappe"
    (list "frappe!" "frappe!!" "frappe!!!" "slap" "slap!" "slap!!" "slap!!!"))
  (add-command-handler!
    ircbot
    "cite"
    (lambda (ircbot channel asker args)
      (let ((arny-quote (if (not (null? args))
                            (pick-citation ArnYtron3000 (car args))
                            (pick-citation ArnYtron3000))))
        (send-privmsg ircbot channel
                      (string-append "«" (citation arny-quote) "» - ArnY, " (date arny-quote))))))
  (add-command-alias!
    ircbot
    "cite"
    (list "cite!" "cite!!" "cite!!!" "quote" "quote!" "quote!!" "quote!!!"))
  (add-command-handler!
    ircbot
    "salut"
    (lambda (ircbot channel asker args)
      (if (not (null? args))
          (let* ((receiver (car args))
                 (receiver-channel? (string-prefix? "#" receiver))
                 (on-channel? (member receiver (channels ircbot)))
                )
            (cond
              ((equal? receiver (irc-nick ircbot))
               (send-privmsg
                 ircbot asker
                 (string-append asker ": Je n'ai pas besoin de me saluer.")))
              ((and receiver-channel? on-channel?)
               (send-privmsg
                 ircbot receiver
                 (string-append "De la part de " asker " : " (generate-citation ArnYtron3000))))
              ((and receiver-channel? (not on-channel?))
               (send-privmsg
                 ircbot asker
                 (string-append asker ": Je ne salue pas les canaux que je ne fréquente pas.")))
              ((not receiver-channel?)
               (send-privmsg
                 ircbot receiver
                 (string-append "De la part de " asker " : " (generate-citation ArnYtron3000))))
              (#t #f) ; do nothing
            ))
          (send-privmsg
           ircbot channel
           (string-append asker ": " (generate-citation ArnYtron3000))))))
  (add-command-alias!
    ircbot
    "salut"
    (list "salue"))
)

(define (main args)
  (let ((ircbot (make-ircbot-from-command-line-args args))
        (ArnYtron3000 (arnytron)))
    (if ircbot
        (begin
          (add-handlers ircbot ArnYtron3000)
          (run-bot ircbot)
          ; run-bot exits on disconnection - restart
          (main args)))))
