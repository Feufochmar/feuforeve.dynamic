;; sxml-svg exporter for classes of VectorGraphics module
(define-module (ffch vectorgraphics-exporters sxml-svg)
  #:version (0 0 1)
  #:use-module (oop goops)
  #:use-module (ffch vectorgraphics)
  #:use-module (ffch colors)
  #:export (vectorgraphics->sxml-svg)
)

;; The only method exported is vectorgraphics->sxml-svg, defined for every vectorgraphics datatype

;;;;
;; Helper methods

;; Only inexact values are supported
(define-method (show (n <number>))
  (number->string (exact->inexact n)))

;; Point
(define-method (show (pt <point>))
  (string-append (show (x pt)) "," (show (y pt))))

;; Shape style
(define-method (show (stl <shape-style>))
  (string-append
    (if (fill-color stl)
        (string-append "fill:" (css-value (fill-color stl)) ";")
        "")
    (if (stroke-color stl)
        (string-append "stroke:" (css-value (stroke-color stl)) ";")
        "")
    (if (stroke-width stl)
        (string-append "stroke-width:" (show (stroke-width stl)) ";")
        "")
  ))

;; Translation
(define-method (show (trf <translation>))
  (string-append "translate(" (show (translation-vector trf)) ")"))

;; Scaling
(define-method (show (trf <scaling>))
  (string-append "scale(" (show (scale-factor trf)) ")"))

;; Rotation
(define-method (show (trf <rotation>))
  (string-append
    "rotate("
    (show (rotation-angle trf))
    (if (center trf)
        (string-append "," (show (center trf)))
        "")
    ")"))

;;;;
;; Generic container
(define-method (vectorgraphics->sxml-svg (cnt <container-type>))
  (map
    vectorgraphics->sxml-svg
    (contents cnt)))

;;;;
;; Generic contents
(define-method (attributes-of (cnt <content-type>))
  (append
    (if (id cnt)
        (list (list 'id (id cnt)))
        (list))
    (if (style-class cnt)
        (let ((stl (show (style-class cnt))))
          (if (string-null? stl)
              (list)
              (list (list 'style stl))
          ))
        (list))
  ))

;;;;
;; Image
(define-method (vectorgraphics->sxml-svg (cnt <vector-image>))
  (list 'svg
    (list '@
      (list 'width (show (width cnt)))
      (list 'height (show (height cnt)))
      (list 'version "1.1")
      (list 'xmlns "http://www.w3.org/2000/svg")
    )
    (next-method)
  ))

;;;;
;; Area
(define-method (attributes-of (cnt <area>))
  (append
    (if (not (null? (transforms cnt)))
        (list (list 'transform (string-join (map show (transforms cnt)) " ")))
        (list))
    (next-method)
  ))

(define-method (vectorgraphics->sxml-svg (cnt <area>))
  (list 'g
    (append (list '@) (attributes-of cnt))
    (next-method)
  ))

;;;;
;; Circle
(define-method (attributes-of (cnt <circle>))
  (append
    (list
      (list 'cx (show (x (center cnt))))
      (list 'cy (show (y (center cnt))))
      (list 'r (show (radius cnt)))
    )
    (next-method)
  ))

(define-method (vectorgraphics->sxml-svg (cnt <circle>))
  (list 'circle (append (list '@) (attributes-of cnt))))

;;;;
;; Rectangle
(define-method (attributes-of (cnt <rectangle>))
  (append
    (list
      (list 'x (show (x (topleft cnt))))
      (list 'y (show (y (topleft cnt))))
      (list 'width (show (width cnt)))
      (list 'height (show (height cnt)))
    )
    (next-method)
  ))

(define-method (vectorgraphics->sxml-svg (cnt <rectangle>))
  (list 'rect (append (list '@) (attributes-of cnt))))

;;;;
;; Polygon
(define-method (attributes-of (cnt <polygon>))
  (append
    (list
      (list 'points (string-join (map show (points cnt)) " "))
    )
    (next-method)
  ))

(define-method (vectorgraphics->sxml-svg (cnt <polygon>))
  (list 'polygon (append (list '@) (attributes-of cnt))))

#!


;;;;
;; Polygon
(define-class <polygon> (<content-type>)
  (points #:accessor points #:init-keyword #:points #:init-form (list))
)

!#
