(define-module (pages daily-island)
  #:use-module (ffch article)
  #:use-module (ffch forms)
  #:use-module (ffch weblets)
  #:use-module (ffch webtemplates)
  #:use-module (pages default-template)
  #:use-module ((srfi srfi-19) #:renamer (symbol-prefix-proc 'time:))
  #:use-module (island-generator island-generator)
  #:use-module (island-generator island-renderer)
  #:export (load-pages:daily-island)
  #:duplicates (merge-generics)
)

(define (today-string)
  (time:date->string (time:current-date) "~Y-~m-~d"))
(define (daily-island-link)
  (string-append (string-append "http://static.feuforeve.fr/islands/island-" (today-string) ".svg")))

;; Template
(define (daily-island-template meta)
  (default-template
    meta
    "/DailyIsland"
    (lambda (path query)
      (navigation
        (section ((name-class "nav-item"))
          (hyperlink ((to "/DailyIsland")) "Daily Island"))
        (section ((name-class "nav-item"))
          (hyperlink ((to "/DailyIsland/Image")) "Daily Island (image)"))
        (section ((name-class "nav-item"))
          (hyperlink ((to "/DailyIsland/Generator")) "Island generator"))
        (section ((name-class "nav-item"))
          (hyperlink ((to "/DailyIsland/About")) "About"))
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

(define (generate-raw port)
  (render-island
    (generate-island 700 600 10 #t)
    port)
  (newline port))

;; Island generator (raw svg)
(define (load-island-generator-raw wcontainer)
  (add-weblet wcontainer (list "DailyIsland" "RawIslandGenerator")
    (weblet ((error-code 200)
             (content-type "image/svg+xml;charset=UTF-8"))
      ((path query port)
       (generate-raw port)
      )
    )))

;; Island generator
(define (load-island-generator wcontainer)
  (add-weblet wcontainer (list "DailyIsland" "Generator")
    (templated-weblet
      (daily-island-template
        (metadata
          (stylesheets "http://static.feuforeve.fr/css/feuforeve.css")
          (scripts "http://static.feuforeve.fr/scripts/feuforeve.js")
          ))
      (lambda (query)
        (article
          ((title "Island Generator")(author "feuforeve.fr"))
          (section
            (paragraph
              (button
                ((onclick "reloadObject('generator');"))
                "New island"))
            (paragraph
              "Note: The island generator takes a few seconds to generate an island. "
              "If the 'New island' button does not work, refresh the page."))
          (section
            (embedded-object (id "generator") (data "/DailyIsland/RawIslandGenerator") (type "image/svg+xml"))
          )
        )))))

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
          (section ((title "Island Generator"))
            (paragraph
              "The Island Generator is an on-demand island generator. "
              "It uses a stripped down version of the generator used for generating "
              "the islands of the Daily Island. " (linefeed)
              "The generator of the Daily Island is not suited for on-demand generation as "
              "an island takes time to generate an island, thus the use of a simplified version "
              "for the Island Generator.")
          )
        )))))

;; Load all
(define (load-pages:daily-island wcontainer)
  (load-daily-island wcontainer)
  (load-daily-island-image wcontainer)
  (load-island-generator-raw wcontainer)
  (load-island-generator wcontainer)
  (load-about-daily-island wcontainer)
  )
