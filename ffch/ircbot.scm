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
            ;
            make-ircbot-from-command-line-args
           ))

(define-class <ircbot> (<object>)
  (irc-connection #:getter irc-connection #:init-keyword #:irc-connection)
  (irc-nick #:getter irc-nick #:init-keyword #:nick)
  (command-prefix #:getter command-prefix #:init-keyword #:command-prefix)
  (commands #:getter commands #:init-form (make-hash-table))
  (chanels #:getter channels #:init-keyword #:channels #:init-form (list))
  (nick-password #:getter nick-password #:init-keyword #:nick-password #:init-form #f)
  (log-file #:getter log-file #:init-keyword #:log-file #:init-form #f)
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
          (begin
            ;; Register nick
            (if (nick-password ircbot)
                (begin
                  (do-privmsg (irc-connection ircbot) "NickServ" (string-append "IDENTIFY " (nick-password ircbot)))
                  (sleep 2)))
            ;; Join channels
            (for-each
              (lambda (x) (do-join (irc-connection ircbot) x))
              (channels ircbot)))))
    #:tag 'join-handler))

(define-method (init (ircbot <ircbot>))
  (install-ping-handler! (irc-connection ircbot))
  (install-printer!
    (irc-connection ircbot)
    #:port
      (if (log-file ircbot)
          (let ((output (open-file (log-file ircbot) "al"))) ;; Append, line-buffered.
               (set-port-encoding! output "UTF-8")
               output)
          (current-output-port)))
  (install-join-handler! ircbot)
  (install-command-handler! ircbot))

;;
(define* (make-ircbot #:key (nick #f) (server #f) (port #f)
                            (prefix "!") (channels (list)) (nick-password #f)
                            (log-file #f))
  (or (and nick (string? nick)) (error "ircbot: Invalid nick: " nick))
  (or (and server (string? server)) (error "ircbot: Invalid server: " server))
  (or (and port (integer? port) (< 0 port) (< port 65536)) (error "ircbot: Invalid port: " port))
  (let ((ircbot
          (make <ircbot>
            #:irc-connection (make-irc #:nick nick #:server server #:port port)
            #:nick nick
            #:command-prefix prefix
            #:channels channels
            #:nick-password nick-password
            #:log-file log-file)))
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

;; Make an ircbot from command-line args
(define command-line-args (make-hash-table))
(map
  (lambda (x) (hash-set! command-line-args (car x) (cdr x)))
  (list
    (cons "--server" #:server)
    (cons "--port" #:port)
    (cons "--channels" #:channels)
    (cons "--nick" #:nick)
    (cons "--command-prefix" #:prefix)
    (cons "--nick-password" #:nick-password)
    (cons "--log-file" #:log-file)))
(define-method (update-hash-from-command-line! (h <hashtable>) (args <list>))
  (cond
    ((null? args) h)
    ((and (hash-ref command-line-args (car args)) (not (null? (cdr args))))
     (begin
       (hash-set! h (hash-ref command-line-args (car args)) (cadr args))
       (update-hash-from-command-line! h (cddr args))))
    ((and (string=? (car args) "--help") (not (null? (cdr args))))
     (begin
        (hash-set! h #:help #t)
        (display
          (string-append
            "ircbot"
            " --server <server> [--port <port>] [--nick <nick>]"
            " --channels <channel>[:<channel>[:...]] [--command-prefix <prefix>]"
            " [--nick-password <nickpass>] [--log-file <logfile>]\n"
            "With:\n"
            " <server> : the server to connect to (required)\n"
            " <port> : the server port to connect to (optional, default: 6667)\n"
            " <nick> : the nickname to use (optional, default: IrcBot)\n"
            " <channel> : a channel to join, without the beginning # (required)\n"
            "             Several channel can be joined. The channels must be separed by colons.\n"
            " <prefix> : the command prefix to use (optional, default: !\n"
            " <nickpass> : the password for NickServ for using the given nickname\n"
            "              (optional, if not set, IrcBot do not register to NickServ)\n"
            " <logfile> : the file use for logging. The file is opened in append mode.\n"
            "              (optional, if not set, use the standard output)\n"))
        h))
    (#t (error "Invalid arguments " args ". See --help"))
  ))

(define-method (make-ircbot-from-command-line-args (args <list>))
  (let* ((hash-args (update-hash-from-command-line! (make-hash-table) (cdr args)))
         (help? (hash-ref hash-args #:help))
         (server (or help? (hash-ref hash-args #:server) (error "No server given.")))
         (port-str (or help? (hash-ref hash-args #:port) "6667"))
         (port (or help? (string->number port-str) (error "Invalid port")))
         (nick (or help? (hash-ref hash-args #:nick) "IrcBot"))
         (channels (or help? (hash-ref hash-args #:channels) (error "No channel given.")))
         (prefix (or help? (hash-ref hash-args #:prefix) "!"))
         (nickpass (or help? (hash-ref hash-args #:nick-password)))
         (logfile (or help? (hash-ref hash-args #:log-file))))
    (if help?
        #f
        (make-ircbot
          #:nick nick
          #:server server
          #:port port
          #:prefix prefix
          #:channels (map (lambda (x) (string-append "#" x))
                          (string-split channels #\:))
          #:nick-password nickpass
          #:log-file logfile))))
