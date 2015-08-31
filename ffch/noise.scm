(define-module (ffch noise)
  #:use-module (oop goops)
  #:use-module (ffch range)
  #:export (<noise> make-noise value-of fractal-noise
           )
  #:duplicates (merge-generics)
)

(define-class <noise> (<object>)
  (dimensions #:getter dimensions #:init-keyword #:dimensions)
  (nb-samples #:getter nb-samples #:init-keyword #:nb-samples)
  (samples #:getter samples #:init-keyword #:samples))

(define-method (make-noise (dimensions <integer>) (nb-samples <integer>))
  (letrec* ((len (expt nb-samples dimensions))
            (samp (make-vector len 0))
            (filler (lambda (i)
                      (if (< i len)
                          (begin
                            (vector-set! samp i (- (random 2.0) 1.0))
                            (filler (+ 1 i)))))))
    (filler 0)
    (make <noise>
      #:dimensions dimensions
      #:nb-samples nb-samples
      #:samples samp)))

;; Sample of noise
;; 1D
(define (sample-1d nb-samples samples x)
  (vector-ref
    samples
    (modulo x nb-samples)))
;; 2D
(define (sample-2d nb-samples samples x y)
  (vector-ref
    samples
    (+ (modulo x nb-samples)
       (* (modulo y nb-samples) nb-samples))))
;; 3D
(define (sample-3d nb-samples samples x y z)
  (vector-ref
    samples
    (+ (modulo x nb-samples)
       (* (modulo y nb-samples) nb-samples)
       (* (modulo z nb-samples) nb-samples nb-samples))))

;; nD
(define-method (sample (noise <noise>) . point)
  (let* ((dim-point (length point))
         (dim-noise (dimensions noise))
         (nb-sp (nb-samples noise))
         (coords (cond
                  ((eq? dim-noise dim-point) point)
                  ((< dim-noise dim-point) ((@ (srfi srfi-1) take) point dim-noise))
                  (#t (append point (make-list (- dim-noise dim-point) 0)))))
         (idx (apply +
                (map
                  (lambda (x y) (* (modulo x nb-sp) (expt nb-sp y)))
                  coords
                  (range 0 dim-noise)))))
    (vector-ref (samples noise) idx)))

; Interpolations
(define (lerp t A B)
  (+ A (* t (- B A))))

;; Smoothstep 1D
(define-method (smoothstep t A B)
  (lerp (* t t (- 3 (* 2 t))) A B))

;; Smoothstep 2D
(define (smoothstep-2d tx ty A B C D)
  (let ((tAD (smoothstep ty A D))
        (tBC (smoothstep ty B C)))
    (smoothstep tx tAD tBC)))

;; Smoothstep 3D
(define (smoothstep-3d tx ty tz
                       A B C D
                       E F G H)
  (let ((tABCD (smoothstep-2d tx ty A B C D))
        (tEFGH (smoothstep-2d tx ty E F G H)))
    (smoothstep tz tABCD tEFGH)))

;; 1D Noise
(define (value-of-1d nb-sp sampl x)
  (let ((xx (euclidean-quotient x nb-sp))
        (tx (/ (euclidean-remainder x nb-sp) nb-sp)))
    (smoothstep
      tx
      (sample-1d nb-sp sampl xx)
      (sample-1d nb-sp sampl (+ xx 1)))))

;; 2D Noise
(define (value-of-2d nb-sp sampl x y)
  (let ((xx (euclidean-quotient x nb-sp))
        (tx (/ (euclidean-remainder x nb-sp) nb-sp))
        (yy (euclidean-quotient y nb-sp))
        (ty (/ (euclidean-remainder y nb-sp) nb-sp))
       )
    (smoothstep-2d
      tx ty
      (sample-2d nb-sp sampl xx yy)
      (sample-2d nb-sp sampl (+ xx 1) yy)
      (sample-2d nb-sp sampl (+ xx 1) (+ yy 1))
      (sample-2d nb-sp sampl xx (+ yy 1)))))

;; 3D Noise
(define-method (value-of-3d nb-sp sampl x y z)
  (let ((xx (euclidean-quotient x nb-sp))
        (tx (/ (euclidean-remainder x nb-sp) nb-sp))
        (yy (euclidean-quotient y nb-sp))
        (ty (/ (euclidean-remainder y nb-sp) nb-sp))
        (zz (euclidean-quotient z nb-sp))
        (tz (/ (euclidean-remainder z nb-sp) nb-sp))
       )
    (smoothstep-3d
      tx ty tz
      (sample-3d nb-sp sampl xx yy zz)
      (sample-3d nb-sp sampl (+ xx 1) yy zz)
      (sample-3d nb-sp sampl (+ xx 1) (+ yy 1) zz)
      (sample-3d nb-sp sampl xx (+ yy 1) zz)
      (sample-3d nb-sp sampl xx yy (+ zz 1))
      (sample-3d nb-sp sampl (+ xx 1) yy (+ zz 1))
      (sample-3d nb-sp sampl (+ xx 1) (+ yy 1) (+ zz 1))
      (sample-3d nb-sp sampl xx (+ yy 1) (+ zz 1)))))

(define-method (value-of (noise <noise>) (x <integer>))
  (value-of-1d (nb-samples noise) (samples noise) x))
(define-method (value-of (noise <noise>) (x <integer>) (y <integer>))
  (value-of-2d (nb-samples noise) (samples noise) x y))
(define-method (value-of (noise <noise>) (x <integer>) (y <integer>) (z <integer>))
  (value-of-3d (nb-samples noise) (samples noise) x y z))

;; Fractal noises
;; 1D
(define (fractal-noise-1d nb-sp sampl octaves persistance x)
  (letrec ((helper
             (lambda (v i)
               (if (>= i octaves)
                   v
                   (helper
                     (+ v (* (expt persistance i)
                             (value-of-1d nb-sp sampl (* (+ i 1) x))))
                     (+ i 1))))))
    (helper 0 0)))
;; 2D
(define (fractal-noise-2d nb-sp sampl octaves persistance x y)
  (letrec ((helper
             (lambda (v i)
               (if (>= i octaves)
                   v
                   (helper
                     (+ v (* (expt persistance i)
                             (value-of-2d nb-sp sampl (* (+ i 1) x) (* (+ i 1) y))))
                     (+ i 1))))))
    (helper 0 0)))

;; 3D
(define (fractal-noise-3d nb-sp sampl octaves persistance x y z)
  (letrec ((helper
             (lambda (v i)
               (if (>= i octaves)
                   v
                   (helper
                     (+ v (* (expt persistance i)
                             (value-of-3d nb-sp sampl (* (+ i 1) x) (* (+ i 1) y) (* (+ i 1) z))))
                     (+ i 1))))))
    (helper 0 0)))

;;
(define-method (fractal-noise (noise <noise>) (octaves <integer>) (persistance <number>) (x <number>))
  (fractal-noise-1d (nb-samples noise) (samples noise) octaves persistance x))

(define-method (fractal-noise (noise <noise>) (octaves <integer>) (persistance <number>)
                              (x <number>) (y <number>))
  (fractal-noise-2d (nb-samples noise) (samples noise) octaves persistance x y))

(define-method (fractal-noise (noise <noise>) (octaves <integer>) (persistance <number>)
                              (x <number>) (y <number>) (z <number>))
  (fractal-noise-3d (nb-samples noise) (samples noise) octaves persistance x y z))

(define-method (fractal-noise (noise <noise>) (octaves <integer>) (persistance <number>) . point)
  (letrec ((helper
             (lambda (v i)
               (if (>= i octaves)
                   v
                   (helper
                     (+ v (* (expt persistance i)
                             (apply
                               (lambda ( . rst) (apply value-of (append (list noise) rst)))
                               (map (lambda (x) (* (+ i 1) x)) point))))
                     (+ i 1))))))
    (helper 0 0)))
