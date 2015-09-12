;; Charges for flags
(define-module (flag-generator charges)
  #:version (0 0 1)
  #:use-module (oop goops)
  #:use-module (ffch colors)
  #:use-module (ffch vectorgraphics)
  #:use-module (ffch random)
  #:export (small-charge charge
           )
)

;;;;
;; Small charges

;; Circle
(define-method (small-charge:circle (width <number>) (height <number>) (col <color>))
  (let ((r (/ (min width height) 2)))
    (circle
      (center (point (/ width 2) (/ height 2)))
      (radius r)
      (style (fill-color col))
    )))

;; Star
(define-method (star-builder (nb-points <integer>) (ratio <number>) (rotate <number>)
                             (width <number>) (height <number>) (col <color>))
  (letrec*
    ((radius-major (/ (min width height) 2))
     (pi (* 4 (atan 1)))
     (a (/ pi nb-points))
     (radius-minor (* ratio radius-major))
     (on-circle
       (lambda (r i)
         (point (+ (/ width 2) (* r (cos (+ rotate (* a i)))))
                (+ (/ height 2) (* r (sin (+ rotate (* a i)))))
         )))
     (add-points
       (lambda (lst-points i n)
         (if (>= i n)
             lst-points
             (add-points
               (append
                 (list
                   (on-circle radius-minor (+ 1 i))
                   (on-circle radius-major i))
                 lst-points)
               (+ 2 i)
               n)
         )))
    )
    (polygon
      (points (add-points (list) 0 (* 2 nb-points)))
      (style (fill-color col)))
  ))

