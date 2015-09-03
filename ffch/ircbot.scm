;; Ircbot : an IRC bot based on guile-irc
(define-module (ffch ircbot)
  #:version (0 0 1)
  #:use-module (oop goops)
  #:use-module (srfi srfi-19)
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

;; More symbols for logging
(define *numeric-replies* (make-hash-table))
(map
  (lambda (x) (hash-set! *numeric-replies* (car x) (cdr x)))
  '((1 . "RPL_WELCOME") (2 . "RPL_YOURHOST") (3 . "RPL_CREATED") (4 . "RPL_MYINFO") (5 . "RPL_ISUPPORT")
    (10 . "RPL_BOUNCE") (200 . "RPL_TRACELINK") (201 . "RPL_TRACECONNECTING") (202 . "RPL_TRACEHANDSHAKE")
    (203 . "RPL_TRACEUNKNOWN") (204 . "RPL_TRACEOPERATOR") (205 . "RPL_TRACEUSER") (206 . "RPL_TRACESERVER")
    (207 . "RPL_TRACESERVICE") (208 . "RPL_TRACENEWTYPE") (209 . "RPL_TRACECLASS") (211 . "RPL_STATSLINKINFO")
    (212 . "RPL_STATSCOMMANDS") (213 . "RPL_STATSCLINE") (214 . "RPL_STATSNLINE") (215 . "RPL_STATSILINE")
    (216 . "RPL_STATSKLINE") (217 . "RPL_STATSQLINE") (218 . "RPL_STATSYLINE") (219 . "RPL_ENDOFSTATS")
    (221 . "RPL_UMODEIS") (234 . "RPL_SERVLIST") (235 . "RPL_SERVLISTEND") (240 . "RPL_STATSVLINE")
    (241 . "RPL_STATSLLINE") (242 . "RPL_STATSUPTIME") (243 . "RPL_STATSOLINE") (244 . "RPL_STATSHLINE")
    (247 . "RPL_STATSBLINE") (250 . "RPL_STATSDLINE") (251 . "RPL_LUSERCLIENT") (252 . "RPL_LUSEROP")
    (253 . "RPL_LUSERUNKNOWN") (254 . "RPL_LUSERCHANNELS") (255 . "RPL_LUSERME") (256 . "RPL_ADMINME")
    (257 . "RPL_ADMINLOC1") (258 . "RPL_ADMINLOC2") (259 . "RPL_ADMINEMAIL") (261 . "RPL_TRACELOG")
    (262 . "RPL_TRACEEND") (263 . "RPL_TRYAGAIN") (300 . "RPL_NONE") (301 . "RPL_AWAY") (302 . "RPL_USERHOST")
    (303. "RPL_ISON") (305 . "RPL_UNAWAY") (306 . "RPL_NOWAWAY") (311 . "RPL_WHOISUSER") (312 . "RPL_WHOISSERVER")
    (313 . "RPL_WHOISOPERATOR") (314 . "RPL_WHOWASUSER") (315 . "RPL_ENDOFWHO") (317 . "RPL_WHOISIDLE")
    (318 . "RPL_ENDOFWHOIS") (319. "RPL_WHOISCHANNELS") (322 . "RPL_LIST") (323 . "RPL_LISTEND")
    (324 . "RPL_CHANNELMODEIS") (325 . "RPL_UNIQOPIS") (331. "RPL_NOTOPIC") (332 . "RPL_TOPIC")
    (341 . "RPL_INVITING") (346 . "RPL_INVITELIST") (347 . "RPL_ENDOFINVITELIST") (348 . "RPL_EXCEPTLIST")
    (349 . "RPL_ENDOFEXCEPTLIST") (351 . "RPL_VERSION") (352 . "RPL_WHOREPLY") (353 . "RPL_NAMREPLY")
    (364 . "RPL_LINKS") (365 . "RPL_ENDOFLINKS") (366 . "RPL_ENDOFNAMES") (367 . "RPL_BANLIST")
    (368 . "RPL_ENDOFBANLIST") (369 . "RPL_ENDOFWHOWAS") (371 . "RPL_INFO") (372 . "RPL_MOTD")
    (374 . "RPL_ENDOFINFO") (375 . "RPL_MOTDSTART") (376 . "RPL_ENDOFMOTD") (381 . "RPL_YOUREOPER")
    (382 . "RPL_REHASHING") (383 . "RPL_YOURESERVICE") (391 . "RPL_TIME") (392 . "RPL_USERSSTART")
    (393 . "RPL_USERS") (394 . "RPL_ENDOFUSERS") (395 . "RPL_NOUSERS") (401 . "ERR_NOSUCHNICK")
    (402 . "ERR_NOSUCHSERVER") (403 . "ERR_NOSUCHCHANNEL") (404 . "ERR_CANNOTSENDTOCHAN")
    (405 . "ERR_TOOMANYCHANNELS") (406 . "ERR_WASNOSUCHNICK") (407 . "ERR_TOOMANYTARGETS")
    (408 . "ERR_NOSUCHSERVICE") (409 . "ERR_NOORIGIN") (411 . "ERR_NORECIPIENT") (412 . "ERR_NOTEXTTOSEND")
    (413 . "ERR_NOTOPLEVEL") (414 . "ERR_WILDTOPLEVEL") (415 . "ERR_BADMASK") (421 . "ERR_UNKNOWNCOMMAND")
    (422 . "ERR_NOMOTD") (423 . "ERR_NOADMININFO") (424 . "ERR_FILEERROR") (431 . "ERR_NONICKNAMEGIVEN")
    (432 . "ERR_ERRONEUSNICKNAME") (433 . "ERR_NICKNAMEINUSE") (436 . "ERR_NICKCOLLISION")
    (437 . "ERR_UNAVAILRESOURCE") (441 . "ERR_USERNOTINCHANNEL") (442 . "ERR_NOTONCHANNEL")
    (443 . "ERR_USERONCHANNEL") (444 . "ERR_NOLOGIN") (445 . "ERR_SUMMONDISABLED") (446 . "ERR_USERSDISABLED")
    (451 . "ERR_NOTREGISTERED") (461 . "ERR_NEEDMOREPARAMS") (462 . "ERR_ALREADYREGISTERED")
    (463 . "ERR_NOPERMFORHOST") (464 . "ERR_PASSWDMISMATCH") (465 . "ERR_YOUREBANNEDCREEP")
    (467 . "ERR_KEYSET") (471 . "ERR_CHANNELISFULL") (472 . "ERR_UNKNOWNMODE") (473 . "ERR_INVITEONLYCHAN")
    (474 . "ERR_BANNEDFROMCHAN") (475 . "ERR_BADCHANNELKEY") (476. "ERR_BADCHANMASK") (477 . "ERR_NOCHANMODES")
    (478 . "ERR_BANLISTFULL") (481 . "ERR_NOPRIVILEGES") (482 . "ERR_CHANOPRIVSNEEDED") (483 . "ERR_CANTKILLSERVER")
    (484 . "ERR_RESTRICTED") (485 . "ERR_UNIQOPRIVSNEEDED") (491 . "ERR_NOOPERHOST") (501 . "ERR_UMODEUNKNOWNFLAG")
    (502 . "ERR_USERSDONTMATCH")
   ))

