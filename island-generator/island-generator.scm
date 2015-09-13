(define-module (island-generator island-generator)
  #:use-module (ffch debug)
  #:use-module (oop goops)
  #:use-module (ffch vectorgraphics)
  #:use-module (ffch hexgrid)
  #:use-module (ffch noise)
  #:use-module (ffch random)
  #:use-module (ffch colors)
  #:use-module ((srfi srfi-1) #:renamer (symbol-prefix-proc 'list:))
  #:export (generate-island
            ;
            <biome> name display-color sea? lake? get-biome get-ordered-biomes
            <tile> altitude biome territory
            <island> image-width image-height grid grid-layout river-vertices river-points river-springs
            simple-generator?
            roads cities
            <city> hex size
            <road> road-path importance
            <territory>
           )
  #:duplicates (merge-generics)
)

;;;;
;; Biome data

(define-class <biome> (<object>)
  (key #:getter key #:init-keyword #:key)
  (name #:getter name #:init-keyword #:name)
  (moisture-threshold #:getter moisture-threshold #:init-keyword #:moisture-threshold)
  (temperature-threshold #:getter temperature-threshold #:init-keyword #:temperature-threshold)
  (new-road-cost #:getter new-road-cost #:init-keyword #:new-road-cost)
  (city-score #:getter city-score #:init-keyword #:city-score)
  (display-color #:getter display-color #:init-keyword #:display-color)
  (similarity-table #:getter similarity-table #:init-form (make-hash-table))
)

(define *all-biomes* (make-hash-table))
(define-method (get-biome (key <keyword>))
  (hash-ref *all-biomes* key))

(define-syntax biomes
  (syntax-rules (similarity)
    ((_ (key (slot value) ... (similarity (sim-key sim-val) ...)) ...)
     (begin
       (let ((biome (make <biome> #:key key)))
         (begin
           (slot-set! biome (quote slot) value) ...)
         (begin
           (hash-set! (similarity-table biome) sim-key sim-val) ...)
         (hash-set! *all-biomes* key biome))
       ...))))

(include "data/biomes.scm")

(define *ordered-biomes*
        (sort
          (hash-map->list
            (lambda (k v) v)
            *all-biomes*)
          (lambda (x y)
            (or (> (temperature-threshold x) (temperature-threshold y))
                (and (eq? (temperature-threshold x) (temperature-threshold y))
                     (> (moisture-threshold x) (moisture-threshold y)))))))
(define-method (get-ordered-biomes) *ordered-biomes* )

;; Those biomes are used before the compute-biome pass
(define (sea? biome)
  (and biome (eq? #:sea (key biome))))
(define (lake? biome)
  (and biome (eq? #:lake (key biome))))

;;
(define-class <tile> (<object>)
  (altitude #:accessor altitude #:init-keyword #:altitude #:init-form 0)
  (temperature #:accessor temperature #:init-keyword #:temperature #:init-form 0)
  (rainfall #:accessor rainfall #:init-keyword #:rainfall #:init-form 0) ; rainfall
  (moisture #:accessor moisture #:init-keyword #:moisture #:init-from 0) ; rainfall + river & lake effects
  (biome #:accessor biome #:init-keyword #:biome #:init-form #f)
  (city #:accessor city #:init-form #f)
  (territory #:accessor territory #:init-form #f)
)

(define-class <island> (<object>)
  (image-width #:getter image-width #:init-keyword #:image-width)
  (image-height #:getter image-height #:init-keyword #:image-height)
  (tile-size #:getter tile-size #:init-keyword #:tile-size)
  (simple-generator? #:getter simple-generator? #:init-keyword #:simple-generator?)
  (grid-radius #:getter grid-radius #:init-keyword #:grid-radius)
  (grid-layout #:getter grid-layout #:init-keyword #:grid-layout)
  (grid #:getter grid #:init-keyword #:grid)
  (latitude #:getter latitude #:init-keyword #:latitude)
  (river-spring-faces #:accessor river-spring-faces #:init-form (list))
  (altitude-vertices #:getter altitude-vertices #:init-form (make-hash-table))
  (river-springs #:getter river-springs #:init-form (make-hash-table))
  (river-points #:getter river-points #:init-form (make-hash-table))
  (cities #:accessor cities #:init-form (list))
  (subdivision #:accessor subdivision #:init-form #f)
  (edge-crossing-roads #:getter edge-crossing-roads #:init-form (make-hash-table))
  (linked-places #:getter linked-places #:init-form (make-hash-table))
  (roads #:accessor roads #:init-form (list))
  )

(define-class <river-data> (<object>)
  (current-vertex #:getter current-vertex #:init-keyword #:current-vertex #:init-form #f)
  (next-vertex #:accessor next-vertex #:init-keyword #:next-vertex #:init-form #f))

(define-class <city> (<object>)
  (hex #:getter hex #:init-keyword #:hex)
  (score #:getter score #:init-keyword #:score)
  (size #:accessor size #:init-keyword #:size))

(define-class <territory> (<object>)
  (capital-city #:accessor capital-city #:init-keyword #:capital-city)
  (neighbours #:accessor neighbours #:init-form (make-hash-table))
  (subdivision #:accessor subdivision #:init-keyword #:subdivision #:init-form #f)
  (building-frontier #:accessor building-frontier #:init-keyword #:building-frontier)
  (display-color #:accessor display-color
                 #:init-form (hsl-color
                               (pick-from (vector 20 40 60 80 100 120 140 160 180 260 280 300 320 340))
                               (+ 50 (* 5 (random 8)))
                               (+ 40 (* 5 (random 8)))))
  (border-edges #:getter border-edges #:init-form (make-hash-table)))

(define-class <road> (<object>)
  (road-path #:getter road-path #:init-keyword #:road-path)
  (importance #:getter importance #:init-keyword #:importance))

;;;;
;; Make
(define-method (make-island (width <integer>) (height <integer>) (tile-size <integer>) (simple? <boolean>))
  (let ((radius (inexact->exact (floor (- (* 1/2 width (/ 1 tile-size (sqrt 3))) 1/2))))
        (layout (pointy-top-layout (point tile-size tile-size) (point (/ width 2) (/ height 2))))
        (altitude-noise (make-noise 3 10))
        (rainfall-noise (make-noise 3 10))
        (latitude (+ 10 (random 60))))
    (make <island>
          #:image-width width
          #:image-height height
          #:tile-size tile-size
          #:simple-generator? simple?
          #:grid-radius radius
          #:grid-layout layout
          #:grid
            (hexgrid-hexagon
              layout
              radius
              (lambda (qq rr ss)
                (make <tile>
                      #:altitude
                        (* 8
                          (+ 125
                            (* -250 (+ (* qq qq) (* rr rr) (* ss ss)) (/ 1 (* radius radius)))
                            (* 200 (fractal-noise altitude-noise 2 1/4 qq rr ss))
                          ))
                      #:rainfall
                        (if simple?
                            (+ 200 (* -2 latitude) (* 200 (fractal-noise rainfall-noise 2 1/4 qq rr ss)))
                            0)
                )))
          #:latitude latitude
    )))

;;;;
;; Erosion
(define-method (erode (hexgrid <hexgrid>) (H <hexpoint>) (amount <number>) (excluded <hashtable>))
  (let ((tile (hexgrid-ref hexgrid H)))
    (if (< 0 (altitude tile))
        (let* ((neighbours+altitude
                 (sort
                   (map
                     (lambda (x)
                       (let ((xtile (hexgrid-ref hexgrid x)))
                         (if xtile
                             (cons x (altitude xtile))
                             (cons x (+ 10 (altitude tile))))))
                     (filter
                       (lambda (x) (not (hash-ref excluded x)))
                       (neighbour-faces H)))
                   (lambda (x y) (< (cdr x) (cdr y)))))
               (lowest+altitude (if (null? neighbours+altitude) #f (car neighbours+altitude))))
          (if (and lowest+altitude (< (cdr lowest+altitude) (altitude tile)))
              (begin
                (let ((diff (- (altitude tile) (cdr lowest+altitude))))
                  (set! (altitude tile)
                        (+ (altitude tile)
                           (min amount (* 50 (/ amount diff)))
                           (/ diff -4)))
                  (hash-set! excluded x #t)
                  (erode hexgrid
                         (car lowest+altitude)
                         (+ amount
                            (/ diff 4)
                            (- 0 (min amount (* 50 (/ amount diff)))))
                         excluded)))
              (set! (altitude tile) (+ (altitude tile) amount))))
        (set! (altitude tile) (+ (altitude tile) amount)))))

(define-method (erode (island <island>))
  (if (not (simple-generator? island))
      (let loop ((erode-pass (/ (+ 1 (* 3 (grid-radius island) (+ (grid-radius island) 1))) 5)))
        (if (< 0 erode-pass)
            (let* ((range (+ 1 (random (inexact->exact (floor (/ (grid-radius island) 2))))))
                  (ang (random (* 6 range)))
                  (starting-hex
                    (hexpoint-add
                      (hexpoint-add (hexpoint 0 0) (hexpoint-multiply range (hexpoint 1 0)))
                      (list:fold
                        (lambda (dir H)
                          (hexpoint-add
                            H
                            (hexpoint-multiply (min (max 0 (- ang (* range (car dir)))) range) (cdr dir))))
                        (hexpoint 0 0)
                        (list
                          (cons 0 (hexpoint 0 -1))
                          (cons 1 (hexpoint -1 0))
                          (cons 2 (hexpoint -1 1))
                          (cons 3 (hexpoint 0 1))
                          (cons 4 (hexpoint 1 0))
                          (cons 5 (hexpoint 1 -1)))))))
              (erode (grid island) starting-hex 0 (make-hash-table))
              (loop (- erode-pass 1)))))))

;;;;
;; altitudes min & max
(define-method (altitude+hex-min+max (island <island>))
  (let ((min-altitude (inf))
        (min-altitude-hex #f)
        (max-altitude (- 0 (inf)))
        (max-altitude-hex #f))
    (hexgrid-for-each
      (lambda (H tile)
        (if (< (altitude tile) min-altitude)
            (begin
              (set! min-altitude (altitude tile))
              (set! min-altitude-hex H)))
        (if (< max-altitude (altitude tile))
            (begin
              (set! max-altitude (altitude tile))
              (set! max-altitude-hex H))))
      (grid island))
    (cons (cons min-altitude min-altitude-hex)
          (cons max-altitude max-altitude-hex))))

;;;;
;; Sea
(define-method (flood-sea (island <island>))
  (let ((start-point (cdar (altitude+hex-min+max island))))
    (hexgrid-flood
      (lambda (H tile)
        (if (< (altitude tile) 0)
            (begin
              (set! (biome tile) (get-biome #:sea))
              #t)
            #f))
      (grid island)
      start-point)))

;;;;
;; Inverse sinkholes into mountains
(define-method (inverse-sinkhole (island <island>))
  (hexgrid-for-each
    (lambda (H tile)
      (if (and
            (not (sea? (biome tile)))
            (< (altitude tile) 0))
          (set! (altitude tile) (/ (abs (altitude tile)) 5))))
    (grid island)))

;;;;
;; Compute the temperatures
(define-method (compute-temperature (lat <number>) (alt <number>))
  ; lat == latitude / alt == altitude
  (+ (if (< lat 25)
         30
         (+ 49 (* lat -0.77)))
     (* alt (/ -0.64 100))))

(define-method (compute-temperatures (island <island>))
  (hexgrid-for-each
    (lambda (H tile)
      (set! (temperature tile)
            (compute-temperature
              (latitude island)
              (if (sea? (biome tile))
                  0
                  (altitude tile)))))
    (grid island)))

;;;;
;; Rain simulation
(define-method (pick-wind-direction)
  (pick-from
    (vector
      (vector (hexpoint 1 0) (hexpoint 0 1) (hexpoint 1 -1)) ; main direction + adjacents
      (vector (hexpoint 0 1) (hexpoint -1 1) (hexpoint 1 0))
      (vector (hexpoint -1 1) (hexpoint -1 0) (hexpoint 0 1))
      (vector (hexpoint -1 0) (hexpoint 0 -1) (hexpoint -1 1))
      (vector (hexpoint 0 -1) (hexpoint 1 -1) (hexpoint -1 0))
      (vector (hexpoint 1 -1) (hexpoint 1 0) (hexpoint 0 -1)))))

(define-method (rainfall-pass (hexgrid <hexgrid>) (wind-direction <vector>)
                              (cloud-map <hashtable>) (cloud-map-next <hashtable>))
  ; Update cloud + rainfall
  (let ((wind (pick-from wind-direction)))
    (hexgrid-for-each
      (lambda (H tile)
        (if (not (sea? (biome tile)))
            (let* ((wind-next (hexpoint-add H wind))
                   (alt (altitude tile))
                   (rain (rainfall tile))
                   (cloud (hash-ref cloud-map H))
                   (to-soil
                     (let ((r (min cloud (+ 5 (random 5) (max 0 (- (/ (* alt alt 50) 2500 2500) 5))))))
                       (if (< 500 (+ r rain))
                           (- 500 rain)
                           r)
                     ))
                   (to-cloud (min (random 10) (+ to-soil rain))))
              (set! (rainfall tile) (- (+ rain to-soil) to-cloud))
              (hash-set! cloud-map-next wind-next (- (+ cloud to-cloud) to-soil)))))
      hexgrid))
  ; Move cloud
  (hash-for-each
    (lambda (H cloud)
      (let ((next (hash-ref cloud-map-next H)))
        (hash-set! cloud-map H (or next (+ 50 (random 150))))))
    cloud-map))

(define-method (simulate-rainfalls (island <island>))
  (if (not (simple-generator? island))
      (let ((wind-direction (pick-wind-direction))
            (cloud-map (make-hash-table))
            (cloud-map-next (make-hash-table)))
        (hexgrid-for-each
          (lambda (H tile)
            (hash-set! cloud-map H 20))
          (grid island))
        (let loop ((x 0))
          (if (< x (* 2 (grid-radius island)))
              (begin
                (rainfall-pass (grid island) wind-direction cloud-map cloud-map-next)
                (loop (+ x 1))))))))

;;;;
;; Initialize the moisture and find the river springs
(define-method (init-moisture-and-find-river-spring-faces (island <island>))
  (hexgrid-for-each
    (lambda (H tile)
      ; initialize moisture to rainfall, limited to 400
      (set! (moisture tile) (max 0 (min 400 (rainfall tile))))
      (if (and (not (sea? (biome tile)))
               (< 200 (rainfall tile))) ;; Every face with a rainfall > 200 is a candidate for river
          (set! (river-spring-faces island)
                (sort (cons (cons H (rainfall tile)) (river-spring-faces island))
                      (lambda (x y) (> (cdr x) (cdr y)))))))
    (grid island))
  (set! (river-spring-faces island) (map car (river-spring-faces island))))

;;;;
;; Altitude of vertices
(define-method (compute-vertices-altitude (island <island>))
  (hexgrid-for-each
    (lambda (H tile)
      (let ((vertex+ (hexvertex (q H) (r H) #:+))
            (vertex- (hexvertex (q H) (r H) #:-))
            (vertex-altitude
              (lambda (v)
                (let ((neighbours (neighbour-faces v)))
                  (list:fold
                    (lambda (f res)
                      (let ((val (hexgrid-ref (grid island) f)))
                        (+ res
                          (/ (if val (altitude val) (altitude tile)) 3))))
                    0
                    neighbours)))))
        (hash-set!
          (altitude-vertices island)
          vertex+
          (vertex-altitude vertex+))
        (hash-set!
          (altitude-vertices island)
          vertex-
          (vertex-altitude vertex-))))
    (grid island)))

;;;;
;; Draw rivers and lakes
(define-method (find-river-next+altitude (island <island>) (H <hexpoint>))
  (car
    (sort
      (map
        (lambda (v) (cons v (hash-ref (altitude-vertices island) v)))
        (neighbour-vertices H))
      (lambda (x y) (< (cdr x) (cdr y))))))

(define-method (neighbours-face+tile (island <island>) (current <hexpoint>))
  (map
    (lambda (x) (cons x (hexgrid-ref (grid island) x)))
    (neighbour-faces current)))

(define-method (draw-river (island <island>) (excluded-vertices <hashtable>)
                           (current <hexpoint>) (alt <number>) (first-point? <boolean>))
  ; When starting, Draw a river if there is no river around already
  (if (or (not first-point?)
          (null? (filter identity
                         (map (lambda (x) (hash-ref (river-points island) x)) (neighbour-vertices current)))))
      (let* ((next+altitude (find-river-next+altitude island current))
             (next (car next+altitude))
             (vertices (neighbour-vertices next))
             (surrounding-tiles
               (filter identity
                 (map
                   (lambda (x) (hexgrid-ref (grid island) x))
                   (neighbour-faces next))))
             (surrounding-biomes (map biome surrounding-tiles))
             (reached-sea? (member (get-biome #:sea) surrounding-biomes))
             (reached-lake? (member (get-biome #:lake) surrounding-biomes)))
        (for-each
          (lambda (x)
            (set! (moisture x) (min 400 (+ 15 (moisture x)))))
          surrounding-tiles)
        (if (< (cdr next+altitude) alt)
            ; Find where the river continue to flow
            (let ((river-data (hash-ref (river-points island) next)))
              (if first-point?
                  (hash-set! (river-springs island) next #t)
                  (set! (next-vertex (hash-ref (river-points island) current)) next))
              (if river-data
                (hash-remove! (river-springs island) next) ; Remove from the spring list as it's not the spring
                (hash-set! (river-points island) next
                           (make <river-data> #:current-vertex next)))
              (if (not (or reached-sea? reached-lake? river-data))
                  (draw-river island excluded-vertices next (cdr next+altitude) #f)))
            ; Put a like in the lowest surrounding point
            (if (not first-point?)
                (let ((lowests
                        (sort
                          (neighbours-face+tile island current)
                          (lambda (x y) (< (altitude (cdr x)) (altitude (cdr y)))))))
                  (draw-lake island excluded-vertices lowests 0)))))))

(define-method (draw-lake (island <island>) (excluded-vertices <hashtable>)
                          (lst-face+tile <list>) (nb-pass <integer>))
  (if (and (not (null? lst-face+tile)) (< nb-pass 15))
      (let* ((face (caar lst-face+tile))
             (tile (cdar lst-face+tile))
             (next-face+tile (neighbours-face+tile island face))
             (next-vertices (neighbour-vertices face))
             (next+after-vertices+altitude
               (map
                 (lambda (x)
                   (cons (cons x (hash-ref (altitude-vertices island) x))
                         (find-river-next+altitude island x)))
                 next-vertices))
             (possible-next+after
               (filter
                 (lambda (x)
                   (and
                     (not (or (hash-ref excluded-vertices (caar x)) (hash-ref excluded-vertices (cadr x))))
                     (< (cddr x) (cdar x))
                     (not (member (cadr x) next-vertices))))
                 next+after-vertices+altitude))
             (next+altitude
               (and (not (null? possible-next+after))
                    (car
                      (sort
                        (map car possible-next+after)
                        (lambda (x y) (< (cdr x) (cdr y)))))))
            )
        ; change biome to lake
        (set! (biome tile) (get-biome #:lake))
        ; all the surrounding faces get + 40 in moisture
        (map
          (lambda (x)
            (let ((xtile (cdr x)))
              (and xtile (set! (moisture xtile) (min 400 (+ 40 (moisture xtile)))))))
          next-face+tile)
        ; Do not overflow if one of the surrounding face has sea biome
        (if (null? (filter (lambda (x) (sea? (biome (cdr x)))) next-face+tile))
            ; Check how the overflow is done
            (if next+altitude
                (let ((next (car next+altitude)))
                  ; overflow with a new river
                  (hash-set!
                    (river-points island)
                    next
                    (make <river-data> #:current-vertex next))
                  (hash-set! (river-springs island) next #t)
                  (draw-river island excluded-vertices next (cdr next+altitude) #f))
                (begin
                  ; Overflow with a lake
                  ; exclude all the vertices surrounding the current face from being choosen as next or after
                  (map (lambda (x) (hash-set! excluded-vertices x #t)) next-vertices)
                  (draw-lake
                    island
                    excluded-vertices
                    (sort
                      (filter (lambda (x) (not (lake? (biome (cdr x)))))
                              (append (cdr lst-face+tile) next-face+tile))
                      (lambda (x y) (< (altitude (cdr x)) (altitude (cdr y)))))
                    (+ 1 nb-pass))))))))

(define-method (draw-rivers (island <island>))
  (let ((excluded-vertices (make-hash-table)))
    ; Rivers only appear if the temperature is positive
    (for-each
      (lambda (x)
        (let ((tile (hexgrid-ref (grid island) x)))
          (if (< 0 (temperature tile))
              (draw-river island excluded-vertices x (altitude tile) #t))))
      (river-spring-faces island))))

(define-method (river-vertices (island <island>) (data <river-data>) (lst <list>))
  (if (next-vertex data)
      (river-vertices
        island
        (hash-ref (river-points island) (next-vertex data))
        (cons (current-vertex data) lst))
      (reverse (cons (current-vertex data) lst))))

(define-method (rivers (island <island>))
  (hash-map->list
    (lambda (k v) (river-vertices island (hash-ref (river-points island) k) (list)))
    (river-springs island)))

;;;;
;; Clean-up rivers

(define-method (edge-between (h1 <hexpoint>) (h2 <hexpoint>))
  (let ((edges1 (neighbour-edges h1))
        (edges2 (neighbour-edges h2)))
    (car (filter (lambda (x) (member x edges1)) edges2))))

;; Clean-up rivers : edges should not be surrounded by lakes
(define-method (clean-river (island <island>) (river-data <river-data>))
  (if (next-vertex river-data)
      (let* ((current (current-vertex river-data))
             (next (next-vertex river-data))
             (edge (edge-between current next))
             (edge-biomes (map (lambda (x) (biome (hexgrid-ref (grid island) x))) (neighbour-faces edge)))
            )
        (if (or (member (get-biome #:lake) edge-biomes) (member (get-biome #:sea) edge-biomes))
            (begin
              (set! (next-vertex river-data) #f)
              (hash-set! (river-springs island) next #t)
              (hash-remove! (river-springs island) current)))
        (clean-river island (hash-ref (river-points island) next)))))

(define-method (clean-up-rivers-lakes (island <island>))
  ; clean-up rivers
  (hash-for-each
    (lambda (k v)
      (clean-river island (hash-ref (river-points island) k)))
    (river-springs island))
  ; clean-up lakes
  (hexgrid-flood
    (lambda (H tile)
      (if (lake? (biome tile))
          (begin
            (set! (biome tile) (get-biome #:sea))
            #t)
          (sea? (biome tile))))
    (grid island)
    (cdar (altitude+hex-min+max island))))

;;;;
;; Blur moistures
(define-method (blur-moistures (island <island>))
  (let ((new-moisture (make-hash-table)))
    (hexgrid-for-each
      (lambda (H tile)
        (hash-set!
          new-moisture H
          (+ (/ (moisture tile) 2)
             (apply +
                (map
                  (lambda (x)
                    (let ((xtile (hexgrid-ref (grid island) x)))
                      (/ (if xtile (moisture xtile) (moisture tile)) 12)))
                  (neighbour-faces H))))))
      (grid island))
    (hexgrid-for-each
      (lambda (H tile)
        (set! (moisture tile) (hash-ref new-moisture H)))
      (grid island))))

;;;;
;; Compute biomes
(define-method (compute-biome (temperature <number>) (moisture <number>) (lst-biomes <list>))
  (if (null? lst-biomes)
      #f
      (let ((biome (car lst-biomes)))
        (if (and (< (temperature-threshold biome) temperature)
                 (< (moisture-threshold biome) moisture))
            biome
            (compute-biome temperature moisture (cdr lst-biomes))))))

(define-method (compute-biomes (island <island>))
  (hexgrid-for-each
    (lambda (H tile)
      (if (not (biome tile))
          (set! (biome tile) (compute-biome (temperature tile) (moisture tile) (get-ordered-biomes)))))
    (grid island)))

;;;;
;; Compute cities
(define-method (city-score-from-neighbour-faces (island <island>) (H <hexpoint>) (tile <tile>))
  (let ((ntiles
          (map
            (lambda (x) (or (hexgrid-ref (grid island) x) tile))
            (neighbour-faces H))))
    (list:fold
      (lambda (xtile res)
        (+ res
           (/ (abs (- (altitude xtile) (altitude tile))) -10)
           (if (or (sea? (biome xtile)) (lake? (biome xtile))) 20 0)))
      0
      ntiles)))

(define-method (city-score-from-neighbour-vertices (island <island>) (H <hexpoint>) (tile <tile>))
  (let ((neighbours (neighbour-vertices H)))
    (list:fold
      (lambda (v res)
        (+ res
           (if (hash-ref (river-points island) v)
               20
               0)))
      0
      neighbours)))

(define-method (city-score-from-altitude (alt <number>))
  (cond
    ((< 1700 alt) -10000) ; No cities above 1700 m
    ((< 1600 alt) -100)
    ((< 1200 alt) -30)
    ((< 800 alt) 10)
    (#t 30)))

(define-method (possible-cities (island <island>))
  (let ((possibilities (list)))
    (hexgrid-for-each
      (lambda (H tile)
        (if (not (member (key (biome tile)) (list #:sea #:lake #:ice-shelf))) ;; exclude cities on some biomes
            (set! possibilities
              (cons
                (make <city>
                  #:hex H
                  #:score (+ (city-score (biome tile))
                             (city-score-from-neighbour-faces island H tile)
                             (city-score-from-neighbour-vertices island H tile)
                             (city-score-from-altitude (altitude tile))
                             ))
                possibilities))))
      (grid island))
    (sort
      (filter
        (lambda (x) (> (score x) -100))
        possibilities)
      (lambda (x y) (> (score x) (score y))))))

(define-method (distance-to-closest-city (island <island>) (H <hexpoint>))
  (let ((minimum (inf)))
    (for-each
      (lambda (c)
        (set! minimum (min minimum (hexpoint-distance H (hex c)))))
      (cities island))
    minimum))

(define-method (place-cities (island <island>))
  (letrec* ((max-nb-cities (if (simple-generator? island) 3 5))
            (max-nb-towns (if (simple-generator? island) 9 15))
            (max-nb-settlements (if (simple-generator? island) 36 60))
            (nb-cities 0)
            (nb-towns 0)
            (nb-settlements 0)
            (make-city
              (lambda (lst)
                (if (and (not (null? lst)) (< nb-settlements max-nb-settlements))
                    (let* ((possible-city (car lst))
                           (sz (cond
                                ((and (< 100 (score possible-city)) (< nb-cities max-nb-cities)) #:city)
                                ((and (< 0 (score possible-city)) (< nb-towns max-nb-towns)) #:town)
                                (#t #:village)))
                           (dist
                             (cond
                               ((eq? size #:city) 15)
                               ((eq? size #:town) 10)
                               (#t 5))))
                      (if (> (distance-to-closest-city island (hex possible-city)) dist)
                          (begin
                            (set! (cities island) (cons possible-city (cities island)))
                            (set! (size possible-city) sz)
                            (set! (city (hexgrid-ref (grid island) (hex possible-city))) possible-city)
                            (if (eq? sz #:city)
                                (set! nb-cities (+ 1 nb-cities)))
                            (if (eq? sz #:town)
                                (set! nb-towns (+ 1 nb-towns)))
                            (set! nb-settlements (+ 1 nb-settlements))))
                      (make-city (cdr lst)))))))
    (make-city (possible-cities island))))

;;;;
;; Compute territories for each cities
(define-method (territory-score-biome (b1 <biome>) (b2 <biome>))
  (if (eq? b1 b2)
      100
      (or (hash-ref (similarity-table b1) (key b2)) 0)))

(define-method (compute-territory-score (island <island>) (capital <city>) (next <hexpoint>))
  (let ((tile-city (hexgrid-ref (grid island) (hex capital)))
        (tile-next (hexgrid-ref (grid island) next)))
    (if (and tile-next (not (sea? (biome tile-next))))
        (+ (territory-score-biome (biome tile-city) (biome tile-next))
           (- 0 (/ (abs (- (altitude tile-city) (altitude tile-next))) 100))
           (- 1000 (* 200 (hexpoint-distance (hex capital) next)))
        )
        #f)))

(define-method (find-new-frontier (island <island>) (ter <territory>) (lst <list>))
  (if (null? lst)
      lst
      (let* ((next (caar lst))
             (tile (hexgrid-ref (grid island) next)))
        (if (and next tile (not (territory tile)))
            (let ((result
                    (sort
                      (append
                        (cdr lst)
                        (filter cdr
                          (map
                            (lambda (y) (cons y (compute-territory-score island (capital-city ter) y)))
                            (neighbour-faces next))))
                      (lambda (x y) (> (cdr x) (cdr y))))))
              (set! (territory tile) ter)
              result)
            (begin
              (if (and next tile (not (eq? ter (territory tile))))
                  (begin
                    (hash-set! (neighbours ter) (territory tile) #t)
                    (hash-set! (neighbours (territory tile)) ter #t)))
              (find-new-frontier island ter (cdr lst)))))))

(define-method (next-territory? (island <island>) (territory <territory>))
  (if (null? (building-frontier territory))
      #f
      (let ((new-frontier (find-new-frontier island territory (building-frontier territory))))
        (set! (building-frontier territory) new-frontier)
        #t)))

(define-method (flood-territories (island <island>) (flooding <list>) (flood-finished <list>))
  (if (null? flooding)
      flood-finished
      (let ((next-pass (map (lambda (x) (cons x (next-territory? island x))) flooding)))
        (flood-territories
          island
          (map car (filter cdr next-pass))
          (append flood-finished (map car (filter (lambda (x) (not (cdr x))) next-pass)))))))

(define-method (compute-territories (island <island>))
  (let* ((all-cities (cities island))
         (territories
           (flood-territories
             island
             (map
               (lambda (x)
                 (let ((ter (make <territory>
                                  #:capital-city x
                                  #:building-frontier
                                    (sort
                                      (filter cdr
                                        (map
                                          (lambda (y) (cons y (compute-territory-score island x y)))
                                          (neighbour-faces (hex x))))
                                      (lambda (x y) (> (cdr x) (cdr y)))))))
                   (set! (territory (hexgrid-ref (grid island) (hex x))) ter)
                   ter))
               all-cities)
             (list))))
    (set! (subdivision island) territories)
  ))

;;;;
;; Compute roads

(define-method (has-river? (island <island>) (edge <hexedge>))
  (let* ((vertices (neighbour-vertices edge))
         (first (car vertices))
         (second (cadr vertices))
         (river-data-first (hash-ref (river-points island) first))
         (river-data-second (hash-ref (river-points island) second)))
    (and river-data-first river-data-second
         (or (equal? (next-vertex river-data-first) second)
             (equal? first (next-vertex river-data-second))))))

(define-method (has-road? (island <island>) (edge <hexedge>))
  (hash-ref (edge-crossing-roads island) edge))

(define-method (move-cost (island <island>) (road-type <keyword>) (hexgrid <hexgrid>)
                          (current <hexpoint>) (next <hexpoint>) (edge <hexedge>))
  (let* ((current-tile (hexgrid-ref hexgrid current))
         (next-tile (hexgrid-ref hexgrid next))
         (b (biome next-tile))
         (road? (has-road? island edge))
         (city? (city next-tile)))
    (if (or (not (new-road-cost b)) (< 1800 (altitude next-tile)))
        #f ; No new road possible => No path
        (+ (/ (abs (- (altitude next-tile) (altitude current-tile)))
              (if (or road? city?) 2 1))
           (cond  ;; Avoid roads in mountains
             ((< 1500 (altitude next-tile)) 500)
             ((< 1200 (altitude next-tile)) 300)
             ((< 900 (altitude next-tile)) 150)
             ((< 600 (altitude next-tile)) 50)
             (#t 0))
           (if (and (not road?) (has-river? island edge)) 100 0)
           (cond
             (road? 1)
             (city? 1)
             (#t (new-road-cost b)))))))

(define-method (move-cost-method (island <island>) (road-type <keyword>))
  (lambda (hexgrid current next edge)
    (move-cost island road-type hexgrid current next edge)))

(define-method (heuristic-cost (island <island>) (hexgrid <hexgrid>)
                               (current <hexpoint>) (destination <hexpoint>))
  (let ((current-tile (hexgrid-ref hexgrid current))
        (destination-tile (hexgrid-ref hexgrid destination)))
    (+ (hexpoint-distance current destination)
       (abs (- (altitude destination-tile) (altitude current-tile))))))

(define-method (heuristic-cost-method (island <island>))
  (lambda (hexgrid current destination)
    (heuristic-cost island hexgrid current destination)))

(define-method (closests (city <city>) (lst <list>))
  (sort
    (filter (lambda (x) (not (eq? city x))) lst)
    (lambda (x y) (< (hexpoint-distance (hex x) (hex city)) (hexpoint-distance (hex y) (hex city))))))

(define-method (update-edges-places (island <island>) (city-from <city>) (from <hexpoint>) (rest <list>))
  (if (not (null? rest))
      (let* ((next (car rest))
             (edge (edge-between from next))
             (next-tile (hexgrid-ref (grid island) next)))
        (hash-set! (edge-crossing-roads island) edge #t)
        (if (and next-tile (city next-tile))
            (hash-set! (linked-places island) (cons city-from (city next-tile)) #t))
        (update-edges-places island city-from next (cdr rest)))))

(define-method (add-road (island <island>) (from <city>) (to <city>) (road-type <keyword>))
  (if (and (not (hash-ref (linked-places island) (cons from to)))
           (not (hash-ref (linked-places island) (cons to from))))
    (let ((path (hexgrid-pathfind (grid island) (hex from) (hex to)
                                  (move-cost-method island road-type) (heuristic-cost-method island))))
      (if path
          (begin
            (set! (roads island)
                  (cons
                    (make <road> #:road-path path #:importance road-type)
                    (roads island)))
            (update-edges-places island from (car path) (cdr path))
            #t)
          #f))))
;
(define-method (road-type-between (c1 <city>) (c2 <city>))
  (cond
    ((and (eq? (size c1) #:city) (eq? (size c2) #:city)) #:main-road)
    ((and (eq? (size c1) #:town) (eq? (size c2) #:city)) #:secondary-road)
    ((and (eq? (size c1) #:city) (eq? (size c2) #:town)) #:secondary-road)
    ((and (eq? (size c1) #:town) (eq? (size c2) #:town)) #:secondary-road)
    (#t #:other-road)))

(define-method (city-big-or-bigger? (c1 <city>) (c2 <city>))
  (let ((s1 (size c1))
        (s2 (size c2)))
    (or (eq? s1 #:city)
        (and (eq? s1 #:town) (eq? s2 #:town))
        (and (eq? s1 #:town) (eq? s2 #:village))
        (and (eq? s1 #:village) (eq? s2 #:village)))))

(define-method (city-small-or-smaller? (c1 <city>) (c2 <city>))
  (let ((s1 (size c1))
        (s2 (size c2)))
    (or (eq? s1 #:village)
        (and (eq? s1 #:town) (eq? s2 #:town))
        (and (eq? s1 #:town) (eq? s2 #:city))
        (and (eq? s1 #:city) (eq? s2 #:city)))))
;
(define-method (build-roads (island <island>))
  (if (not (simple-generator? island))
    (let* ((all-cities (filter (lambda (x) (eq? (size x) #:city)) (cities island)))
          (all-towns (filter (lambda (x) (eq? (size x) #:town)) (cities island)))
          (all-villages (filter (lambda (x) (eq? (size x) #:village)) (cities island)))
          (all-cities-towns (append all-cities all-towns))
          )
      ; Link every neighbour cities
      (measure-time "Initial roads"
        (for-each
          (lambda (x)
            (let ((capital (capital-city x))
                  (neighbour-cities
                    (hash-map->list
                      (lambda (k v)
                        (capital-city k))
                      (neighbours x))))
              (for-each
                (lambda (y)
                  (if (city-small-or-smaller? capital y)
                      (add-road island capital y (road-type-between capital y))))
                  neighbour-cities)))
          (subdivision island)))
      (measure-time "Road importance corrections"
        ; Correct the importance of the roads by linking each cities to the two closest cities
        (for-each
          (lambda (x)
            (let* ((cls (closests x all-cities))
                  (first (and cls (not (null? cls)) (car cls)))
                  (second (and first (not (null? (cdr cls))) (cadr cls))))
              (and first (add-road island x first #:main-road))
              (and second (add-road island x second #:main-road))))
          all-cities)
        ; Correct the importance of the roads by linking each town to the two closest cities or towns
        (for-each
          (lambda (x)
            (let* ((cls (closests x all-cities-towns))
                  (first (and cls (not (null? cls)) (car cls)))
                  (second (and first (not (null? (cdr cls))) (cadr cls))))
              (and first (add-road island x first #:secondary-road))
              (and second (add-road island x second #:secondary-road))))
          all-towns))
      ; Sort the roads by order of importance (lower to higher)
      (set! (roads island)
            (sort
              (roads island)
              (lambda (x y)
                (or (and (eq? (importance x) #:other-road) (eq? (importance y) #:secondary-road))
                    (and (eq? (importance x) #:other-road) (eq? (importance y) #:main-road))
                    (and (eq? (importance x) #:secondary-road) (eq? (importance y) #:main-road))))))
    )))

;;;;
;; Island generator
(define-method (generate-island (width <integer>) (height <integer>) (tile-size <integer>) (simple? <boolean>))
  (measure-time "Island generation total time"
    (let ((island
            (measure-time "Altitude initialization"
              (make-island width height tile-size simple?))))
      (measure-time "Erosion"
        (erode island))
      (measure-time "Flood the sea"
        (flood-sea island))
      (measure-time "Inverse sinkholes"
        (inverse-sinkhole island))
      (measure-time "Compute temperatures"
        (compute-temperatures island))
      (measure-time "Simulate rainfalls"
        (simulate-rainfalls island))
      (measure-time "Init moisture - Find river springs"
        (init-moisture-and-find-river-spring-faces island))
      (measure-time "Compute altitude of vertices"
        (compute-vertices-altitude island))
      (measure-time "Draw rivers"
        (draw-rivers island))
      (measure-time "Clean-up rivers and lakes"
        (clean-up-rivers-lakes island))
      (measure-time "Blur moistures"
        (blur-moistures island))
      (measure-time "Compute biomes"
        (compute-biomes island))
      (measure-time "Place cities"
        (place-cities island))
      (measure-time "Compute territories"
        (compute-territories island))
      (measure-time "Build roads"
        (build-roads island))
      island)))
