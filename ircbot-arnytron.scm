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
    "cite"
    (lambda (ircbot channel asker args)
      (let ((arny-quote (pick-citation ArnYtron3000)))
        (send-privmsg ircbot channel
                      (string-append "\"" (citation arny-quote) "\" - ArnY, " (date arny-quote))))))
  (add-command-alias!
    ircbot
    "cite"
    (list "cite!" "cite!!" "cite!!!"))
)

(define nbfailures 0)
(define (main args)
  (catch
    #t
    (lambda ()
      (let ((ircbot (make-ircbot-from-command-line-args args))
            (ArnYtron3000 (arnytron)))
        (if ircbot
            (begin
              (add-handlers ircbot ArnYtron3000)
              (run-bot ircbot)))))
    (lambda (key . args)
      (display "Exception occurred: ")(display key)(display " ")(display args)(newline)))
  ; Restart after a timeout if exception occurred
  ; If too much exceptions occured, quit
  (sleep 10)
  (set! nbfailures (+ 1 nbfailures))
  (sleep (* 10 nbfailures))
  (if (< nbfailures 10)
      (main args)
      (error "Unable to start Floraverse IRC bot")))
