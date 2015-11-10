;; Floraverse character generator
;; Color palette generator
(define-module (flora-character-generator palette)
  #:version (0 0 1)
  #:use-module (oop goops)
  #:use-module (ffch random)
  #:use-module (ffch colors)
  #:use-module (flora-character-generator elements)
  #:use-module (flora-character-generator species)
  #:export (pick-palette)
  #:duplicates (merge-generics))

;; Algorithm must return a list
(define-method (pick-palette (element <element>) (species <species>))
  (let ((first-hue (pick-main-hue element))
        (algorithm (pick-from
                     (vector
                       palette-gradient
                       palette-analog-complementary palette-analog-complementary
                       palette-analog-complementary palette-analog-complementary
                     )))
       )
    (algorithm
      (hsl-color
        first-hue
          (+ 65 (random 30))
          (+ 60 (random 20))))))

(define (flerp a b t)
  (inexact->exact (floor (+ a (* t (- b a))))))

(define (color-lerp a b t direct?)
  (hsl-color
    (modulo
      (+ 360
         (floor
           (if direct?
               (flerp (H a) (H b) t)
               (flerp (H b) (H a) (- 1 t)))))
      360)
    (flerp (S a) (S b) t)
    (flerp (L a) (L b) t)))

(define (palette-gradient initial-color)
  (let ((direct-hue? (pick-boolean))
        (opposite-color
          (hsl-color
            (modulo (+ 180 (H initial-color)) 360)
            (- 100 (S initial-color))
            (- 100 (L initial-color))))
       )
    (list
      initial-color
      (color-lerp initial-color opposite-color 1/4 direct-hue?)
      (color-lerp initial-color opposite-color 1/2 direct-hue?)
      (color-lerp initial-color opposite-color 3/4 direct-hue?)
      opposite-color)))

(define (pick-analog-value sl)
  (let ((a (+ 50 (/ sl 2)))
        (b (- (* 3 (/ sl 2)) 50)))
    (flerp
      (max 50 (min a b))
      (min 90 (max a b))
      (random 1.0))))

(define (pick-complementary-value sl)
  (let ((a (/ sl 4))
        (b (* 3 (/ sl 4))))
    (flerp
      (max 25 a)
      (min 50 b)
      (random 1.0))))

(define (palette-analog-complementary initial-color)
  (let ((analog-distance (+ 20 (random 25))))
    (list
      initial-color
      (hsl-color
        (modulo (+ (H initial-color) 360 analog-distance) 360)
        (pick-analog-value (S initial-color))
        (pick-analog-value (L initial-color)))
      (hsl-color
        (modulo (+ (H initial-color) 360 (- 0 analog-distance)) 360)
        (pick-analog-value (S initial-color))
        (pick-analog-value (L initial-color)))
      (let ((sl-picker (pick-from (vector pick-analog-value pick-complementary-value))))
        (hsl-color
          (modulo (+ (H initial-color) 180 (floor (/ analog-distance 2))) 360)
          (sl-picker (S initial-color))
          (sl-picker (L initial-color))))
      (let ((sl-picker (pick-from (vector pick-analog-value pick-complementary-value))))
        (hsl-color
          (modulo (+ (H initial-color) 180 (floor (/ analog-distance -2))) 360)
          (sl-picker (S initial-color))
          (sl-picker (L initial-color)))))))
