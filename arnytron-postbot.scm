(use-modules (oauth oauth1)
             (arnytron arnytron))

(set! *random-state* (random-state-from-platform))

(define *twitter-root* "https://api.twitter.com/1.1")
(define *status-update* "/statuses/update.json")

;; Twitter keys
(define *twitter-consumer-key* "...")
(define *twitter-consumer-secret* "...")
(define *twitter-access-token* "...")
(define *twitter-access-token-secret* "...")

;; Fill the twitter keys before using this
(let ((credentials (oauth1-credentials *twitter-consumer-key* *twitter-consumer-secret*))
      (access (oauth1-credentials *twitter-access-token* *twitter-access-token-secret*))
      (generator (arnytron))
      )
  (display
    (oauth1-client-request
      (string-append *twitter-root* *status-update*)
      credentials
      access
      #:method 'POST
      #:params `((status . ,(generate-citation generator)))
    ))
  (newline))