;
(define-method (msg:command->string (cmd <symbol>))
  cmd)
(define-method (msg:command->string (cmd <integer>))
  (or (hash-ref *numeric-replies* cmd) cmd))

;; Logger. install-printer! provided by guile-irc does not indicate timestamps
(define-method (install-log-handler! (ircbot <ircbot>))
  (add-message-hook!
    (irc-connection ircbot)
    (let* ((logfile (log-file ircbot))
           (port (if logfile (open-file logfile "al") (current-output-port)))) ;; Append, line-buffered
      (set-port-encoding! port "UTF-8")
      (lambda (msg)
        (if (not (eq? (msg:command msg) 'PING))
            (let ((middle (msg:middle msg)))
              (format port "[~a][~a][~a] ~a: ~a~a\n"
                (date->string (current-date) "~1 ~3")
                (msg:command->string (msg:command msg))
                (or (and (list? middle) (car middle))
                    (and (string? middle) middle) (irc-nick ircbot))
                (source-nick msg)
                (or (and (list? middle) (string-append (string-join (cdr middle) " ") " ")) "")
                (or (msg:trailing msg) ""))))))
    #:tag 'log-handler))

;; Ping notifier, for ping timeout
(define-method (install-ping-notifier! (ircbot <ircbot>) (condvar <condition-variable>))
  (add-message-hook!
    (irc-connection ircbot)
    (lambda (msg)
      (if (eq? (msg:command msg) 'PING)
          (signal-condition-variable condvar)))
    #:tag 'ping-notifier))

;; Ping timeout from server: Server has stopped to send pings
(define-method (close-on-ping-timeout (ircbot <ircbot>) (condvar <condition-variable>) (timeout <integer>))
  (letrec* ((mtx (make-mutex))
            (waiter
              (lambda ()
                (lock-mutex mtx)
                (if (unlock-mutex mtx condvar (+ timeout (time-second (current-time))))
                    (waiter) ; condition variable signaled, wait again
                    (begin
                      (display "Closing connection...\n")
                      ; no ping received, close connection
                      (do-quit (irc-connection ircbot) #:quit-msg "ArnY timeout.")))))
           )
    (call-with-new-thread waiter)))

;; Init methods
(define-method (init (ircbot <ircbot>))
  (install-ping-handler! (irc-connection ircbot))
  (install-log-handler! ircbot)
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
  (letrec ((condvar (make-condition-variable))
           (runloop
            (lambda ()
              (if (connected? (irc-connection ircbot))
                  (let ((msg (do-listen (irc-connection ircbot))))
                    (if msg
                        (begin
                          (run-message-hook (irc-connection ircbot) msg) ; Process message
                          (runloop))
                        (begin
                          (sleep 1) ; Wait a bit before new messages
                          (runloop))))
                  (display "Disconnected...\n")))))
    (install-ping-notifier! ircbot condvar)
    (close-on-ping-timeout ircbot condvar (* 15 60)) ; timeout of 15 minutes before disconnecting
    (do-connect (irc-connection ircbot))
    (do-register (irc-connection ircbot))
    ;; Run the irc client
    (runloop)))

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
