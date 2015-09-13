;; Vector widgets: scripted vector graphics
(define-module (ffch vectorwidgets)
  #:version (0 0 1)
  #:use-module (oop goops)
  #:use-module (ffch colors)
  #:use-module (ffch containers)
  #:use-module (ffch vectorgraphics)
  #:export (vectorwidgets-scripts
            vectorwidgets-button
            vectorwidgets-combo
           )
  #:re-export (<container-type> <content-type>
               id name-class style contents empty?
               attribute->sxml-attribute
              )
)

;;;;
;; Scripts needed for vectorwidgets
(define-method (vectorwidgets-scripts)
  (list
    (vectorwidgets-scripts-button)
    (vectorwidgets-scripts-combo)))

;;;;
;; Buttons
(define-method (vectorwidgets-scripts-button)
  (script
    "function updateButtonColor(button, color) {"
    "  button.getElementsByClassName('button-back')[0].style['fill'] = color;"
    "}"
    "function updateButtonTitle(button, text) {"
    "  button.getElementsByClassName('button-text')[0].textContent = text;"
    "}"
  ))

(define-class <vectorwidgets-button> (<object>)
  (id #:getter id #:init-form #f)
  (topleft #:getter topleft #:init-form (point 0 0))
  (width #:getter width #:init-form 0)
  (height #:getter height #:init-form 0)
  (fill-color #:getter fill-color #:init-form #f)
  (fill-color-mouse-over #:getter fill-color-mouse-over #:init-form #f)
  (fill-color-mouse-click #:getter fill-color-mouse-click #:init-form #f)
  (stroke-color #:getter stroke-color #:init-form #f)
  (stroke-width #:getter stroke-width #:init-form #f)
  (title #:getter title #:init-form #f)
  (font-size #:getter font-size #:init-form #f)
  (font-family #:getter font-family #:init-form #f)
  (on-click #:getter on-click #:init-form #f))

(define-method (update-button-color (button <vectorwidgets-button>) (color <applicable>))
  (and (color button)
       (string-append
         "updateButtonColor(this, '"
         (css-value (color button))
         "');")))

(define-syntax vectorwidgets-button
  (syntax-rules ()
    ((_ (slot val) ...)
     (let ((button (make <vectorwidgets-button>)))
       (begin
         (slot-set! button (quote slot) val) ...)
       (area ((id (id button))
              (transforms (list (translation (topleft button))))
              (on-click (on-click button))
              (on-mouse-over (update-button-color button fill-color-mouse-over))
              (on-mouse-out (update-button-color button fill-color))
              (on-mouse-down (update-button-color button fill-color-mouse-click))
              (on-mouse-up (or (update-button-color button fill-color-mouse-over)
                               (update-button-color button fill-color)))
             )
        (rectangle
          (name-class "button-back")
          (width (width button))
          (height (height button))
          (style
            (shape-style
              (fill-color (fill-color button))
              (stroke-color (stroke-color button))
              (stroke-width (stroke-width button)))))
        (text
          ((name-class "button-text")
           (topleft (point 5 (inexact->exact (floor (+ (/ (height button) 2) 5)))))
           (style
             (shape-style
               (font-size (font-size button))
               (font-family (font-family button)))))
          (title button)))))))

;;;;
;; Combo buttons:
;; a list of buttons linked together: one is in the pushed state while the others are unpushed
(define-method (vectorwidgets-scripts-combo)
  (script
    "var comboActiveButton = new Object();"
    "function updateComboButtonColor(comboId, button, color) {"
    "  if (comboActiveButton[comboId] != button) {"
    "    updateButtonColor(button, color);"
    "  }"
    "}"
    "function changeCombo(comboId, button, defaultColor, activeColor) {"
    "  if (comboActiveButton[comboId] != button) {"
    "    if (comboActiveButton[comboId] != null) {"
    "      updateButtonColor(comboActiveButton[comboId], defaultColor);"
    "    }"
    "    updateButtonColor(button, activeColor);"
    "    comboActiveButton[comboId] = button;"
    "  }"
    "}"
  ))

(define-class <vectorwidgets-combo> (<object>)
  (id #:getter id #:init-form #f)
  (topleft #:getter topleft #:init-form (point 0 0))
  (button-width #:getter button-width #:init-form 0)
  (button-height #:getter button-height #:init-form 0)
  (fill-color-inactive #:getter fill-color-inactive #:init-form #f)
  (fill-color-inactive-mouse-over #:getter fill-color-inactive-mouse-over #:init-form #f)
  (fill-color-active #:getter fill-color-active #:init-form #f)
  (stroke-color #:getter stroke-color #:init-form #f)
  (stroke-width #:getter stroke-width #:init-form #f)
  (font-size #:getter font-size #:init-form #f)
  (font-family #:getter font-family #:init-form #f)
  (on-click #:getter on-click #:init-form #f)
  (titles #:getter titles #:init-form #f)
  (default #:getter default #:init-form #f)
)

(define-method (update-combo-color (combo <vectorwidgets-combo>) (color <applicable>))
  (and (color combo)
       (string-append
         "updateComboButtonColor('" (id combo) "', this, '"
         (css-value (color combo))
         "');")))

(define-syntax vectorwidgets-combo
  (syntax-rules ()
    ((_ (slot val) ...)
     (let ((combo (make <vectorwidgets-combo>))
           (nb-button -1)
          )
       (begin
         (slot-set! combo (quote slot) val) ...)
       (area ((id (id combo)))
         (map
           (lambda (title)
             (set! nb-button (+ 1 nb-button))
             (area ((transforms (list (translation (point (x (topleft combo))
                                                          (+ (y (topleft combo))
                                                             (* nb-button (button-height combo)))))))
                    (on-click
                      (string-append
                        "if (this != comboActiveButton['" (id combo) "']) {"
                        (on-click combo)
                        "changeCombo('" (id combo) "', this, '"
                        (css-value (fill-color-inactive combo)) "', '"
                        (css-value (fill-color-active combo)) "');"
                        "}"))
                    (on-mouse-over (update-combo-color combo fill-color-inactive-mouse-over))
                    (on-mouse-out (update-combo-color combo fill-color-inactive))
                   )
               (rectangle
                 (name-class "button-back")
                 (width (button-width combo))
                 (height (button-height combo))
                 (style
                   (shape-style
                     (fill-color ((if (equal? title (default combo)) fill-color-active fill-color-inactive) combo))
                     (stroke-color (stroke-color combo))
                     (stroke-width (stroke-width combo)))))
               (text
                 ((name-class "button-text")
                  (topleft (point 5 (inexact->exact (floor (+ (/ (button-height combo) 2) 5)))))
                  (style
                    (shape-style
                      (font-size (font-size combo))
                      (font-family (font-family combo)))))
                 title)
               ))
           (titles combo)))))))
