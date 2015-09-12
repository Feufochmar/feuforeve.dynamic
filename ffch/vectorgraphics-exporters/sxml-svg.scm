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
    (if (font-size stl)
        (string-append "font-size:" (show (font-size stl)) ";")
        "")
    (if (font-family stl)
        (string-append "font-family:" (show (font-family stl)) ";")
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

;; List : act as a container
(define-method (vectorgraphics->sxml-svg (cnt <list>))
  (map
    vectorgraphics->sxml-svg
    cnt))

;; String is outputed as is
(define-method (vectorgraphics->sxml-svg (cnt <string>))
  cnt)

;;;;
;; Generic contents
(define-method (attributes-of (cnt <content-type>))
  (append
    (attribute->sxml-attribute cnt id)
    (attribute->sxml-attribute cnt name-class 'class)
    (if (style cnt)
        (let ((stl (show (style cnt))))
          (if (string-null? stl)
              (list)
              (list (list 'style stl))
          ))
        (list))
  ))

(define-method (attributes-of (cnt <vectorgraphics-content-type>))
  (append
    (next-method)
    (attribute->sxml-attribute cnt on-focus-in 'onfocusin)
    (attribute->sxml-attribute cnt on-focus-out 'onfocusout)
    (attribute->sxml-attribute cnt on-activate 'onactivate)
    (attribute->sxml-attribute cnt on-click 'onclick)
    (attribute->sxml-attribute cnt on-mouse-down 'onmousedown)
    (attribute->sxml-attribute cnt on-mouse-up 'onmouseup)
    (attribute->sxml-attribute cnt on-mouse-over 'onmouseover)
    (attribute->sxml-attribute cnt on-mouse-move 'onmousemove)
    (attribute->sxml-attribute cnt on-mouse-out 'onmouseout)
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
;; Script
(define-method (vectorgraphics->sxml-svg (cnt <script>))
  (list 'script
    "// <![CDATA["
    (next-method)
    "// ]]>"))

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
  (if (empty? cnt)
    ""
    (list 'g
      (append (list '@) (attributes-of cnt))
      (next-method)
    )))

;;;;
;; Text
(define-method (attributes-of (cnt <text>))
  (append
    (list
      (list 'x (show (x (topleft cnt))))
      (list 'y (show (y (topleft cnt))))
    )
    (next-method)
  ))

(define-method (vectorgraphics->sxml-svg (cnt <text>))
  (if (empty? cnt)
    ""
    (list 'text
      (append (list '@) (attributes-of cnt))
      (next-method)
    )))

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

;; Path

;; Path movement to string
(define-method (show (movement <move-to>))
  (string-append
    (if (relative? movement) "m" "M") " "
    (show (end-point movement))))

(define-method (show (movement <line-to>))
  (string-append
    (if (relative? movement) "l" "L") " "
    (show (end-point movement))))

(define-method (show (movement <quadratic-to>))
  (string-append
    (if (relative? movement) "q" "Q") " "
    (show (control-point movement)) " "
    (show (end-point movement))))

(define-method (show (movement <cubic-to>))
  (string-append
    (if (relative? movement) "c" "C") " "
    (show (1st-control-point movement)) " "
    (show (2nd-control-point movement)) " "
    (show (end-point movement))))

(define-method (show (movement <smooth-quadratic-to>))
  (string-append
    (if (relative? movement) "t" "T") " "
    (show (end-point movement))))

(define-method (show (movement <smooth-cubic-to>))
  (string-append
    (if (relative? movement) "s" "S") " "
    (show (control-point movement)) " "
    (show (end-point movement))))

(define-method (show (movement <arc-to>))
  (string-append
    (if (relative? movement) "a" "A") " "
    (show (radius-point movement)) " "
    (show (x-axis-rotation movement)) " "
    (if (large-arc? movement) "1" "0") " "
    (if (sweep? movement) "1" "0") " "
    (show (end-point movement))))

(define-method (show (movement <close-path>))
  "Z")

(define-method (attributes-of (cnt <path>))
  (append
    (list
      (list 'd (string-join (map show (movements cnt)) " "))
    )
    (next-method)
  ))

(define-method (vectorgraphics->sxml-svg (cnt <path>))
  (list 'path (append (list '@) (attributes-of cnt))))
