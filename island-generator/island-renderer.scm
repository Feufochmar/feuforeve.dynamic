;; Island Output
(define-module (island-generator island-renderer)
  #:use-module (oop goops)
  #:use-module (sxml simple)
  #:use-module (island-generator island-generator)
  #:use-module (ffch vectorgraphics)
  #:use-module (ffch vectorwidgets)
  #:use-module (ffch vectorgraphics-exporters sxml-svg)
  #:use-module (ffch colors)
  #:use-module (ffch hexgrid)
  #:export (render-island)
)

(define-method (blank-color (tile <tile>))
  (and
    (not (sea? (biome tile)))
    (if (lake? (biome tile))
        (display-color (biome tile))
        (hsl-color 0 0 100))))

(define-method (biome-color (tile <tile>))
  (and
    (not (sea? (biome tile)))
    (display-color (biome tile))))

(define-method (elevation-color (alt <number>))
  (cond
    ((< 3000 alt) (hsl-color 0 0 50))
    ((< 2600 alt) (hsl-color 0 0 40))
    ((< 2300 alt) (hsl-color 25 25 30))
    ((< 2000 alt) (hsl-color 25 50 20))
    ((< 1750 alt) (hsl-color 25 50 25))
    ((< 1500 alt) (hsl-color 25 50 35))
    ((< 1250 alt) (hsl-color 25 50 45))
    ((< 1000 alt) (hsl-color 35 60 50))
    ((< 800 alt) (hsl-color 35 65 55))
    ((< 650 alt) (hsl-color 40 80 60))
    ((< 500 alt) (hsl-color 55 85 75))
    ((< 400 alt) (hsl-color 75 80 65))
    ((< 300 alt) (hsl-color 90 75 60))
    ((< 200 alt) (hsl-color 90 75 45))
    ((< 150 alt) (hsl-color 95 80 40))
    ((< 100 alt) (hsl-color 100 90 35))
    ((< 50 alt) (hsl-color 110 90 30))
    (#t (hsl-color 110 100 25))))

(define-method (elevation-color (tile <tile>))
  (and
    (not (sea? (biome tile)))
    (if (lake? (biome tile))
        (display-color (biome tile))
        (elevation-color (altitude tile)))))

(define-method (subdivision-color (tile <tile>))
  (and
    (not (sea? (biome tile)))
    (if (lake? (biome tile))
        (display-color (biome tile))
        (if (territory tile)
            (display-color (territory tile))
            (hsl-color 0 0 100)))))

(define-method (tile-renderer (color-renderer <applicable>))
  (lambda (tile)
    (let ((col (color-renderer tile)))
      (and col
           (shape-style
             (stroke-color col)
             (fill-color col))))))

(define-method (river-renderer)
  (shape-style
    (stroke-color (display-color (get-biome #:lake)))
    (stroke-width 2)
    (fill-color (no-color))))

(define-method (road-renderer (type <keyword>))
  (shape-style
    (stroke-color
      (if (eq? #:other-road type)
          (hsl-color 0 0 0)
          (hsl-color 0 100 50)))
    (stroke-width
      (cond
        ((eq? #:main-road type) 3)
        ((eq? #:secondary-road type) 2)
        (#t 1)))
    (fill-color (no-color))))

(define-method (city-renderer (size <keyword>))
  (shape-style
    (stroke-color (hsl-color 0 0 0))
    (stroke-width (if (eq? #:city size) 2 1))
    (fill-color (hsl-color 0 0 100))))

(define-method (path-movements (island <island>) (x->point <applicable>) (points <list>))
  (let ((1st? #t))
    (map
      (lambda (x)
        ((if 1st? (begin (set! 1st? #f) move-to) line-to)
          (x->point (grid-layout island) x)))
      points)))

(define-method (zone-description (offset <point>) (color <color>) (description <string>))
  (area ((transforms (list (translation offset))))
    (rectangle (width 30) (height 15)
               (style
                 (shape-style
                   (stroke-color (hsl-color 0 0 0))
                   (stroke-width 1)
                   (fill-color color))))
    (text ((topleft (point 40 12))
           (style
             (shape-style
               (font-size 12)
               (font-family "serif"))))
      description)))

(define-method (path-description (offset <point>) (stl <shape-style>) (description <string>))
  (area ((transforms (list (translation offset))))
    (path (style stl)
          (movements (list (move-to (point 0 10)) (line-to (point 10 5))
                           (line-to (point 20 10)) (line-to (point 30 5)))))
    (text ((topleft (point 40 12))
           (style
             (shape-style
               (font-size 12)
               (font-family "serif"))))
      description)))

(define-method (point-description (offset <point>) (stl <shape-style>)
                                  (rad <number>) (description <string>))
  (area ((transforms (list (translation offset))))
    (circle (style stl)
            (radius rad)
            (center (point 15 7)))
    (text ((topleft (point 40 12))
           (style
             (shape-style
               (font-size 12)
               (font-family "serif"))))
      description)))


(define-method (captions (island <island>))
  (area ((id "Captions") (transforms (list (translation (point (+ 100 (image-width island)) 0)))))
    ; Sea & lake
    (zone-description (point 5 25) (display-color (get-biome #:sea)) "Sea")
    (zone-description (point 5 40) (display-color (get-biome #:lake)) "Lake")
    ; Rivers
    (path-description (point 5 70) (river-renderer) "Rivers")
    ; Cities
    (point-description (point 5 100) (city-renderer #:city) 6 "City")
    (point-description (point 5 115) (city-renderer #:town) 4 "Town")
    (point-description (point 5 130) (city-renderer #:village) 2 "Village")
    ; Roads
    (if (simple-generator? island)
        (list)
        (list
          (path-description (point 5 160) (road-renderer #:main-road) "Main roads")
          (path-description (point 5 175) (road-renderer #:secondary-road) "Secondary roads")
          (path-description (point 5 190) (road-renderer #:other-road) "Other roads")))
    ;
    (area ((transforms (list (translation (point 5 230)))))
      (area ((id "caption-Biomes")(style (shape-style (visible? #f))))
        (let ((idx -1))
          (map
            (lambda (b)
              (if (not (or (sea? b) (lake? b)))
                  (begin
                    (set! idx (+ 1 idx))
                    (zone-description (point 0 (* 15 idx)) (display-color b) (name b)))
                  (list)))
            (get-ordered-biomes))))
      (area ((id "caption-Elevation")(style (shape-style (visible? #f))))
        (let ((idx -1))
          (map
            (lambda (elev)
              (set! idx (+ 1 idx))
              (zone-description (point 0 (* 15 idx)) (elevation-color (vector-ref elev 0)) (vector-ref elev 1)))
            (list
              (vector 3001 "> 3000 m")
              (vector 2601 "2600 - 3000 m")
              (vector 2301 "2300 - 2600 m")
              (vector 2001 "2000 - 2300 m")
              (vector 1751 "1750 - 2000 m")
              (vector 1501 "1500 - 1750 m")
              (vector 1251 "1250 - 1500 m")
              (vector 1001 "1000 - 1250 m")
              (vector 801 "800 - 1000 m")
              (vector 651 "650 - 800 m")
              (vector 501 "500 - 650 m")
              (vector 401 "400 - 500 m")
              (vector 301 "300 - 400 m")
              (vector 201 "200 - 300 m")
              (vector 151 "150 - 200 m")
              (vector 101 "100 - 150 m")
              (vector 51 "50 - 100 m")
              (vector 1 "0 - 50 m")))))
      (area ((id "caption-Subdivisions")(style (shape-style (visible? #f))))
        (rectangle (width 1) (height 1) (style (fill-color (no-color))))
      )
      (area ((id "caption-Blank"))
        (rectangle (width 1) (height 1) (style (fill-color (no-color))))
      )

  )))


(define-method (render-island (island <island>) (port <port>))
  (sxml->xml
    (vectorgraphics->sxml-svg
      (vector-image ((width (+ (image-width island) 300))(height (image-height island)))
        ;
        (rectangle (width (+ (image-width island) 300)) (height (image-height island))
                   (style (fill-color (hsl-color 225 85 85))))
        ; Map
        (area ((transforms (list (translation (point 100 0)))))
          ; Sea is not rendered
          (rectangle (width (image-width island)) (height (image-height island))
              (style (fill-color (display-color (get-biome #:sea)))))
          ; Elevation
          (hexgrid->area
            (hexgrid (grid island))
            (hexpoint-renderer (tile-renderer elevation-color))
            (id "layer-Elevation")
            (style (shape-style (stroke-width 1)(visible? #f))))
          ; Biomes
          (hexgrid->area
            (hexgrid (grid island))
            (hexpoint-renderer (tile-renderer biome-color))
            (id "layer-Biomes")
            (style (shape-style (stroke-width 1)(visible? #f))))
          ; Administrative subdivisions
          (hexgrid->area
            (hexgrid (grid island))
            (hexpoint-renderer (tile-renderer subdivision-color))
            (id "layer-Subdivisions")
            (style (shape-style (stroke-width 1)(visible? #f))))
          ; Blank map
          (hexgrid->area
            (hexgrid (grid island))
            (hexpoint-renderer (tile-renderer blank-color))
            (id "layer-Blank")
            (style (stroke-width 1)))
          ;
          ; Rivers
          (area ((id "rivers"))
            (hash-map->list
              (lambda (k v)
                (path
                  (style (river-renderer))
                  (movements
                    (path-movements
                      island hexvertex->point
                      (river-vertices island (hash-ref (river-points island) k) (list))))))
              (river-springs island)))
          ; Roads
          (if (simple-generator? island)
              (list)
              (area ((id "roads"))
                (map
                  (lambda (x)
                    (path
                      (style (road-renderer (importance x)))
                      (movements (path-movements island hexpoint->point (road-path x)))))
                  (roads island))))
          ; Cities
          (area ((id "cities"))
            (map
              (lambda (x)
                (circle
                  (center (hexpoint->point (grid-layout island) (hex x)))
                  (radius
                    (cond
                      ((eq? #:city (size x)) 6)
                      ((eq? #:town (size x)) 4)
                      (#t 2)))
                  (style (city-renderer (size x)))))
              (cities island)))
          ) ; End of map
        ; Captions
        (captions island)
        ; Controls
        ; Scripts
        (script
          "function toggleVisibility(button, what) {"
          "  var target = document.getElementById(what);"
          "  var visible = target.style.display;"
          "  if (visible == 'none') {"
          "    target.style.display = 'inline';"
          "    updateButtonTitle(button, 'Hide ' + what);"
          "  } else {"
          "    target.style.display = 'none';"
          "    updateButtonTitle(button, 'Show ' + what);"
          "  }"
          "}"
          "var activeBackground = 'Blank';"
          "function toggleLayer(buttonCombo) {"
          "  activeBackground = buttonCombo.getElementsByClassName('button-text')[0].textContent;"
          "  ['Elevation', 'Biomes', 'Subdivisions', 'Blank'].forEach("
          "    function (current, index, array) {"
          "      var targetLayer = document.getElementById('layer-' + current);"
          "      var targetCaption = document.getElementById('caption-' + current);"
          "      if (current != activeBackground) {"
          "        targetLayer.style.display = 'none';"
          "        targetCaption.style.display = 'none';"
          "      } else {"
          "        targetLayer.style.display = 'inline';"
          "        targetCaption.style.display = 'inline';"
          "      }"
          "    });"
          "}"
          )
        (vectorwidgets-scripts)
        ;
        (vectorwidgets-combo
          (id "map-background-combo")
          (topleft (point 5 5))
          (button-width 90)
          (button-height 40)
          (fill-color-inactive (hsl-color 0 0 60))
          (fill-color-inactive-mouse-over (hsl-color 0 0 75))
          (fill-color-active (hsl-color 0 0 90))
          (stroke-color (hsl-color  0 0 20))
          (stroke-width 1)
          (font-size 12)
          (font-family "serif")
          (on-click "toggleLayer(this);")
          (titles (list "Elevation" "Biomes" "Subdivisions" "Blank"))
          (default "Blank"))
        ;
        (map
          (lambda (x)
            (vectorwidgets-button
              (id (string-append "toggle-" (car x)))
              (topleft (point 5 (+ 305 (* 40 (cdr x)))))
              (width 90)
              (height 40)
              (fill-color (hsl-color 0 0 60))
              (fill-color-mouse-over (hsl-color 0 0 75))
              (fill-color-mouse-click (hsl-color 0 0 90))
              (stroke-color (hsl-color 0 0 20))
              (stroke-width 1)
              (title (string-append "Hide " (car x)))
              (font-size 12)
              (font-family "serif")
              (on-click (string-append "toggleVisibility(this, '" (car x) "');"))))
          (if (simple-generator? island)
            (list
              (cons "rivers" 0)
              (cons "cities" 1))
            (list
              (cons "rivers" 0)
              (cons "cities" 1)
              (cons "roads" 2))
            ))
      ))
    port)
  (newline port))
