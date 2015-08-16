;; Floraverse character generator
;; Locations
(define-module (flora-character-generator locations)
  #:version (0 0 1)
  #:use-module (oop goops)
  #:use-module (ffch random)
  #:export (<place> name type reference-link area
            preposition-in preposition-near
            pick-place get-region
           )
)

;; Data classes
(define-class <place> (<object>)
  (name #:getter name #:init-keyword #:name #:init-form "")
  (type #:getter type #:init-keyword #:type #:init-form #f)
  (reference-link #:getter reference-link #:init-keyword #:reference-link #:init-form #f)
  (area #:getter area #:init-keyword #:area #:init-form #f))

(define-class <location-type> (<object>)
  (name #:getter name #:init-keyword #:name #:init-form "")
  (preposition-in #:getter preposition-in #:init-keyword #:preposition-in #:init-form "")
  (preposition-near #:getter preposition-near #:init-keyword #:preposition-near #:init-form ""))

(define-class <region> (<object>)
  (key #:getter key #:init-keyword #:key #:init-form #f)
  (name #:getter name #:init-keyword #:name #:init-form "")
  (reference-link #:getter reference-link-of #:init-keyword #:reference-link #:init-form #f)
  (restricted? #:getter restricted? #:init-keyword #:restricted? #:init-form #f)
  (places #:getter places #:init-keyword #:places #:init-form (list))
  (subregions #:getter subregions #:init-keyword #:subregions #:init-form (list))
  (parent-region #:getter parent-region #:init-keyword #:parent-region #:init-form #f))

(define-method (reference-link (region <region>))
  (if (reference-link-of region)
      (reference-link-of region)
      (reference-link (parent-region region))))

;; Data singleton class
(define-class <locations> (<object>)
  (types #:getter types #:init-keyword #:types #:init-form (make-hash-table))
  (regions #:getter regions #:init-keyword #:regions #:init-form (make-hash-table)))

;; Data singleton
(define *data:locations* (make <locations>))

(define-method (get-location-type (key <symbol>))
  (hash-ref (types *data:locations*) key))

(define-method (get-region (key <symbol>))
  (hash-ref (regions *data:locations*) key))

;; Special region : root of the region tree
(define *data:locations:root-region*
  (make <region> #:key '$root$ #:name "$root$" #:reference-link "http://floraverse.com/"))
(hash-set! (regions *data:locations*) (key *data:locations:root-region*) *data:locations:root-region*)

(define-method (pick-place)
  (pick-place *data:locations:root-region*))

(define-method (pick-place (key <symbol>))
  (pick-place (get-region key)))

(define-method (pick-place (region <region>))
  (if (< 0 (vector-length (places region)))
      (pick-from (places region))
      (pick-place (pick-from (filter (lambda (r) (not (restricted? r))) (subregions region))))))

;; Region syntax
(define-syntax region
  (syntax-rules (places)
    ((_ key (slot value) ... (places (placetype placevalue ...) ...))
     (let ((result
              (make <region>
                    #:key (quote key)
                    #:places
                      (apply append
                        (list
                          (map
                            (lambda (x)
                              (make <place> #:name x #:type (get-location-type (quote placetype))))
                            (list placevalue ...)) ...)))))
      (begin
        (slot-set! result (quote slot) value) ...)
      (hash-set! (regions *data:locations*) (quote key) result)
      result))
    ((_ key ((slot value) ...) subregion* ...)
     (let ((result (make <region> #:key (quote key) #:subregions (list subregion* ...))))
       (begin
         (slot-set! result (quote slot) value) ...)
      (hash-set! (regions *data:locations*) (quote key) result)
      (map (lambda (x) (slot-set! x (quote parent-region) result)) (subregions result))
      result))
  ))

;; Syntax for singleton
(define-syntax locations
  (syntax-rules (types regions)
   ((_ (types (keytype (slottype valuetype) ...) ...) (regions region* ...))
    (begin
      (begin
        (let ((type (make <location-type>)))
          (begin
            (slot-set! type (quote slottype) valuetype) ...)
          (hash-set! (types *data:locations*) (quote keytype) type)) ...)
      (slot-set! *data:locations:root-region* (quote subregions) (list region* ...))
      (map
        (lambda (x) (slot-set! x (quote parent-region) *data:locations:root-region*))
        (subregions *data:locations:root-region*))))
  ))

;; Data inclusion for filling *data:locations*
(include "data/locations.scm")

;; Post inclusion : fix reference links + area in places + lst->vector on places
(define-method (lock-region (reg <region>))
  (let ((ref (reference-link reg)))
    (map
      (lambda (x)
        (slot-set! x (quote reference-link) ref)
        (slot-set! x (quote area) reg))
      (places reg))
    (slot-set! reg (quote places) (list->vector (places reg)))
    (map lock-region (subregions reg))))

(lock-region *data:locations:root-region*)
