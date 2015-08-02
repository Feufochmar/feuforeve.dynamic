;; Vector Images
(define-module (ffch vectorgraphics)
  #:version (0 0 1)
  #:use-module (oop goops)
  #:use-module (ffch colors)
  #:use-module (ffch containers)
  #:export (shape-style fill-color stoke-color stroke-width
            point x y
            <vector-image> vector-image width height
            <area> area transforms
            <translation> translation translation-vector
            <scaling> scaling scale-factor
            <rotation> rotation rotation-angle center
            <circle> circle radius
            <rectangle> rectangle topleft
            <polygon> polygon points
           )
  #:re-export (<container-type> <content-type>
               id style-class contents
              )
)

;;;;
;; Style of shapes
(define-class <shape-style> (<object>)
  (fill-color #:getter fill-color #:init-keyword #:fill-color #:init-value #f)
  (stoke-color #:getter stroke-color #:init-keyword #:stroke-color #:init-value #f)
  (stroke-width #:getter stroke-width #:init-keyword #:stroke-width #:init-value #f)
)

(define-syntax shape-style
  (syntax-rules ()
    ((_ (slot val) ...)
     (let ((result (make <shape-style>)))
       (begin
         (slot-set! result (quote slot) val) ...
       )
       result
     ))
  ))

(define-method (fill-color (col <color>))
  (make <shape-style> #:fill-color col))
(define-method (stroke-color (col <color>))
  (make <shape-style> #:stroke-color col))
(define-method (stroke-width (width <number>))
  (make <shape-style> #:stroke-width width))

;;;;
;; Point
(define-class <point> (<object>)
  (x #:accessor x #:init-keyword #:x #:init-form 0)
  (y #:accessor y #:init-keyword #:y #:init-form 0)
)

(define-method (point (xx <number>) (yy <number>))
  (make <point> #:x xx #:y yy))

;;;;
;; Bounded-container : Container with width and height
(define-class <bounded-container> (<container-type>)
  (width #:accessor width #:init-keyword #:width #:init-form 0)
  (height #:accessor height #:init-keyword #:height #:init-form 0))

;;;;
;; Vector Image
(define-class <vector-image> (<bounded-container>))

(container-type-constructor vector-image <vector-image>)

;;;;
;; Area
(define-class <area> (<bounded-container> <content-type>)
  (transforms #:getter transforms #:init-keyword #:transforms #:init-form (list)))

(container-type-constructor area <area>)

;;;;
;; Transform-type
(define-class <transform-type> (<object>))

;;;;
;; Translation
(define-class <translation> (<tranform-type>)
  (translation-vector #:getter translation-vector #:init-keyword #:translation-vector #:init-form (point 0 0)))

(define-method (translation (pt <point>))
  (make <translation> #:translation-vector pt))

;;;;
;; Scaling
(define-class <scaling> (<transform-type>)
  (scale-factor #:getter scale-factor #:init-keyword #:scale-factor #:init-form 1))

(define-method (scaling (factor <number>))
  (make <scaling> #:scale-factor factor))

;;;;
;; Rotation
(define-class <rotation> (<tranform-type>)
  (rotation-angle #:getter rotation-angle #:init-keyword #:rotation-angle #:init-form 0)
  (center #:getter center #:init-keyword #:center #:init-form #f))

(define-method (rotation (ang <number>))
  (make <rotation> #:rotation-angle ang))
(define-method (rotation (ang <number>) (center <point>))
  (make <rotation> #:center center #:rotation-angle ang))

;;;;
;; Circle
(define-class <circle> (<content-type>)
  (center #:accessor center #:init-keyword #:center #:init-form (point 0 0))
  (radius #:accessor radius #:init-keyword #:radius #:init-form 0)
)

(content-type-constructor circle <circle>)

;;;;
;; Rectangle
(define-class <rectangle> (<content-type>)
  (width #:accessor width #:init-keyword #:width #:init-form 0.)
  (height #:accessor height #:init-keyword #:height #:init-form 0.)
  (topleft #:accessor topleft #:init-keyword #:topleft #:init-form (point 0 0))
)

(content-type-constructor rectangle <rectangle>)

;;;;
;; Polygon
(define-class <polygon> (<content-type>)
  (points #:accessor points #:init-keyword #:points #:init-form (list))
)

(content-type-constructor polygon <polygon>)
