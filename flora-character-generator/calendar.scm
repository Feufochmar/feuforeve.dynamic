;; Floraverse character generator
;; Calendar
(define-module (flora-character-generator calendar)
  #:version (0 0 1)
  #:use-module (oop goops)
  #:use-module (ffch random)
  #:use-module (ffch distribution)
  #:export (name number key
            ;
            pick-birthday month day astrological-sign
            ;
            make-birthdate-bound-parameters find-month
            get-astrological-sign
           )
  #:duplicates (merge-generics))


;;
(define-class <month> (<object>)
  (number #:getter number #:init-keyword #:number #:init-form 0)
  (name #:getter name #:init-keyword #:name #:init-form "")
  (days #:getter days #:init-keyword #:days #:init-form 0))

;;
(define-class <date> (<object>)
  (month #:getter month #:init-keyword #:month #:init-form #f)
  (day #:getter day #:init-keyword #:day #:init-form 0))

(define-method (date-= (d1 <date>) (d2 <date>))
  (and (eq? (number (month d1)) (number (month d2)))
       (eq? (day d1) (day d2))))

(define-method (date-< (d1 <date>) (d2 <date>))
  (let ((m1 (number (month d1)))
        (m2 (number (month d2))))
    (or (< m1 m2)
        (and (eq? m1 m2)
             (< (day d1) (day d2))))))

(define-method (date-<= (d1 <date>) (d2 <date>))
  (or (date-< d1 d2) (date-= d1 d2)))

(define-method (date-> (d1 <date>) (d2 <date>))
  (not (date-<= d1 d2)))

(define-method (date->= (d1 <date>) (d2 <date>))
  (not (date-< d1 d2)))

;;
(define-class <astrological-sign> (<object>)
  (key #:getter key #:init-keyword #:key #:init-form #f)
  (name #:getter name #:init-keyword #:name #:init-form "")
  (from #:getter from #:init-keyword #:from #:init-form #f)
  (to #:getter to #:init-keyword #:to #:init-form #f))

;;
(define-class <birthdate> (<date>)
  (astrological-sign #:getter astrological-sign #:init-keyword #:astrological-sign #:init-form #f))

;; Bound parameters for building a birthdate
(define-class <birthdate-bound-parameters> (<object>)
  (month #:accessor month #:init-keyword #:month #:init-form #f)
  (day #:accessor day #:init-keyword #:day #:init-form #f)
  (astrological-sign #:accessor astrological-sign #:init-keyword #:astrological-sign #:init-form #f))

(define-method (make-birthdate-bound-parameters)
  (make <birthdate-bound-parameters>))

;; Data container
(define-class <calendar> (<object>)
  (months #:getter months #:init-keyword #:months #:init-form (vector))
  (months-distribution #:getter months-distribution #:init-form (make-distribution))
  (astrological-signs #:getter astrological-signs #:init-keyword #:astrological-signs #:init-form (list)))

;; Data singleton
(define *data:calendar* (make <calendar>))

;;
(define-method (find-astrological-sign (date <date>))
  (letrec ((helper
             (lambda (d lst)
               (if (null? lst)
                   #f
                   (let* ((sign (car lst))
                          (accross-year? (date-< (to sign) (from sign)))
                          (ok? (or (and (not accross-year?) (date-<= (from sign) d) (date-<= d (to sign)))
                                   (and accross-year? (or (date-<= (from sign) d) (date-<= d (to sign))))))
                         )
                      (if ok?
                          sign
                          (helper d (cdr lst))))))))
    (helper date (astrological-signs *data:calendar*))))

; Pick birthday
; Note: when an element is a boolean, it is assumed to be #f
(define-method (pick-birthday (m <month>) (d <integer>) (sign <astrological-sign>))
  (make <birthdate> #:month m #:day d #:astrological-sign sign))

(define-method (pick-birthday (m <month>) (d <integer>) (sign-ignored <boolean>))
  (let ((birthdate (make <birthdate> #:month m #:day d)))
    (slot-set! birthdate (quote astrological-sign) (find-astrological-sign birthdate))
    birthdate))

(define-method (pick-birthday (m <month>) (day-ignored <boolean>) (sign <astrological-sign>))
  (let ((d (if (eq? m (month (from sign)))
               (pick-from (day (from sign)) (+ 1 (days m)))
               (+ 1 (random (day (to sign)))))))
    (pick-birthday m d sign)))

(define-method (pick-birthday (month-ignored <boolean>) (d <integer>) (sign <astrological-sign>))
  (let ((m (month (if (<= (day (from sign)) d) (from sign) (to sign)))))
    (pick-birthday m d sign)))

(define-method (pick-birthday (m <month>) (day-ignored <boolean>) (sign-ignored <boolean>))
  (let ((d (+ 1 (random (days m)))))
    (pick-birthday m d #f)))

(define-method (pick-birthday (month-ignored <boolean>) (d <integer>) (sign-ignored <boolean>))
  (let ((m
          (pick-from
            (filter
              (lambda (x) (<= d (days x)))
              (vector->list (months *data:calendar*))))))
    (pick-birthday m d #f)))

(define-method (pick-birthday (month-ignored <boolean>) (day-ignored <boolean>) (sign <astrological-sign>))
  (let ((m (month (if (pick-boolean) (from sign) (to sign)))))
    (pick-birthday m #f sign)))

(define-method (pick-birthday (month-ignored <boolean>) (day-ignored <boolean>) (sign-ignored <boolean>))
  (let ((m (pick-from (months-distribution *data:calendar*))))
    (pick-birthday m #f #f)))

;;
(define-method (day-coherent? (day <integer>) (month <month>))
  (and (< 0 day) (<= day (days month))))

(define-method (sign-coherent? m d (sign <astrological-sign>))
  (let ((m-from (month (from sign)))
        (m-to (month (to sign))))
    (and
      (if m
          (or (eq? m m-from) (eq? m m-to))
          #t)
      (if d
          (or (<= (day (from sign)) d)
              (<= d (day (to sign))))
          #t))))

(define-method (coherent? (bound-parameters <birthdate-bound-parameters>))
  (let ((m (month bound-parameters))
        (d (day bound-parameters))
        (sign (astrological-sign bound-parameters)))
    (and
      ; 1. check if day is in the right interval
      (if d
          (cond
            (m (day-coherent? d m))
            (sign (or (day-coherent? d (month (from sign))) (day-coherent? d (month (to sign)))))
            (#t (not (member #f (map (lambda (x) (day-coherent? d x)) (vector->list (months *data:calendar*)))))))
          #t)
      ; 2. check sign is coherent with month or/and day
      (if (and sign (or m d))
          (sign-coherent? m d sign)
          #t))))

(define-method (pick-birthday (bound-parameters <birthdate-bound-parameters>))
  ; invalidate bound-parameters if incoherency is detected
  (if (coherent? bound-parameters)
      (pick-birthday (month bound-parameters) (day bound-parameters) (astrological-sign bound-parameters))
      (pick-birthday #f #f #f)))

;
(define-method (find-month (m <integer>))
  (letrec ((helper
             (lambda (idx)
               (if (>= idx (vector-length (months *data:calendar*)))
                   #f
                   (if (eq? m (number (vector-ref (months *data:calendar*) idx)))
                       (vector-ref (months *data:calendar*) idx)
                       (helper (+ 1 idx)))))))
    (helper 0)))

(define-method (date-from-numbers (month <integer>) (day <integer>))
  (make <date> #:month (find-month month) #:day day))

(define-method (get-astrological-sign (sign-key <symbol>))
  (letrec ((helper
             (lambda (lst)
               (cond
                 ((null? lst) #f)
                 ((eq? (key (car lst)) sign-key) (car lst))
                 (#t (helper (cdr lst)))))))
    (helper (astrological-signs *data:calendar*))))

;; Data syntax
(define-syntax calendar
  (syntax-rules (months astrological-signs name)
    ((_ (months ((month-slot month-value) ...) ...)
        (astrological-signs (key (name name-value) (limit m d) ...) ...))
     (let ((lst-months (list))
           (lst-signs (list)))
       (begin
         (set! lst-months
           (cons
             (let ((month (make <month>)))
               (begin (slot-set! month (quote month-slot) month-value) ...)
               (add-to-distribution (months-distribution *data:calendar*) month (days month))
               month)
             lst-months)) ...)
       (slot-set! *data:calendar* (quote months) (list->vector lst-months))
       (begin
         (set! lst-signs
           (cons
             (let ((sign (make <astrological-sign> #:key (quote key) #:name name-value)))
               (begin (slot-set! sign (quote limit) (date-from-numbers m d)) ...)
               sign)
             lst-signs)) ...)
       (slot-set! *data:calendar* (quote astrological-signs) lst-signs)))))

;; Include data to fill *data:calendar*
(include "data/calendar.scm")
