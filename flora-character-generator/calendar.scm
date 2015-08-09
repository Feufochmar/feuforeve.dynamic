;; Floraverse character generator
;; Calendar
(define-module (flora-character-generator calendar)
  #:version (0 0 1)
  #:use-module (oop goops)
  #:use-module (ffch distribution)
  #:export (name
            ;
            pick-birthday month day astrological-sign
           )
)

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
  (name #:getter name #:init-keyword #:name #:init-form "")
  (from #:getter from #:init-keyword #:from #:init-form #f)
  (to #:getter to #:init-keyword #:to #:init-form #f))

;;
(define-class <birthdate> (<date>)
  (astrological-sign #:getter astrological-sign #:init-keyword #:astrological-sign #:init-form #f))

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

(define-method (pick-birthday)
  (let* ((month (pick-from (months-distribution *data:calendar*)))
         (day (+ 1 (random (days month))))
         (birthdate (make <birthdate> #:month month #:day day)))
    (slot-set! birthdate (quote astrological-sign) (find-astrological-sign birthdate))
    birthdate))

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

;; Data syntax
(define-syntax calendar
  (syntax-rules (months astrological-signs name)
    ((_ (months ((month-slot month-value) ...) ...)
        (astrological-signs ((name name-value) (limit m d) ...) ...))
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
             (let ((sign (make <astrological-sign> #:name name-value)))
               (begin (slot-set! sign (quote limit) (date-from-numbers m d)) ...)
               sign)
             lst-signs)) ...)
       (slot-set! *data:calendar* (quote astrological-signs) lst-signs)))))

;; Include data to fill *data:calendar*
(include "data/calendar.scm")
