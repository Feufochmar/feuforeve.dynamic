;; Ircbot : an IRC bot based on guile-irc
(define-module (ffch ircbot)
  #:version (0 0 1)
  #:use-module (oop goops)
  #:use-module (irc irc)
  #:use-module (irc handlers)
  #:use-module ((irc message)
                #:renamer (symbol-prefix-proc 'msg:))
  #:export (make-ircbot add-command-handler! add-command-alias!
            run-bot send-privmsg
           ))

(define-class <ircbot> (<object>)
  (irc-connection #:getter irc-connection #:init-keyword #:irc-connection)
  (irc-nick #:getter irc-nick #:init-keyword #:nick)
  (command-prefix #:getter command-prefix #:init-keyword #:command-prefix)
  (commands #:getter commands #:init-form (make-hash-table))
  (chanels #:getter channels #:init-keyword #:channels #:init-form (list))
)

;; Commands can be given to the bot in three ways:
;; - <prefix><command> <args* ...>
;; - <botname>[:] <command> <args* ...>
;; - <command> <botname> <args* ...>
(define-method (get-command-and-args (ircbot <ircbot>) msg)
  (let* ((botname (irc-nick ircbot))
         (prefix (command-prefix ircbot))
         (body (msg:trailing msg))
         (body-split (and body (string-split body #\ )))
         (body-words (and body-split (not (null? body-split)) body-split)))
    (cond
      ((and body-words
            (string-prefix? prefix (car body-words)))
       (cons (string-drop (car body-words) (string-length prefix))
             (cdr body-words)))
      ((and body-words
            (not (null? (cdr body-words)))
            (or (string-ci=? botname (car body-words))
                (string-ci=? (string-append botname ":") (car body-words))))
       (cdr body-words))
      ((and body-words
            (not (null? (cdr body-words)))
            (string-ci=? botname (cadr body-words)))
       (cons (car body-words) (cddr body-words)))
      (#t #f))))

;;
(define (source-nick msg)
  (let ((prfx (msg:prefix msg)))
    (if (list? prfx)
        (car prfx)
        prfx)))

;;
(define-method (bot-command-handler (ircbot <ircbot>))
  (lambda (msg)
    (let* ((command-args (get-command-and-args ircbot msg))
           (command (and command-args (car command-args)))
           (args (and command-args (cdr command-args)))
           (handler (and command (command-handler ircbot command)))
           (asker (source-nick msg))
          )
      (if handler
          (handler ircbot (msg:parse-target msg) asker args)))))

(define-method (install-command-handler! (ircbot <ircbot>))
  (add-simple-message-hook!
    (irc-connection ircbot)
    (bot-command-handler ircbot)
    #:command 'PRIVMSG
    #:tag 'command-handler))

;; Because we need to wait the welcome message before joining channels
(define-method (install-join-handler! (ircbot <ircbot>))
  (add-message-hook!
    (irc-connection ircbot)
    (lambda (msg)
      (if (eq? (msg:command msg) 001) ;; Welcome message, registering ok
          (for-each
            (lambda (x) (do-join (irc-connection ircbot) x))
            (channels ircbot))))
    #:tag 'join-handler))

(define-method (init (ircbot <ircbot>))
  (install-ping-handler! (irc-connection ircbot))
  (install-printer! (irc-connection ircbot))
  (install-join-handler! ircbot)
  (install-command-handler! ircbot))

;;
(define* (make-ircbot #:key (nick #f) (server #f) (port #f) (prefix "!") (channels (list)))
  (or (and nick (string? nick)) (error "ircbot: Invalid nick: " nick))
  (or (and server (string? server)) (error "ircbot: Invalid server: " server))
  (or (and port (integer? port) (< 0 port) (< port 65536)) (error "ircbot: Invalid port: " port))
  (let ((ircbot
          (make <ircbot>
            #:irc-connection (make-irc #:nick nick #:server server #:port port)
            #:nick nick
            #:command-prefix prefix
            #:channels channels)))
    (init ircbot)
    ircbot))

;; A command handler if a function with 4 arguments:
;;  - ircbot
;;  - destination of the message (in case of privmsg)
;;  - the nick of the user issuing the command
;;  - the arguments of the command as a list of strings
(define-method (add-command-handler! (ircbot <ircbot>) (command <string>) (handler <applicable>))
  (hash-set! (commands ircbot) (string-downcase command) handler))

(define-method (command-handler (ircbot <ircbot>) (command <string>))
  (hash-ref (commands ircbot) (string-downcase command)))

(define-method (add-command-alias! (ircbot <ircbot>) (command <string>) (alias <string>))
  (hash-set! (commands ircbot) (string-downcase alias) (command-handler ircbot command)))

(define-method (add-command-alias! (ircbot <ircbot>) (command <string>) (aliases <list>))
  (for-each
    (lambda (x) (add-command-alias! ircbot command x))
    aliases))

;; Run the client. Should not exit unless there is a disconnection.
(define-method (run-bot (ircbot <ircbot>))
  (do-connect (irc-connection ircbot))
  (do-register (irc-connection ircbot))
  ;; Run the irc client
  (do-runloop (irc-connection ircbot)))

;; Send a privmsg
(define-method (send-privmsg (ircbot <ircbot>) (to <string>) (what <string>))
  (do-privmsg (irc-connection ircbot) to what))
