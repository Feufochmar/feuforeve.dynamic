;; Flag generator
(define-module (flag-generator flag-generator)
  #:version (0 0 1)
  #:use-module (oop goops)
  #:use-module (sxml simple)
  #:use-module (ffch random)
  #:use-module (ffch colors)
  #:use-module (ffch vectorgraphics)
  #:use-module (ffch vectorgraphics-exporters sxml-svg)
  #:use-module (flag-generator palette)
  #:use-module (flag-generator charges)
  #:export (generate-flag
           )
)

;;;;
;; Divisions

;; Plain
(define-method (division:plain (width <number>) (height <number>))
  (let* ((palette (pick-palette 1))
         (metal-field? (pick-boolean))
         (field-color ((if metal-field? metal-ref tincture-ref) palette 0))
         (charge-color ((if metal-field? tincture-ref metal-ref) palette 0)))
    (area
      (rectangle (width width) (height height)
                 (style-class (fill-color field-color)))
      (if (< 0 (random 20))
          (charge width height charge-color field-color)
          (area)))))

;; Per fess : Bicolor horizontal / Per pale : Bicolor vertical
;; The two patterns are merged in construction as they work in the same way
(define-method (division:per-fess-or-pale (width <number>) (height <number>))
  (let* ((palette (pick-palette 2))
         (fess? (pick-boolean))
         (wp (if fess? width (/ width 2)))
         (hp (if fess? (/ height 2) height))
         (metal-chief? (pick-boolean))
         (metal-base? (pick-boolean))
         (field-color-chief ((if metal-chief? metal-ref tincture-ref) palette 0))
         (field-color-base ((if metal-base? metal-ref tincture-ref) palette 1))
         (charge-position
           (pick-from
             (append
               (list #:none #:none #:chief #:base #:chief-base)
               (if (eq? metal-chief? metal-base?) (make-list 3 #:overlay) (list)))))
         (color-complement? (not (eq? metal-chief? metal-base?)))
         (charge-color-chief
           (if (and color-complement? (pick-boolean))
               field-color-base
               ((if metal-chief? tincture-ref metal-ref) palette 0)))
         (charge-color-base
           (if (and color-complement? (pick-boolean))
               field-color-chief
               ((if metal-chief? tincture-ref metal-ref) palette 1)))
        )
    (area
      (rectangle (width width) (height height)
                 (style-class (fill-color field-color-base)))
      (rectangle (width wp) (height hp)
                 (style-class (fill-color field-color-chief)))
      (cond
       ((eq? charge-position #:chief)
        (charge wp hp charge-color-chief field-color-chief))
       ((eq? charge-position #:base)
        (area ((transforms (list (translation (if fess? (point 0 hp) (point wp 0))))))
          (charge wp hp charge-color-base field-color-base)))
       ((eq? charge-position #:chief-base)
        (area
          (charge wp hp charge-color-chief field-color-chief)
          (area ((transforms (list (translation (if fess? (point 0 hp) (point wp 0))))))
            (charge wp hp charge-color-base field-color-base))))
       ((eq? charge-position #:overlay)
        (charge width height
                (if (pick-boolean) charge-color-chief charge-color-base)
                (if (pick-boolean) field-color-chief field-color-base)))
       (#t (area))))))

;; Tierced per fess / per pale : tricolor horizontal / vertical
(define-method (division:tierced-per-fess-or-pale (width <number>) (height <number>))
  (let* ((palette (pick-palette 3))
         (fess? (pick-boolean))
         (wp (if fess? width (/ width 3)))
         (hp (if fess? (/ height 3) height))
         (metal-chief? (pick-boolean))
         (metal-middle? (pick-boolean))
         (metal-base? (pick-boolean))
         (field-color-chief ((if metal-chief? metal-ref tincture-ref) palette 0))
         (charge-color-chief ((if metal-chief? tincture-ref metal-ref) palette 0))
         (field-color-middle ((if metal-middle? metal-ref tincture-ref) palette 1))
         (charge-color-middle ((if metal-middle? tincture-ref metal-ref) palette 1))
         (field-color-base ((if metal-base? metal-ref tincture-ref) palette 2))
         (charge-color-base ((if metal-base? tincture-ref metal-ref) palette 2))
         (charge-position
           (pick-from
             (append (list #:none #:none #:chief #:middle #:base #:chief-base)
                     (if (and (eq? metal-chief? metal-middle?) (eq? metal-middle? metal-base?))
                         (make-list 3 #:overlay)
                         (list))
                     (if (eq? metal-chief? metal-middle?)
                         (make-list 3 #:overlay-chief-middle)
                         (list))
                     (if (eq? metal-middle? metal-base?)
                         (make-list 3 #:overlay-middle-base)
                         (list))
             )))
        )
    (area
      (rectangle (width width) (height height)
                 (style-class (fill-color field-color-base)))
      (rectangle (width (if fess? width (* 2 wp))) (height (if fess? (* 2 hp) height))
                 (style-class (fill-color field-color-middle)))
      (rectangle (width (if fess? width wp)) (height (if fess? hp height))
                 (style-class (fill-color field-color-chief)))
      (cond
       ((eq? charge-position #:chief)
        (charge wp hp
          (cond
           ((and (not (eq? metal-chief? metal-middle?)) (pick-boolean))
            field-color-middle)
           ((and (not (eq? metal-chief? metal-base?)) (pick-boolean))
            field-color-base)
           (#t charge-color-chief))
          field-color-chief))
       ((eq? charge-position #:middle)
        (area ((transforms (list (translation (if fess? (point 0 hp) (point wp 0))))))
          (charge wp hp
            (cond
             ((and (not (eq? metal-middle? metal-chief?)) (pick-boolean))
              field-color-chief)
             ((and (not (eq? metal-middle? metal-base?)) (pick-boolean))
              field-color-base)
             (#t charge-color-middle))
            field-color-middle)))
       ((eq? charge-position #:base)
        (area ((transforms (list (translation (if fess? (point 0 (* 2 hp)) (point (* 2 wp) 0))))))
          (charge wp hp
            (cond
             ((and (not (eq? metal-base? metal-chief?)) (pick-boolean))
              field-color-chief)
             ((and (not (eq? metal-base? metal-middle?)) (pick-boolean))
              field-color-middle)
             (#t charge-color-base))
            field-color-base)))
       ((eq? charge-position #:chief-base)
        (let* ((charge-tints
                 (cond
                  ((and (not (eq? metal-chief? metal-base?)) (pick-boolean))
                   (cons field-color-base field-color-chief))
                  ((and (eq? metal-chief? metal-base?) (not (eq? metal-base? metal-middle?)) (pick-boolean))
                   (cons field-color-middle field-color-middle))
                  (#t (cons charge-color-chief charge-color-base))
                 ))
               (charge-tint-chief (car charge-tints))
               (charge-tint-base (cdr charge-tints)))
          (area
            (charge wp hp charge-tint-chief field-color-chief)
            (area ((transforms (list (translation (if fess? (point 0 (* 2 hp)) (point (* 2 wp) 0))))))
              (charge wp hp charge-tint-base field-color-base)))))
       ((eq? charge-position #:overlay)
        (charge width height
          (pick-from (vector charge-color-chief charge-color-middle charge-color-base))
          (pick-from (vector field-color-chief field-color-middle field-color-base))))
       ((eq? charge-position #:overlay-chief-middle)
        (charge (if fess? width (* 2 wp)) (if fess? (* 2 hp) height)
          (pick-from
            (vector
              charge-color-chief charge-color-middle
              (if (eq? metal-chief? metal-base?) charge-color-base field-color-base)))
          (pick-from
            (vector
              field-color-chief field-color-middle
              (if (eq? metal-chief? metal-base?) field-color-base charge-color-base)))))
       ((eq? charge-position #:overlay-middle-base)
        (area ((transforms (list (translation (if fess? (point 0 hp) (point wp 0))))))
          (charge (if fess? width (* 2 wp)) (if fess? (* 2 hp) height)
            (pick-from
              (vector
                charge-color-base charge-color-middle
                (if (eq? metal-chief? metal-base?) charge-color-chief field-color-chief)))
            (pick-from
              (vector
                field-color-base field-color-middle
                (if (eq? metal-chief? metal-base?) field-color-chief charge-color-chief))))))
       (#t (area))))))

;; Canton (Charge)
(define-method (charge-canton (width <number>) (height <number>))
  ((pick-from
     (vector division:plain division:per-fess-or-pale division:tierced-per-fess-or-pale))
   width height))

;; Canton
(define-method (division:canton (width <number>) (height <number>))
  (let* ((palette (pick-palette 1))
         (metal? (pick-boolean))
         (field-color ((if metal? metal-ref tincture-ref) palette 0))
         ;(charge-color ((if metal? tincture-ref metal-ref) palette 0))
         (canton-height (pick-from (vector (/ height 2) (/ height 3))))
         (ratio (pick-from (vector 1 3/2 2 (/ width height))))
         (canton-width (* ratio canton-height))
         (position
           (pick-from
             (vector (point 0 0) (point (- width canton-width) 0)
                     (point 0 (- height canton-height)) (point (- width canton-width) (- height canton-height))
             )))
        )
    (area
      (rectangle (width width) (height height)
                 (style-class (fill-color field-color)))
      (area ((transforms (list (translation position))))
        (charge-canton canton-width canton-height)))))

;; Horizontal stripes
(define-method (division:horizontal-stripes (width <number>) (height <number>))
  (let* ((palette (pick-palette 2))
         (nb-charge-stripes (+ 1 (random 6)))
         (overlay (pick-from (vector #:none #:canton #:pairle #:pale)))
         (metal-field? (pick-boolean))
         (metal-overlay? (pick-boolean))
         (overlay-same-palette? (pick-boolean))
         (color-field ((if metal-field? metal-ref tincture-ref) palette 0))
         (color-charge ((if metal-field? tincture-ref metal-ref) palette 0))
         (color-field-overlay ((if metal-overlay? metal-ref tincture-ref) palette (if overlay-same-palette? 0 1)))
         (color-charge-overlay ((if metal-overlay? tincture-ref metal-ref) palette (if overlay-same-palette? 0 1)))
         (stripe-height (/ height (+ 1 (* 2 nb-charge-stripes))))
        )
    (area
      (rectangle (width width) (height height)
                 (style-class (fill-color color-field)))
      (map
        (lambda (x)
          (rectangle (width width) (height stripe-height)
                     (topleft (point 0 (* stripe-height (+ 1 (* 2 x)))))
                     (style-class (fill-color color-charge))))
        (letrec ((helper (lambda (lst i n) (if (>= i n) lst (helper (cons i lst) (+ i 1) n)))))
          (helper (list) 0 nb-charge-stripes)))
      (cond
       ((eq? overlay #:canton)
        (let* ((canton-height (* (+ nb-charge-stripes (random 2)) stripe-height))
               (ratio (pick-from (vector 1 3/2 2)))
               (canton-width (* ratio canton-height))
               (position
                      (pick-from
                        (vector (point 0 0) (point (- width canton-width) 0)
                                (point 0 (- height canton-height))
                                (point (- width canton-width) (- height canton-height))
                        ))))
          (area ((transforms (list (translation position))))
            (charge-canton canton-width canton-height))))
       ((eq? overlay #:pairle)
        (let* ((l (* width (pick-from (vector 1 1/2 1/3))))
               (dexter? (pick-boolean))
               (A (point (if dexter? 0 width) 0))
               (B (point (if dexter? 0 width) height))
               (C (point (if dexter? l (- width l)) (/ height 2)))
              )
          (area
            (polygon (points (list A B C)) (style-class (fill-color color-field-overlay)))
            (if (pick-boolean)
                (area)
                (let* ((e 0.1)
                       (r (/ (* l height (- 1 e)) (+ l height))))
                  (area ((transforms
                           (list
                             (translation
                               (point (if dexter? (* e l) (- width r (* e l))) (- (/ height 2) (/ r 2)))))))
                    (small-charge r r color-charge-overlay)))))))
       ((eq? overlay #:pale)
        (let ((topleft (point (if (pick-boolean) 0 (* width 2/3)) 0)))
          (area
            (rectangle (width (/ width 3)) (height height)
                       (topleft topleft)
                       (style-class (fill-color color-field-overlay)))
            (if (pick-boolean)
                (area)
                (area ((transforms (list (translation topleft))))
                  (charge (/ width 3) height color-charge-overlay color-field-overlay))))))
       (#t (area)))
    )))

;; Field division method
(define-method (field-division (width <number>) (height <number>))
  ((pick-from
     (vector
       division:plain division:plain division:plain division:plain division:plain division:plain
       division:per-fess-or-pale division:per-fess-or-pale division:per-fess-or-pale
       division:tierced-per-fess-or-pale division:tierced-per-fess-or-pale
       division:canton division:horizontal-stripes
      ))
   width height))

;; Flag generator method
(define-method (generate-flag (flag-width <number>) (port <port>))
  (let ((flag-height (* flag-width (pick-from (list 1/2 2/3)))))
    (sxml->xml
      (vectorgraphics->sxml-svg
        (vector-image ((width flag-width)(height flag-height))
          (field-division flag-width flag-height)
        )
      )
      port
    )))
