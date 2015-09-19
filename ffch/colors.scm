;; Colors
(define-module (ffch colors)
  #:version (0 0 1)
  #:use-module (oop goops)
  #:export (<color>
            css-value
            transparent-color
            no-color
            rgb-color rgba-color
            hsl-color hsla-color
            named-color
           )
)

;; Base class
(define-class <color> (<object>))

;; Method to retrieve color as css. It must be redefined for each type of color
(define-method (css-value (col <color>))
  "transparent")

;; Transparent color : the base class is the transparent color, use it
(define-method (transparent-color)
  (make <color>))

;; No color
(define-class <no-color> (<color>))

(define-method (no-color)
  (make <no-color>))

(define-method (css-value (col <no-color>))
  "none")

;; RGB color
(define-class <rgb-color> (<color>)
  (R #:getter R #:init-keyword #:R #:init-form 0)
  (G #:getter G #:init-keyword #:G #:init-form 0)
  (B #:getter B #:init-keyword #:B #:init-form 0))

(define-method (rgb-color (r <integer>) (g <integer>) (b <integer>))
  (make <rgb-color> #:R r #:G g #:B b))

(define-method (css-value (col <rgb-color>))
  (string-append
    "rgb("
    (number->string (R col)) ","
    (number->string (G col)) ","
    (number->string (B col)) ")"))

;; RGBA color
(define-class <rgba-color> (<rgb-color>)
  (A #:getter A #:init-keyword #:A #:init-form 0.0))

(define-method (rgba-color (r <integer>) (g <integer>) (b <integer>) (a <real>))
  (make <rgba-color> #:R r #:G g #:B b #:A a))

(define-method (css-value (col <rgba-color>))
  (string-append
    "rgba("
    (number->string (R col)) ","
    (number->string (G col)) ","
    (number->string (B col)) ","
    (number->string (A col)) ")"))

;; HSL color
(define-class <hsl-color> (<color>)
  (H #:getter H #:init-keyword #:H #:init-form 0)  ;; 0-360
  (S #:getter S #:init-keyword #:S #:init-form 0)  ;; 0-100
  (L #:getter L #:init-keyword #:L #:init-form 0)) ;; 0-100

(define-method (hsl-color (h <integer>) (s <integer>) (l <integer>))
  (make <hsl-color> #:H h #:S s #:L l))

(define-method (css-value (col <hsl-color>))
  (string-append
    "hsl("
    (number->string (H col)) ","
    (number->string (S col)) "%,"
    (number->string (L col)) "%)"))

;; HSLA color
(define-class <hsla-color> (<hsl-color>)
  (A #:getter A #:init-keyword #:A #:init-form 0.0))

(define-method (hsla-color (h <integer>) (s <integer>) (l <integer>) (a <real>))
  (make <hsl-color> #:H h #:S s #:L l #:A a))

(define-method (css-value (col <hsla-color>))
  (string-append
    "hsl("
    (number->string (H col)) ","
    (number->string (S col)) "%,"
    (number->string (L col)) "%,"
    (number->string (A col)) ")"))

;; Named color
(define-class <named-color> (<color>)
  (name #:getter name #:init-keyword #:name #:init-form #:transparent)) ;; keyword

(define-method (named-color (n <keyword>))
  (make <named-color> #:name n))

(define-method (css-value (col <named-color>))
  (symbol->string (keyword->symbol (name col))))
