;; Vector Images
(define-module (ffch vectorgraphics)
  #:version (0 0 1)
  #:use-module (oop goops)
  #:use-module (ffch colors)
  #:use-module (ffch containers)
  #:export (<shape-style> shape-style fill-color stroke-color stroke-width font-size font-family
            ;
            <point> point x y
            ;
            <vector-image> vector-image width height
            ;
            <script> script
            ;
            <vectorgraphics-content-type> on-focus-in on-focus-out on-activate
            on-click on-mouse-down on-mouse-up on-mouse-over on-mouse-move on-mouse-out
            ;
            <area> area transforms
            <translation> translation translation-vector
            <scaling> scaling scale-factor
            <rotation> rotation rotation-angle center
            ;
            <text> text topleft
            ;
            <circle> circle radius
            ;
            <rectangle> rectangle
            ;
            <polygon> polygon points
            ;
            <path> path movements
            relative? end-point
            <move-to> move-to
            <line-to> line-to
            <quadratic-to> quadratic-to control-point
            <cubic-to> cubic-to 1st-control-point 2nd-control-point
            <smooth-quadratic-to> smooth-quadratic-to
            <smooth-cubic-to> smooth-cubic-to
            <arc-to> arc-to radius-point x-axis-rotation large-arc? sweep?
            <close-path> close-path
           )
  #:re-export (<container-type> <content-type>
               id name-class style contents empty?
               attribute->sxml-attribute
              )
)

