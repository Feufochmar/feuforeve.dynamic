;; Hexagonal grids
;; Scheme implementation of http://www.redblobgames.com/grids/hexagons/implementation.html
(define-module (ffch hexgrid)
  #:version (0 0 1)
  #:use-module (oop goops)
  #:use-module (ffch vectorgraphics)
  #:use-module (ffch range)
  #:export (<hexpoint> q r s
            hexpoint hexpoint=?
            hexpoint-add hexpoint-substract hexpoint-multiply
            hexpoint-length hexpoint-distance
            ;
            <hexedge> hexedge hexedge=?
            <hexvertex> hexvertex hexvertex=?
            ;
            neighbour-faces neighbour-edges neighbour-vertices
            neighbours+edges
            ;
            pointy-top-layout flat-top-layout
            hexpoint->point point->hexpoint
            hexvertex->point
            hexpoint->corner-points
            ;
            hexpoint-round hexpoint-lerp hexpoint-line
            ;
            <hexgrid> hexgrid-ref hexgrid-set!
            hexgrid-apply-filter! hexgrid-for-each hexgrid-flood
            ;
            hexgrid->area
            ;
            hexgrid-parallelogram-qr hexgrid-parallelogram-sq hexgrid-parallelogram-rs
            hexgrid-hexagon hexgrid-rectangle
            ;
            hexgrid-pathfind
           )
)

;;;;
;; Hex point

