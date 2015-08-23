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

(define (main args)
  (let ((ircbot (make-ircbot-from-command-line-args args))
        (ArnYtron3000 (arnytron)))
    (if ircbot
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
