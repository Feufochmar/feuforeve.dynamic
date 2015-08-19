(define-module (main)
  #:use-module (ffch weblets)
  #:use-module (pages home)
  #:use-module (pages flora-character-generator)
  #:use-module (pages arnytron)
  #:use-module (pages flag-generator)
  #:duplicates (merge-generics)
)

;; To avoid using the C locale in guile-2.0
(setlocale LC_ALL "")

;; Initialize the random number generator
(set! *random-state* (random-state-from-platform))

;; Webcontainer dispatching pages
(define wcontainer (webcontainer 8080))

;; Load the pages
(load-pages:home wcontainer)
(load-pages:flora-character-generator wcontainer)
(load-pages:arnytron wcontainer)
(load-pages:flag-generator wcontainer)

;; Run the webserver
(run-webcontainer wcontainer)