(define-method (small-charge:star-maker (nb-points <integer>))
  (let*
    ((pi (* 4 (atan 1)))
     (a (/ pi nb-points))
     (rotate (pick-from (vector 0 (/ pi 2) pi (* pi 3/2))))
     (ratio
       (cond
        ((eq? 3 nb-points) 1/3)
        ((and (not (eq? 4 nb-points)) (pick-boolean))
         (/ (sqrt (+ 1 (expt (tan a) 2)))
            (+ 1 (* (tan a) (tan (* 2 a))))))
        (#t (/ 1 (+ 1 (* 2 (cos a)))))
       )))
    (lambda (w h col)
      (star-builder nb-points ratio rotate w h col))
  ))

;; Greek cross
(define-method (small-charge:greek-cross (width <number>) (height <number>) (col <color>))
  (let* ((cross-size (min width height))
         (cross-width (/ cross-size 3))
        )
    (area
      (rectangle (width cross-width) (height cross-size)
                 (topleft (point (/ (- width cross-width) 2) (/ (- height cross-size) 2)))
                 (style (fill-color col)))
      (rectangle (width cross-size) (height cross-width)
                 (topleft (point (/ (- width cross-size) 2) (/ (- height cross-width) 2)))
                 (style (fill-color col)))
    )))

;; St. Andrew cross / small Saltire
(define-method (small-charge:andrew-cross (w <number>) (h <number>) (col <color>))
  (let* ((cross-size (min w h))
         (r (/ cross-size 4))
         (offset-x (/ (- w cross-size) 2))
         (offset-y (/ (- h cross-size) 2))
        )
    (polygon
      (points
        (list (point (+ r offset-x) offset-y) (point (/ w 2) (+ offset-y r))
              (point (+ (/ w 2) r) offset-y) (point (+ cross-size offset-x) (+ offset-y r))
              (point (+ (/ w 2) r) (/ h 2)) (point (+ cross-size offset-x) (+ (/ h 2) r))
              (point (+ (/ w 2) r) (+ cross-size offset-y)) (point (/ w 2) (+ (/ h 2) r))
              (point (+ r offset-x) (+ cross-size offset-y)) (point offset-x (+ (/ h 2) r))
              (point (+ r offset-x) (/ h 2)) (point offset-x (+ offset-y r))
        ))
      (style (fill-color col)))
  ))

;; Crescent
;; Crescent is 33 width, 40 height
;; An area is use to scale it to the right size and rotate it
(define-method (small-charge:crescent (w <number>) (h <number>) (col <color>))
  (let* ((area-scaling (min (/ w 40) (/ h 40)))
         (area-rotation (pick-from (vector 0 45 90 135 180 225 270 315)))
         (area-translation (point (/ (- w (* 40 area-scaling)) 2) (/ (- h (* 40 area-scaling)) 2)))
        )
    (area ((transforms (list (translation area-translation)
                             (scaling area-scaling)
                             (rotation area-rotation (point 20 20))
                             (translation (point 3.5 0)))))
      (path
        (style (fill-color col))
        (movements
          (list
            (move-to (point 33 5))
            (arc-to (point 20 20) 0 #t #f (point 33 35))
            (arc-to (point 16 16) 0 #t #t (point 33 5))
            (close-path)))))))

;; Pick a small charge
(define-method (small-charge (width <number>) (height <number>) (col <color>))
  ((pick-from
     (vector
       small-charge:circle small-charge:greek-cross small-charge:andrew-cross
       (small-charge:star-maker 3) (small-charge:star-maker 4) (small-charge:star-maker 5)
       (small-charge:star-maker 6) (small-charge:star-maker 7) (small-charge:star-maker 8)
       (small-charge:star-maker 9) (small-charge:star-maker 10) (small-charge:star-maker 11)
       (small-charge:star-maker 12)
       small-charge:crescent
     ))
   width height col))

;;;;
;; Large charges

;; Cross
(define-method (large-charge:cross (width <number>) (height <number>)
                                   (charge-color <color>) (field-color <color>))
  (let ((cross-width (* 0.2 (min width height))))
    (area
      (rectangle (width cross-width) (height height)
                 (topleft (point (/ (- width cross-width) 2) 0))
                 (style (fill-color charge-color)))
      (rectangle (width width) (height cross-width)
                 (topleft (point 0 (/ (- height cross-width) 2)))
                 (style (fill-color charge-color)))
      (if (pick-boolean)
          (area)
          (let ((variation
                  (pick-from
                    (vector #:inner-cross #:small-inner-charge #:big-inner-charge #:symmetric-outer-charges))))
            (cond
             ((eq? variation #:inner-cross)
              (let ((inner-cross-width (/ cross-width 3)))
                (area
                  (rectangle (width inner-cross-width) (height height)
                             (topleft (point (/ (- width inner-cross-width) 2) 0))
                             (style (fill-color field-color)))
                  (rectangle (width width) (height inner-cross-width)
                             (topleft (point 0 (/ (- height inner-cross-width) 2)))
                             (style (fill-color field-color))))))
             ((eq? variation #:small-inner-charge)
              (area
                ((transforms (list (translation (point (/ (- width cross-width) 2) (/ (- height cross-width) 2))))))
                (small-charge cross-width cross-width field-color)))
             ((eq? variation #:big-inner-charge)
              (let ((size-rect (* cross-width 2.5))
                    (size-bonus (* cross-width 2)))
                (area
                  (rectangle (width size-rect) (height size-rect)
                             (topleft (point (/ (- width size-rect) 2) (/ (- height size-rect) 2)))
                             (style (fill-color charge-color)))
                  (area
                    ((transforms (list (translation (point (/ (- width size-bonus) 2) (/ (- height size-bonus) 2))))))
                    (small-charge size-bonus size-bonus field-color)))))
             ((eq? variation #:symmetric-outer-charges)
              (let* ((area-width (/ (- width cross-width) 4))
                     (area-height (/ (- height cross-width) 4))
                     (same-charges? (pick-boolean))
                     (first-charge (small-charge area-width area-height charge-color)))
                (area
                  (area ((transforms (list (translation (point (/ area-width 2) (/ area-height 2))))))
                    first-charge)
                  (area ((transforms (list (translation (point (/ (+ width cross-width area-width) 2)
                                                               (/ area-height 2))))))
                    (if same-charges?
                        first-charge
                        (small-charge area-width area-height charge-color)))
                  (area ((transforms (list (translation (point (/ area-width 2)
                                                               (/ (+ height cross-width area-height) 2))))))
                    (if same-charges?
                        first-charge
                        (small-charge area-width area-height charge-color)))
                  (area ((transforms (list (translation (point (/ (+ width cross-width area-width) 2)
                                                               (/ (+ height cross-width area-height) 2))))))
                    (if same-charges?
                        first-charge
                        (small-charge area-width area-height charge-color))))))
             (#t (area))
            ))))))

;; Lozenge
(define-method (large-charge:lozenge (width <number>) (height <number>)
                                     (charge-color <color>) (field-color <color>))
  (let* ((lref (min width height))
         (offset (if (pick-boolean) (* lref 0.1) 0)))
    (area
      (polygon
        (points (list (point offset (/ height 2)) (point (/ width 2) offset)
                      (point (- width offset) (/ height 2)) (point (/ width 2) (- height offset))))
        (style (fill-color charge-color)))
      (if (pick-boolean)
          (area)
          (let* ((wref (- width offset offset))
                 (href (- height offset offset))
                 (lc (/ (* wref href) (+ wref href))))
            (area ((transforms (list (translation (point (/ (- width lc) 2) (/ (- height lc) 2))))))
              (small-charge lc lc field-color))
          )))))

;; Fess (horizontal bar) or Pale (vertical bar)
(define-method (large-charge:fess-or-pale (width <number>) (height <number>)
                                          (charge-color <color>) (field-color <color>))
  (let* ((ratio (pick-from (vector 1/5 1/4 1/3 1/2)))
         (fess? (pick-boolean))
         (w (if fess? width (* width ratio)))
         (h (if fess? (* height ratio) height)))
    (area
      (rectangle (width w) (height h)
                 (topleft (if fess? (point 0 (/ (- height h) 2)) (point (/ (- width w) 2) 0)))
                 (style (fill-color charge-color)))
      (if (pick-boolean)
          (area)
          (let ((variation (pick-from (vector #:inner-pattern #:inner-charge #:surrounding-pattern))))
            (cond
             ((eq? variation #:inner-pattern)
              (let* ((inner-ratio (pick-from (vector 1/2 1/3 1/4)))
                     (iw (if fess? w (* w inner-ratio)))
                     (ih (if fess? (* h inner-ratio) h)))
                (rectangle (width iw) (height ih)
                           (topleft (if fess? (point 0 (/ (- height ih) 2)) (point (/ (- width iw) 2) 0)))
                           (style (fill-color field-color)))))
             ((eq? variation #:inner-charge)
              (let ((offset (* (if fess? h w) 0.1)))
                (area
                  ((transforms
                     (list
                       (translation
                         (if fess?
                           (point offset (+ offset (/ (- height h) 2)))
                           (point (+ offset (/ (- width w) 2)) offset))))))
                  (small-charge (- w (* 2 offset)) (- h (* 2 offset)) field-color))))
             ((eq? variation #:surrounding-pattern)
              (let ((mw (if fess? width (* width 0.05)))
                    (mh (if fess? (* height 0.05) height)))
                (area
                  (rectangle (width mw) (height mh)
                             (topleft
                               (if fess?
                                 (point 0 (- (/ height 2) (/ h 2) (* 2 mh)))
                                 (point (- (/ width 2) (/ w 2) (* 2 mw)) 0)))
                             (style (fill-color charge-color)))
                  (rectangle (width mw) (height mh)
                             (topleft
                               (if fess?
                                 (point 0 (+ (/ height 2) (/ h 2) mh))
                                 (point (+ (/ width 2) (/ w 2) mw) 0)))
                             (style (fill-color charge-color))))))
             (#t (area))
            ))))))

;; Disc filled with a charge
(define-method (large-charge:disc (width <number>) (height <number>)
                                  (charge-color <color>) (field-color <color>))
  (let ((r (* (min width height) 1/3)))
    (area
      (circle (center (point (/ width 2) (/ height 2))) (radius r)
              (style (fill-color charge-color)))
      (area ((transforms
               (list
                 (translation
                   (point (- (/ width 2) (* r (/ 1 (sqrt 2)))) (- (/ height 2) (* r (/ 1 (sqrt 2)))))
                 ))))
        (small-charge (* r (sqrt 2)) (* r (sqrt 2)) field-color)
      ))))

;; Border
(define-method (large-charge:border (width <number>) (height <number>)
                                    (charge-color <color>) (field-color <color>))
  (let ((bw (* 0.1 (min width height))))
    (area
      (rectangle (width width) (height bw)
                 (style (fill-color charge-color)))
      (rectangle (width bw) (height height)
                 (style (fill-color charge-color)))
      (rectangle (width width) (height bw)
                 (topleft (point 0 (- height bw)))
                 (style (fill-color charge-color)))
      (rectangle (width bw) (height height)
                 (topleft (point (- width bw) 0))
                 (style (fill-color charge-color)))
      (if (pick-boolean)
          (area)
          (area ((transforms (list (translation (point (* 2 bw) (* 2 bw))))))
            (small-charge (- width (* 4 bw)) (- height (* 4 bw)) charge-color))
      ))))

;; Saltire
(define-method (large-charge:saltire (w <number>) (h <number>)
                                     (charge-color <color>) (field-color <color>))
  (let* ((sw (* 0.2 (min w h)))
         (r (/ sw (sqrt (+ (* w w) (* h h)))))
         (lw (* r w))
         (lh (* r h)))
    (area
      (polygon
        (points
          (list
            (point 0 0) (point lw 0) (point (/ w 2) (- (/ h 2) lh)) (point (- w lw) 0)
            (point w 0) (point w lh) (point (+ (/ w 2) lw) (/ h 2)) (point w (- h lh))
            (point w h) (point (- w lw) h) (point (/ w 2) (+ (/ h 2) lh)) (point lw h)
            (point 0 h) (point 0 (- h lh)) (point (- (/ w 2) lw) (/ h 2)) (point 0 lh)
          ))
        (style (fill-color charge-color)))
      (if (pick-boolean)
          (area)
          (let ((variation
                  (pick-from
                    (vector #:inner-saltire #:small-inner-charge #:cross-inner-charge #:symmetric-outer-charges))))
            (cond
             ((eq? variation #:inner-saltire)
              (polygon
                (points
                  (list
                    (point 0 0) (point (/ lw 2) 0) (point (/ w 2) (- (/ h 2) (/ lh 2))) (point (- w (/ lw 2)) 0)
                    (point w 0) (point w (/ lh 2)) (point (+ (/ w 2) (/ lw 2)) (/ h 2)) (point w (- h (/ lh 2)))
                    (point w h) (point (- w (/ lw 2)) h) (point (/ w 2) (+ (/ h 2) (/ lh 2))) (point (/ lw 2) h)
                    (point 0 h) (point 0 (- h (/ lh 2))) (point (- (/ w 2) (/ lw 2)) (/ h 2)) (point 0 (/ lh 2))
                  ))
                (style (fill-color field-color))))
             ((eq? variation #:small-inner-charge)
              (area ((transforms (list (translation (point (- (/ w 2) (* 0.9 lw)) (- (/ h 2) (* 0.9 lh)))))))
                (small-charge (* 0.9 2 lw) (* 0.9 2 lh) field-color)))
             ((eq? variation #:cross-inner-charge)
              (letrec* ((charge (small-charge lw lh field-color))
                        (theta (atan (/ h w)))
                        (D (sqrt (+ (* w w) (* h h))))
                        (draw
                          (lambda (n lst)
                            (if (<= n 0)
                              lst
                              (draw
                                (- n 1)
                                (append
                                  (list
                                    (area
                                      ((transforms
                                        (list
                                          (translation
                                            (point (- (* n (cos theta) 1/6 D) (/ lw 2))
                                                   (- (* n (sin theta) 1/6 D) (/ lh 2)))))))
                                      charge)
                                    (area
                                      ((transforms
                                        (list
                                          (translation
                                            (point (- (* n (cos theta) 1/6 D) (/ lw 2))
                                                   (- h (* n (sin theta) 1/6 D) (/ lh 2)))))))
                                      charge)
                                  )
                                  lst))))))
                (draw 5 (list))))
             ((eq? variation #:symmetric-outer-charges)
              (let* ((nw (/ (* lw (- h (* lh 2))) (* lh 2)))
                     (nh (/ (* lh (- w (* lw 2))) (* lw 2)))
                     (e 0.1)
                     (area-width-dexter (/ (* (- 1 e) nw h) (+ nw h)))
                     (area-width-chief (/ (* (- 1 e) nh w) (+ nh w)))
                     (area-width (if (< area-width-dexter area-width-chief) area-width-dexter area-width-chief))
                     (same-charges? (pick-boolean))
                     (first-charge (small-charge area-width area-width charge-color)))
                (area
                  (area
                    ((transforms (list (translation (point (- (/ w 2) (/ area-width 2)) (* e nh))))))
                    first-charge)
                  (area
                    ((transforms (list (translation (point (* e nw) (- (/ h 2) (/ area-width 2)))))))
                    (if same-charges?
                        first-charge
                        (small-charge area-width area-width charge-color)))
                  (area
                    ((transforms (list (translation (point (- (/ w 2) (/ area-width 2)) (- h (* e nh) area-width))))))
                    (if same-charges?
                        first-charge
                        (small-charge area-width area-width charge-color)))
                  (area
                    ((transforms (list (translation (point (- w (* e nw) area-width) (- (/ h 2) (/ area-width 2)))))))
                    (if same-charges?
                        first-charge
                        (small-charge area-width area-width charge-color)))
                )))
             (#t (area))
            ))))))

;; Charge alone
(define-method (large-charge:single-small (width <number>) (height <number>)
                                          (charge-color <color>) (field-color <color>))
  (let ((scale (pick-from (vector 0.4 0.6 0.8))))
    (area ((transforms (list (translation (point (/ (* (- 1 scale) width) 2) (/ (* (- 1 scale) height) 2)))
                             (scaling scale))))
      (small-charge width height charge-color))))


(define-method (charge (width <number>) (height <number>) (charge-color <color>) (field-color <color>))
  ((pick-from
     (vector
       large-charge:single-small large-charge:single-small large-charge:single-small large-charge:single-small
       large-charge:single-small large-charge:single-small
       ;;
       large-charge:cross large-charge:lozenge large-charge:fess-or-pale large-charge:disc
       large-charge:border large-charge:saltire
     ))
   width height charge-color field-color))