;;;;
;; Style of shapes
(define-class <shape-style> (<object>)
  (fill-color #:getter fill-color #:init-keyword #:fill-color #:init-value #f)
  (stroke-color #:getter stroke-color #:init-keyword #:stroke-color #:init-value #f)
  (stroke-width #:getter stroke-width #:init-keyword #:stroke-width #:init-value #f)
  (font-size #:getter font-size #:init-keyword #:font-size #:init-value #f)
  (font-family #:getter font-family #:init-keyword #:font-family #:init-value #f)
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
(define-method (font-size (size <number>))
  (make <shape-style> #:font-size size))

;;;;
;; Point
(define-class <point> (<object>)
  (x #:accessor x #:init-keyword #:x #:init-form 0)
  (y #:accessor y #:init-keyword #:y #:init-form 0)
)

(define-method (point (xx <number>) (yy <number>))
  (make <point> #:x xx #:y yy))

;;;;
;; Vector Image
(define-class <vector-image> (<container-type>)
  (width #:getter width #:init-keyword #:width #:init-form 0)
  (height #:getter height #:init-keyword #:height #:init-form 0))

(container-type-constructor vector-image <vector-image>)

;;;;
;; Script elements.
;; Container of strings - source code
(define-class <script> (<container-type> <content-type>))
(container-type-constructor script <script>)

;;;;
;; Vector content type: add scriptable attributes
(define-class <vectorgraphics-content-type> (<content-type>)
  (on-focus-in #:getter on-focus-in #:init-keyword #:on-focus-in #:init-form #f)
  (on-focus-out #:getter on-focus-out #:init-keyword #:on-focus-out #:init-form #f)
  (on-activate #:getter on-activate #:init-keyword #:on-activate #:init-form #f)
  (on-click #:getter on-click #:init-keyword #:on-click #:init-form #f)
  (on-mouse-down #:getter on-mouse-down #:init-keyword #:on-mouse-down #:init-form #f)
  (on-mouse-up #:getter on-mouse-up #:init-keyword #:on-mouse-up #:init-form #f)
  (on-mouse-over #:getter on-mouse-over #:init-keyword #:on-mouse-over #:init-form #f)
  (on-mouse-move #:getter on-mouse-move #:init-keyword #:on-mouse-move #:init-form #f)
  (on-mouse-out #:getter on-mouse-out #:init-keyword #:on-mouse-out #:init-form #f))

;;;;
;; Area
(define-class <area> (<container-type> <vectorgraphics-content-type>)
  (transforms #:getter transforms #:init-keyword #:transforms #:init-form (list)))

(container-type-constructor area <area>)

;;;;
;; Transform-type
(define-class <transform-type> (<object>))

;;;;
;; Translation
(define-class <translation> (<transform-type>)
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
(define-class <rotation> (<transform-type>)
  (rotation-angle #:getter rotation-angle #:init-keyword #:rotation-angle #:init-form 0)
  (center #:getter center #:init-keyword #:center #:init-form #f))

(define-method (rotation (ang <number>))
  (make <rotation> #:rotation-angle ang))
(define-method (rotation (ang <number>) (center <point>))
  (make <rotation> #:center center #:rotation-angle ang))

;;;;
;; Text
;; Container of strings
(define-class <text> (<container-type> <vectorgraphics-content-type>)
  (topleft #:getter topleft #:init-keyword #:topleft #:init-form (point 0 0)))

(container-type-constructor text <text>)

;;;;
;; Circle
(define-class <circle> (<vectorgraphics-content-type>)
  (center #:accessor center #:init-keyword #:center #:init-form (point 0 0))
  (radius #:accessor radius #:init-keyword #:radius #:init-form 0)
)

(content-type-constructor circle <circle>)

;;;;
;; Rectangle
(define-class <rectangle> (<vectorgraphics-content-type>)
  (width #:accessor width #:init-keyword #:width #:init-form 0.)
  (height #:accessor height #:init-keyword #:height #:init-form 0.)
  (topleft #:accessor topleft #:init-keyword #:topleft #:init-form (point 0 0))
)

(content-type-constructor rectangle <rectangle>)

;;;;
;; Polygon
(define-class <polygon> (<vectorgraphics-content-type>)
  (points #:accessor points #:init-keyword #:points #:init-form (list))
)

(content-type-constructor polygon <polygon>)

;;;;
;; Path
(define-class <path> (<vectorgraphics-content-type>)
  (movements #:accessor movements #:init-keyword #:movements #:init-form (list)))

(content-type-constructor path <path>)

;;;;
;; Path movements
(define-class <path-movement> (<object>)
  (relative? #:getter relative? #:init-keyword #:relative? #:init-form #f)
  (end-point #:getter end-point #:init-keyword #:end-point #:init-form (point 0 0)))

;; Move to
(define-class <move-to> (<path-movement>))

(define-method (move-to (end-point <point>))
  (make <move-to> #:end-point end-point))

(define-method (move-to (end-point <point>) (relative? <boolean>))
  (make <move-to> #:end-point end-point #:relative? relative?))

;; Line to
(define-class <line-to> (<path-movement>))

(define-method (line-to (end-point <point>))
  (make <line-to> #:end-point end-point))

(define-method (line-to (end-point <point>) (relative? <boolean>))
  (make <line-to> #:end-point end-point #:relative? relative?))

;; Curve to
(define-class <curve-to> (<path-movement>))

;; Quadratic curve
(define-class <quadratic-to> (<curve-to>)
  (control-point #:getter control-point #:init-keyword #:control-point #:init-form (point 0 0)))

(define-method (quadratic-to (control-point <point>) (end-point <point>))
  (make <quadratic-to> #:control-point control-point #:end-point end-point))

(define-method (quadratic-to (control-point <point>) (end-point <point>) (relative? <boolean>))
  (make <quadratic-to> #:control-point control-point #:end-point end-point #:relative? relative?))

;; Cubic curve
(define-class <cubic-to> (<curve-to>)
  (1st-control-point #:getter 1st-control-point #:init-keyword #:1st-control-point #:init-form (point 0 0))
  (2nd-control-point #:getter 2nd-control-point #:init-keyword #:2nd-control-point #:init-form (point 0 0)))

(define-method (cubic-to (1st-control-point <point>) (2nd-control-point <point>) (end-point <point>))
  (make <cubic-to>
        #:1st-control-point 1st-control-point
        #:2nd-control-point 2nd-control-point
        #:end-point end-point))

(define-method (cubic-to (1st-control-point <point>) (2nd-control-point <point>)
                         (end-point <point>) (relative? <boolean>))
  (make <cubic-to>
        #:1st-control-point 1st-control-point
        #:2nd-control-point 2nd-control-point
        #:end-point end-point
        #:relative? relative?))

;; Smooth quadratic curve
(define-class <smooth-quadratic-to> (<curve-to>))

(define-method (smooth-quadratic-to (end-point <point>))
  (make <smooth-quadratic-to> #:end-point end-point))

(define-method (smooth-quadratic-to (end-point <point>) (relative? <boolean>))
  (make <smooth-quadratic-to> #:end-point end-point #:relative? relative?))

;; Smooth cubic curve
(define-class <smooth-cubic-to> (<curve-to>)
  (control-point #:getter control-point #:init-keyword #:control-point #:init-form (point 0 0)))

(define-method (smooth-cubic-to (control-point <point>) (end-point <point>))
  (make <smooth-cubic-to> #:control-point control-point #:end-point end-point))

(define-method (smooth-cubic-to (control-point <point>) (end-point <point>) (relative? <boolean>))
  (make <smooth-cubic-to> #:control-point control-point #:end-point end-point #:relative? relative?))

;; Arc to
(define-class <arc-to> (<path-movement>)
  (radius-point #:getter radius-point #:init-keyword #:radius-point #:init-form (point 0 0))
  (x-axis-rotation #:getter x-axis-rotation #:init-keyword #:x-axis-rotation #:init-form 0)
  (large-arc? #:getter large-arc? #:init-keyword #:large-arc? #:init-form #f)
  (sweep? #:getter sweep? #:init-keyword #:sweep? #:init-form #f))

(define-method (arc-to (radius-point <point>) (x-axis-rotation <number>) (large-arc? <boolean>)
                       (sweep? <boolean>) (end-point <point>))
  (make <arc-to>
        #:radius-point radius-point
        #:x-axis-rotation x-axis-rotation
        #:large-arc? large-arc?
        #:sweep? sweep?
        #:end-point end-point))

(define-method (arc-to (radius-point <point>) (x-axis-rotation <number>) (large-arc? <boolean>)
                       (sweep? <boolean>) (end-point <point>) (relative? <boolean>))
  (make <arc-to>
        #:radius-point radius-point
        #:x-axis-rotation x-axis-rotation
        #:large-arc? large-arc?
        #:sweep? sweep?
        #:end-point end-point
        #:relative? relative?))

;; Close path
(define-class <close-path> (<path-movement>))

(define-method (close-path)
  (make <close-path>))
