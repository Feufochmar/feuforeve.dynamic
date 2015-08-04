;; Palette for flags
(define-module (flag-generator palette)
  #:version (0 0 1)
  #:use-module (oop goops)
  #:use-module (ffch random)
  #:use-module (ffch colors)
  #:use-module (srfi srfi-1)
  #:export (<palette> metal-ref tincture-ref pick-palette
           )
)

;;;;
;; Color sets

;; Metals (light colors)
(define metal-colors
  (list
    (hsl-color 0 0 95) ;; Argent <=> White
    (hsl-color 50 100 50) ;; Or <=> Yellow
    (hsl-color 200 65 80) ;; Celeste <=> Light blue
    (hsl-color 0 65 80) ;; Carnation <=> Light red / skin
    (hsl-color 275 65 80) ;; Lavender <=> Light purple
    (hsl-color 130 65 80) ;; Mint <=> Light green
    (hsl-color 50 65 80) ;; Buff <=> Light brown / beige
  ))

;; Tinctures (dark colors)
(define tincture-colors
  (list
    (hsl-color 225 85 40) ;; Azure <=> Blue
    (hsl-color 0 85 50) ;; Gules <=> Red
    (hsl-color 0 75 30) ;; Sanguine <=> Dark red
    (hsl-color 310 45 40) ;; Purpure <=> Purple
    (hsl-color 210 15 40) ;; Cendrée <=> Grey
    (hsl-color 0 0 0) ;; Sable <=> Black
    (hsl-color 110 75 30) ;; Vert <=> Green
    (hsl-color 30 85 50) ;; Orangé <=> Orange
    (hsl-color 20 75 30) ;; Tenné <=> Brown
  ))

;; Palette class
(define-class <palette> (<object>)
  (metals #:accessor metals #:init-keyword #:metals #:init-form (vector)) ;; vector of metal colors
  (tinctures #:accessor tinctures #:init-keyword #:tinctures #:init-form (vector)) ;; vector of tincture colors
)

;; Palette methods
(define-method (metal-ref (p <palette>) (n <integer>))
  (vector-ref (metals p) n))
(define-method (tincture-ref (p <palette>) (n <integer>))
  (vector-ref (tinctures p) n))

;;
(define-method (pick-palette (n <integer>))
  (let ((metals (shuffle metal-colors))
        (tinctures (shuffle tincture-colors)))
    (make <palette>
          #:metals (list->vector (take metals n))
          #:tinctures (list->vector (take tinctures n))
    )))
