(define-module (hexamap)
  #:use-module (island-generator island-generator)
  #:use-module (island-generator island-renderer)
  #:use-module (ffch debug)
  #:duplicates (merge-generics)
)

;; To avoid using the C locale in guile-2.0
(setlocale LC_ALL "")

;; Initialize the random number generator
(set! *random-state* (random-state-from-platform))
(set-port-encoding! (current-output-port) "UTF-8")

(display "Start\n")
(define *image-width* 800)
(define *image-height* 700)
(define *size* 6)
(define *simple?* #f)

(format #t "Image width: ~s ; Size: ~s\n" *image-width* *size*)

(define *island* (generate-island *image-width* *image-height* *size* *simple?*))
(format #t "Nb polygons: ~s\n" (+ 1 (* 3 ((@@ (island-generator island-generator) grid-radius) *island*)
                                         (+ ((@@ (island-generator island-generator) grid-radius) *island*) 1))))

(measure-time "Rendering island"
  (let ((*island-file* (open-file "island.svg" "w")))
    (render-island *island* *island-file*)
    (close *island-file*)))
