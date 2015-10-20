(define-module (pages daily-island)
  #:use-module (ffch article)
  #:use-module (ffch forms)
  #:use-module (ffch weblets)
  #:use-module (ffch webtemplates)
  #:use-module (pages default-template)
  #:use-module ((srfi srfi-19) #:renamer (symbol-prefix-proc 'time:))
  #:export (load-pages:daily-island)
  #:duplicates (merge-generics)
)

(define (today-string)
  (time:date->string (time:current-date) "~Y-~m-~d"))
(define (daily-island-link)
  (string-append (string-append (static-data "islands/island-") (today-string) ".svg")))

;; Template
(define (daily-island-template meta)
  (default-template
    meta
    "/DailyIsland"
    (lambda (path query)
      (navigation
        (section ((name-class "nav-item"))
          (nav-link-to "/DailyIsland" (nav-current-path path) "Daily Island"))
        (section ((name-class "nav-item"))
          (hyperlink ((to "/DailyIsland/Image")) "Daily Island (image)"))
        (section ((name-class "nav-item"))
          (nav-link-to "/DailyIsland/About" (nav-current-path path) "About"))
      ))))

;; Daily Island
(define (load-daily-island wcontainer)
  (add-weblet wcontainer (list "DailyIsland")
    (templated-weblet
      (daily-island-template default-meta)
      (lambda (query)
        (article
          ((title "Daily Island")(author "feuforeve.fr")(date (today-string)))
          (paragraph
            (embedded-object (data (daily-island-link)) (type "image/svg+xml"))))
      ))))

;; Daily Island, today's image
(define (load-daily-island-image wcontainer)
  (add-weblet wcontainer (list "DailyIsland" "Image")
    (dynamic-header-weblet
      ((error-code 303)
       (content-type (const "text/plain;charset=UTF-8"))
       (location daily-island-link))
      ((path query port)
       (display "See: " port)(display (daily-island-link) port)
       (newline port))
    )))

;; About
(define (load-about-daily-island wcontainer)
  (add-weblet wcontainer (list "DailyIsland" "About")
    (templated-weblet
      (daily-island-template default-meta)
      (lambda (query)
        (article
          ((title "About the Daily Island")(author "feuforeve.fr")(date "2015-09-14"))
          (section ((title "Daily Island"))
            (paragraph
              "The Daily Island is an island map that is generated every day. "
              "The image is an Svg file with interactive controls "
              "(layers of the image can be hidden and displayed by clicking on the buttons). ")
          )
        )))))

;; Load all
(define (load-pages:daily-island wcontainer)
  (load-daily-island wcontainer)
  (load-daily-island-image wcontainer)
  (load-about-daily-island wcontainer)
  )