;; Using Axial / Cubic coordinates
(define-class <hexpoint> (<object>)
  (q #:getter q #:init-keyword #:q #:init-form 0)
  (r #:getter r #:init-keyword #:r #:init-form 0))

(define-method (s (H <hexpoint>))
  (- 0 (q H) (r H)))

(define-method (hexpoint (q <number>) (r <number>))
  (make <hexpoint> #:q q #:r r))

(define-method (hexpoint (q <number>) (r <number>) (s <number>))
  (if (not (eq? 0 (+ q r s)))
      (error "Invariant (+ q r s) does not equals to 0. q = " q " ; r = " r " ; s = " s))
  (make <hexpoint> #:q q #:r r))

(define-method (hexpoint=? (H1 <hexpoint>) (H2 <hexpoint>))
  (and (eq? (q H1) (q H2)) (eq? (r H1) (r H2))))

(define-method (object-equal? (H1 <hexpoint>) (H2 <hexpoint>))
  (hexpoint=? H1 H2))

(define-method (equal? (H1 <hexpoint>) (H2 <hexpoint>))
  (hexpoint=? H1 H2))

(define-method (hexpoint-add (H1 <hexpoint>) (H2 <hexpoint>))
  (hexpoint (+ (q H1) (q H2)) (+ (r H1) (r H2))))

(define-method (hexpoint-substract (H1 <hexpoint>) (H2 <hexpoint>))
  (hexpoint (- (q H1) (q H2)) (- (r H1) (r H2))))

(define-method (hexpoint-multiply (H <hexpoint>) (k <number>))
  (hexpoint (* k (q H)) (* k (r H))))

(define-method (hexpoint-multiply (k <number>) (H <hexpoint>))
  (hexpoint-multiply H k))

(define-method (hexpoint-length (H <hexpoint>))
  (/ (+ (abs (q H)) (abs (r H)) (abs (s H))) 2))

(define-method (hexpoint-distance (H1 <hexpoint>) (H2 <hexpoint>))
  (hexpoint-length (hexpoint-substract H1 H2)))

;;;;
;; vertices, edges and faces: graph defining a hexgrid

;; Faces - not defined, use hexpoints
;(define-class <hexface> (<hexpoint>))
;(define-method (hexface (H <hexpoint>))
;  (make <hexface> #:q (q H) #:r (r H)))

;; Edges
(define-class <hexedge> (<hexpoint>)
  (id #:getter id #:init-keyword #:id)) ;; Possible values: #:+z #:+- #:z- (z for 0)

(define-method (hexedge (q <integer>) (r <integer>) (id <keyword>))
  (if (member id (list #:+z #:+- #:z-))
      (make <hexedge> #:q q #:r r #:id id)
      (error "Invalid id for <hexedge>: " id)))

(define-method (hexedge=? (H1 <hexedge>) (H2 <hexedge>))
  (and (hexpoint=? H1 H2) (eq? (id H1) (id H2))))

(define-method (object-equal? (H1 <hexedge>) (H2 <hexedge>))
  (hexedge=? H1 H2))

(define-method (equal? (H1 <hexedge>) (H2 <hexedge>))
  (hexedge=? H1 H2))

;; Vertex
(define-class <hexvertex> (<hexpoint>)
  (id #:getter id #:init-keyword #:id)) ;; Possible values: #:+ #:-

(define-method (hexvertex (q <integer>) (r <integer>) (id <keyword>))
  (if (member id (list #:+ #:-))
      (make <hexvertex> #:q q #:r r #:id id)
      (error "Invalid id for <hexvertex>: " id)))

(define-method (hexvertex=? (H1 <hexvertex>) (H2 <hexvertex>))
  (and (hexpoint=? H1 H2) (eq? (id H1) (id H2))))

(define-method (object-equal? (H1 <hexvertex>) (H2 <hexvertex>))
  (hexvertex=? H1 H2))

(define-method (equal? (H1 <hexvertex>) (H2 <hexvertex>))
  (hexvertex=? H1 H2))

;;;;
;; Neighbours: faces
(define-method (neighbour-faces (face <hexpoint>))
  (list
    (hexpoint (+ (q face) 1) (r face))
    (hexpoint (+ (q face) 1) (- (r face) 1))
    (hexpoint (q face) (- (r face) 1))
    (hexpoint (- (q face) 1) (r face))
    (hexpoint (- (q face) 1) (+ (r face) 1))
    (hexpoint (q face) (+ (r face) 1))))

;; An edge is linked to 2 faces (the r, q and id indicate which ones)
(define-method (neighbour-faces (edge <hexedge>))
  (cond
    ((eq? #:+z (id edge))
     (list
       (hexpoint (q edge) (r edge))
       (hexpoint (+ 1 (q edge)) (r edge))))
    ((eq? #:+- (id edge))
     (list
       (hexpoint (q edge) (r edge))
       (hexpoint (+ 1 (q edge)) (- (r edge) 1))))
    ((eq? #:z- (id edge))
     (list
       (hexpoint (q edge) (r edge))
       (hexpoint (q edge) (- (r edge) 1))))
    (#t (error "Invalid id for <hexedge>: " id))))

;; A vertex is linked to 3 faces (the r, q and id indicate which ones)
(define-method (neighbour-faces (vertex <hexvertex>))
  (cond
    ((eq? #:+ (id vertex))
     (list
       (hexpoint (q vertex) (r vertex))
       (hexpoint (+ (q vertex) 1) (r vertex))
       (hexpoint (q vertex) (+ (r vertex) 1))))
    ((eq? #:- (id vertex))
     (list
       (hexpoint (q vertex) (r vertex))
       (hexpoint (- (q vertex) 1) (r vertex))
       (hexpoint (q vertex) (- (r vertex) 1))))
    (#t (error "Invalid id for <hexvertex>: " id))))

;;;;
;; Neighbours: Edge

;; A face is linked to 6 edges (surrounding it)
(define-method (neighbour-edges (face <hexpoint>))
  (list
    (hexedge (q face) (r face) #:+z)
    (hexedge (q face) (r face) #:+-)
    (hexedge (q face) (r face) #:z-)
    (hexedge (- (q face) 1) (r face) #:+z)
    (hexedge (- (q face) 1) (+ (r face) 1) #:+-)
    (hexedge (q face) (+ (r face) 1) #:z-)))

;; An edge is linked to 4 edges
(define-method (neighbour-edges (edge <hexedge>))
  (cond
    ((eq? #:+z (id edge))
     (list
       (hexedge (q edge) (+ (r edge) 1) #:+-)
       (hexedge (q edge) (+ (r edge) 1) #:z-)
       (hexedge (q edge) (r edge) #:+-)
       (hexedge (+ (q edge) 1) (r edge) #:z-)))
    ((eq? #:+- (id edge))
     (list
       (hexedge (q edge) (r edge) #:+z)
       (hexedge (+ (q edge) 1) (r edge) #:z-)
       (hexedge (q edge) (r edge) #:z-)
       (hexedge (q edge) (- (r edge) 1) #:+z)))
    ((eq? #:z- (id edge))
     (list
       (hexedge (q edge) (r edge) #:+-)
       (hexedge (q edge) (- (r edge) 1) #:+z)
       (hexedge (- (q edge) 1) (r edge) #:+-)
       (hexedge (- (q edge) 1) (r edge) #:+z)))
    (#t (error "Invalid id for <hexedge>: " id))))

;; A vertex is linked to 3 edges
(define-method (neighbour-edges (vertex <hexvertex>))
  (cond
    ((eq? #:+ (id vertex))
     (list
       (hexedge (q vertex) (r vertex) #:+z)
       (hexedge (q vertex) (+ (r vertex) 1) #:z-)
       (hexedge (q vertex) (+ (r vertex) 1) #:+-)))
    ((eq? #:- (id vertex))
     (list
       (hexedge (q vertex) (r vertex) #:z-)
       (hexedge (- (q vertex) 1) (r vertex) #:+z)
       (hexedge (- (q vertex) 1) (r vertex) #:+-)))
    (#t (error "Invalid id for <hexvertex>: " id))))

;;;;
;; Neighbours: Vertices

;; A face is linked to 6 vertices
(define-method (neighbour-vertices (face <hexpoint>))
  (list
    (hexvertex (q face) (r face) #:+)
    (hexvertex (- (q face) 1) (r face) #:+)
    (hexvertex (q face) (- (r face) 1) #:+)
    (hexvertex (q face) (r face) #:-)
    (hexvertex (+ (q face) 1) (r face) #:-)
    (hexvertex (q face) (+ (r face) 1) #:-)))

;; An edge is linked to 2 vertices
(define-method (neighbour-vertices (edge <hexedge>))
  (cond
    ((eq? #:+z (id edge))
     (list
       (hexvertex (q edge) (r edge) #:+)
       (hexvertex (+ (q edge) 1) (r edge) #:-)))
    ((eq? #:+- (id edge))
     (list
       (hexvertex (+ (q edge) 1) (r edge) #:-)
       (hexvertex (q edge) (- (r edge) 1) #:+)))
    ((eq? #:z- (id edge))
     (list
       (hexvertex (q edge) (- (r edge) 1) #:+)
       (hexvertex (q edge) (r edge) #:-)))
    (#t (error "Invalid id for <hexedge>: " id))))

;; A vertex is linked to 3 vertices
(define-method (neighbour-vertices (vertex <hexvertex>))
  (cond
    ((eq? #:+ (id vertex))
     (list
       (hexvertex (+ (q vertex) 1) (r vertex) #:-)
       (hexvertex (q vertex) (+ (r vertex) 1) #:-)
       (hexvertex (+ (q vertex) 1) (+ (r vertex) 1) #:-)))
    ((eq? #:- (id vertex))
     (list
       (hexvertex (- (q vertex) 1) (r vertex) #:+)
       (hexvertex (q vertex) (- (r vertex) 1) #:+)
       (hexvertex (- (q vertex) 1) (- (r vertex) 1) #:+)))
    (#t (error "Invalid id for <hexvertex>: " id))))

;;;;
;; Neighbours+edges: give the neighbours of the same type (face/vertex) and the edge separating them
(define-method (neighbours+edges (face <hexpoint>))
  (list
    (cons (hexpoint (+ (q face) 1) (r face)) (hexedge (q face) (r face) #:+z))
    (cons (hexpoint (+ (q face) 1) (- (r face) 1)) (hexedge (q face) (r face) #:+-))
    (cons (hexpoint (q face) (- (r face) 1)) (hexedge (q face) (r face) #:z-))
    (cons (hexpoint (- (q face) 1) (r face)) (hexedge (- (q face) 1) (r face) #:+z))
    (cons (hexpoint (- (q face) 1) (+ (r face) 1)) (hexedge (- (q face) 1) (+ (r face) 1) #:+-))
    (cons (hexpoint (q face) (+ (r face) 1)) (hexedge (q face) (+ (r face) 1) #:z-))))

(define-method (neighbours+edges (vertex <hexvertex>))
  (cond
    ((eq? #:+ (id vertex))
     (list
       (cons (hexvertex (+ (q vertex) 1) (r vertex) #:-) (hexedge (q vertex) (r vertex) #:+z))
       (cons (hexvertex (q vertex) (+ (r vertex) 1) #:-) (hexedge (q vertex) (+ (r vertex) 1) #:z-))
       (cons (hexvertex (+ (q vertex) 1) (+ (r vertex) 1) #:-) (hexedge (q vertex) (+ (r vertex) 1) #:+-))))
    ((eq? #:- (id vertex))
     (list
       (cons (hexvertex (- (q vertex) 1) (r vertex) #:+) (hexedge (- (q vertex) 1) (r vertex) #:+z))
       (cons (hexvertex (q vertex) (- (r vertex) 1) #:+) (hexedge (q vertex) (r vertex) #:z-))
       (cons (hexvertex (- (q vertex) 1) (- (r vertex) 1) #:+) (hexedge (- (q vertex) 1) (r vertex) #:+-))))
    (#t (error "Invalid id for <hexvertex>: " id))))

;;;;
;; Layout, for drawing the polygons
(define-class <orientation> (<object>)
  (forward-matrix #:getter forward-matrix #:init-keyword #:forward-matrix #:init-form (vector))
  (inverse-matrix #:getter inverse-matrix #:init-keyword #:inverse-matrix #:init-form (vector))
  (start-angle #:getter start-angle #:init-keyword #:start-angle #:init-form 0)) ;; In multiples of pi/3

(define *layout-pointy-top*
        (make <orientation>
              #:forward-matrix (vector (sqrt 3) (/ (sqrt 3) 2) 0 3/2)
              #:inverse-matrix (vector (/ (sqrt 3) 3) -1/3 0 2/3)
              #:start-angle 1/2))

(define *layout-flat-top*
        (make <orientation>
              #:forward-matrix (vector 3/2 0 (/ (sqrt 3) 2) (sqrt 3))
              #:inverse-matrix (vector 2/3 0 -1/3 (/ (sqrt 3) 3))
              #:start-angle 0))

(define-class <layout> (<object>)
  (orientation #:getter orientation #:init-keyword #:orientation)
  (size #:getter size #:init-keyword #:size #:init-form (point 1 1))
  (origin #:getter origin #:init-keyword #:origin #:init-form (point 0 0)))

(define-method (pointy-top-layout (size <point>) (origin <point>))
  (make <layout>
        #:orientation *layout-pointy-top*
        #:size size
        #:origin origin))
(define-method (flat-top-layout (size <point>) (origin <point>))
  (make <layout>
        #:orientation *layout-flat-top*
        #:size size
        #:origin origin))

(define-method (hexpoint->point (layout <layout>) (H <hexpoint>))
  (let* ((forward (forward-matrix (orientation layout)))
         (px (* (x (size layout))
                (+ (* (vector-ref forward 0) (q H))
                   (* (vector-ref forward 1) (r H)))))
         (py (* (y (size layout))
                (+ (* (vector-ref forward 2) (q H))
                   (* (vector-ref forward 3) (r H)))))
        )
    (point (+ px (x (origin layout))) (+ py (y (origin layout))))))

(define-method (point->hexpoint (layout <layout>) (P <point>))
  (let* ((inverse (inverse-matrix (orientation layout)))
         (pt (point (/ (- (x P) (x (origin layout))) (x (size layout)))
                    (/ (- (y P) (y (origin layout))) (y (size layout))))))
    (hexpoint
      (+ (* (vector-ref inverse 0) (x pt)) (* (vector-ref inverse 1) (y pt)))
      (+ (* (vector-ref inverse 2) (x pt)) (* (vector-ref inverse 3) (y pt))))))

(define-method (hexvertex->point (layout <layout>) (H <hexvertex>))
  (let* ((sz (size layout))
         (pointy-top? (eq? *layout-pointy-top* (orientation layout)))
         (center (hexpoint->point layout H))
         (offset (if (eq? (id H) #:+) sz (- 0 sz))))
    (point
      (+ (x center) (if pointy-top? 0 offset))
      (+ (y center) (if pointy-top? offset 0)))))

(define-method (hexpoint->corner-points (layout <layout>) (H <hexpoint>))
  (let* ((pi (* 4 (atan 1)))
         (sz (size layout))
         (st-ang (start-angle (orientation layout)))
         (center (hexpoint->point layout H))
         (corner-offset
           (lambda (i)
             (let ((ang (* 2 pi (/ (+ i st-ang) 6))))
               (point (* (x sz) (cos ang)) (* (y sz) (sin ang)))))))
    (map
      (lambda (i)
        (let ((offset (corner-offset i)))
          (point (+ (x center) (x offset)) (+ (y center) (y offset)))))
      (list 0 1 2 3 4 5))))

(define-syntax hexpoint->polygon
  (syntax-rules (layout hexpoint)
    ((_ (layout l) (hexpoint h) (slot val) ...)
     (polygon (points (hexpoint->corner-points l h)) (slot val) ...))))

;;;;
;; Hexgrid
(define-method (hexpoint-round (H <hexpoint>))
  (let* ((rq (inexact->exact (round (q H))))
         (rr (inexact->exact (round (r H))))
         (rs (inexact->exact (round (s H))))
         (dq (abs (- rq (q H))))
         (dr (abs (- rr (r H))))
         (ds (abs (- rs (s H)))))
    (cond
      ((and (> dq dr) (> dq ds))
       (hexpoint (- 0 rr rs) rr))
      ((> dr ds)
       (hexpoint rq (- 0 rq rs)))
      (#t
       (hexpoint rq rr)))))

(define-method (hexpoint-lerp (H1 <hexpoint>) (H2 <hexpoint>) (t <number>))
  (hexpoint-add H1 (hexpoint-multiply (hexpoint-substract H2 H1) t)))

;; Get all the sectors of a grid along a line
(define-method (hexpoint-line (H1 <hexpoint>) (H2 <hexpoint>))
  (letrec* ((N (hexpoint-distance H1 H2))
            (step (/ 1 (max N 1)))
            (helper
              (lambda (lst i N)
                (if (> i N)
                    lst
                    (helper
                      (cons (hexpoint-round (hexpoint-lerp H1 H2 (* step i))) lst)
                      (+ i 1)
                      N)))))
    (helper (list) 0 N)))

;;;;
;; Grid Shapes
(define-class <hexgrid> (<object>)
  (grid-layout #:getter grid-layout #:init-keyword #:grid-layout)
  (grid-tiles #:getter grid-tiles #:init-keyword #:grid-tiles #:init-form (make-hash-table)))

(define-method (hexgrid-ref (hexgrid <hexgrid>) (H <hexpoint>))
  (hash-ref (grid-tiles hexgrid) H))

(define-method (hexgrid-set! (hexgrid <hexgrid>) (H <hexpoint>) tile)
  (hash-set! (grid-tiles hexgrid) H tile))

(define-method (hexgrid-for-each (filter <applicable>) (hexgrid <hexgrid>))
  (hash-for-each filter (grid-tiles hexgrid)))

(define-method (hexgrid-apply-filter! (filter <applicable>) (hexgrid <hexgrid>))
  (let ((result-grid (make-hash-table)))
    (hash-for-each
      (lambda (k v)
        (hash-set! result-grid k (filter k v)))
      (grid-tiles hexgrid))
    (slot-set! hexgrid 'grid-tiles result-grid)))

(define-method (hexgrid-flood (flood-filter <applicable>) (hexgrid <hexgrid>) (start-point <hexpoint>))
  (letrec* ((visited? (make-hash-table))
            (floodfill
              (lambda (lst)
                (if (not (null? lst))
                    (let ((current (car lst)))
                      (if (hash-ref visited? current)
                          (floodfill (cdr lst))
                          (begin
                            (hash-set! visited? current #t)
                            (if (flood-filter current (hexgrid-ref hexgrid current))
                                (floodfill
                                  (append
                                    (cdr lst)
                                    (filter
                                      (lambda (x)
                                        (and (not (hash-ref visited? x)) (hexgrid-ref hexgrid x)))
                                      (neighbour-faces current))))
                                (floodfill (cdr lst))))))))))
    (floodfill (list start-point))))

;; Exporting hexgrid
(define-syntax hexgrid->area
  (syntax-rules (hexgrid hexpoint-renderer)
    ((_ (hexgrid grid) (hexpoint-renderer renderer) (area-slot area-value) ...)
     (area ((area-slot area-value) ...)
        (hash-map->list
          (lambda (k v)
            (hexpoint->polygon
              (layout (grid-layout grid))
              (hexpoint k)
              (style-class (renderer v))))
          (grid-tiles grid))))))

;;;;
;; Grid building methods
(define-method (hexgrid-parallelogram-qr (layout <layout>) (size <point>) (hexpoint-init <applicable>))
  (let ((result (make <hexgrid> #:grid-layout layout))
        (range-width (range-inclusive 0 (x size)))
        (range-height (range-inclusive 0 (y size)))
       )
    (for-each
      (lambda (qq)
        (for-each
          (lambda (rr)
            (hash-set! (grid-tiles result) (hexpoint qq rr) (hexpoint-init qq rr (- 0 qq rr))))
          range-height))
      range-width)
    result))

(define-method (hexgrid-parallelogram-sq (layout <layout>) (size <point>) (hexpoint-init <applicable>))
  (let ((result (make <hexgrid> #:grid-layout layout))
        (range-width (range-inclusive 0 (x size)))
        (range-height (range-inclusive 0 (y size)))
       )
    (for-each
      (lambda (ss)
        (for-each
          (lambda (qq)
            (hash-set! (grid-tiles result) (hexpoint qq (- 0 qq ss)) (hexpoint-init qq (- 0 ss qq) ss)))
          range-height))
      range-width)
    result))

(define-method (hexgrid-parallelogram-rs (layout <layout>) (size <point>) (hexpoint-init <applicable>))
  (let ((result (make <hexgrid> #:grid-layout layout))
        (range-width (range-inclusive 0 (x size)))
        (range-height (range-inclusive 0 (y size)))
       )
    (for-each
      (lambda (rr)
        (for-each
          (lambda (ss)
            (hash-set! (grid-tiles result) (hexpoint (- 0 rr ss) rr) (hexpoint-init (- 0 ss rr) rr ss)))
          range-height))
      range-width)
    result))

(define-method (hexgrid-hexagon (layout <layout>) (radius <integer>) (hexpoint-init <applicable>))
  (let ((result (make <hexgrid> #:grid-layout layout)))
    (for-each
      (lambda (qq)
        (let ((r1 (max (- 0 radius) (- 0 qq radius)))
              (r2 (min radius (- radius qq))))
          (for-each
            (lambda (rr)
              (hash-set! (grid-tiles result) (hexpoint qq rr) (hexpoint-init qq rr (- 0 qq rr))))
            (range-inclusive r1 r2))))
      (range-inclusive (- 0 radius) radius))
    result))

(define-method (hexgrid-rectangle (layout <layout>) (size <point>) (hexpoint-init <applicable>))
  (let* ((result (make <hexgrid> #:grid-layout layout))
         (pointy-top? (eq? *layout-pointy-top* (orientation layout)))
         (width (if pointy-top? (x size) (y size)))
         (height (if pointy-top? (y size) (x size)))
        )
    (for-each
      (lambda (yy)
        (let ((offset (floor (/ yy 2))))
          (for-each
            (lambda (xx)
              (hash-set! (grid-tiles result)
                         (if pointy-top? (hexpoint xx yy) (hexpoint yy xx))
                         (if pointy-top? (hexpoint-init xx yy (- 0 xx yy)) (hexpoint-init yy xx (- 0 xx yy)))))
            (range-inclusive (- 0 offset) (- width offset)))))
      (range-inclusive 0 height))
    result))

;;;;
;; Find path
;; Path finding
;; Move-cost takes 4 parameters: hexgrid, current (hexpoint), next (hexpoint), current/next edge (hexedge)
;; Heuristic-cost takes 3 parameters: hexgrid, current (hexpoint), destination (hexpoint)
(define-method (hexgrid-pathfind (hexgrid <hexgrid>) (from <hexpoint>) (to <hexpoint>)
                                 (move-cost <applicable>) (heuristic-cost <applicable>))
  (letrec* ((hex-cost (make-hash-table))
            (path-from (make-hash-table))
            (build-path
              (lambda (lst current)
                (if current
                    (build-path (cons current lst) (hash-ref path-from current))
                    lst)))
            (push
              (lambda (lst-next lst-frontier)
                (sort (append lst-next lst-frontier) (lambda (x y) (< (cdr x) (cdr y))))))
            (cost-function
              (lambda (current next edge)
                (let* ((move (move-cost hexgrid current next edge))
                       (new-cost (and move (+ (hash-ref hex-cost current) move)))
                       (next-cost (hash-ref hex-cost (car next))))
                      (if (and new-cost (or (not next-cost) (< new-cost next-cost)))
                          (begin
                            (hash-set! hex-cost next new-cost)
                            (hash-set! path-from next current)
                            (cons next (+ new-cost (heuristic-cost hexgrid next to))))
                          #f))))
            (next-hexpoints
              (lambda (current)
                (filter
                  identity
                  (map
                    (lambda (x) (cost-function current (car x) (cdr x)))
                    (neighbours+edges current)))))
            (findpath
              (lambda (frontier)
                (cond
                  ((null? frontier) #f)
                  ((equal? (caar frontier) to) (build-path (list) to))
                  (#t (findpath (push (next-hexpoints (caar frontier)) (cdr frontier)))))))
           )
    (hash-set! hex-cost from 0)
    (hash-set! path-from from #f)
    (findpath (list (cons from 0)))))
