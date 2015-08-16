;; Floraverse character generator
;; English language utils methods
(define-module (flora-character-generator english)
  #:version (0 0 1)
  #:use-module (oop goops)
  #:export (ordinal get-undefined-article with-undefined-article 3rd-person-of plural-of)
  #:duplicates (merge-generics))

;;
(define-method (ordinal (N <integer>))
  (cond
    ((and (not (eq? 11 (modulo N 100))) (eq? 1 (modulo N 10))) (string-append (number->string N) "st"))
    ((and (not (eq? 12 (modulo N 100))) (eq? 2 (modulo N 10))) (string-append (number->string N) "nd"))
    ((and (not (eq? 13 (modulo N 100))) (eq? 3 (modulo N 10))) (string-append (number->string N) "rd"))
    (#t (string-append (number->string N) "th"))))

;;
(define-method (get-undefined-article (str <string>))
  (let ((initial (string-ref (string-downcase str 0 1) 0)))
    (if (string-contains "aeiou" (string initial))
      "an"
      "a")))
;
(define-method (with-undefined-article (str <string>))
  (string-append (get-undefined-article str) " " str))

;; Guess 3rd person of a verb
(define-method (3rd-person-of (verb <string>) (plural? <boolean>))
  (cond
   ((equal? "be" verb) (if plural? "are" "is"))
   ((equal? "have" verb) (if plural? "have" "has"))
   ;;
   ((or (string-suffix? "s" verb) (string-suffix? "sh" verb) (string-suffix? "ch" verb)
        (string-suffix? "x" verb) (string-suffix? "o" verb))
    (if plural? verb (string-append verb "es")))
   ;;
   ((or (string-suffix? "ay" verb) (string-suffix? "ey" verb) (string-suffix? "iy" verb)
       (string-suffix? "oy" verb) (string-suffix? "uy" verb))
    (if plural? verb (string-append verb "s")))
   ((string-suffix? "y" verb)
    (if plural? verb (string-append (string-drop-right verb 1) "ies")))
   ;;
   (#t
    (if plural? verb (string-append verb "s")))
  ))

;; Guess plural of a noun
(define-method (plural-of (str <string>))
  (cond
   ((string-suffix? "mouse" str)
    (string-append (string-drop-right str 5) "mice"))
   ((string-suffix? "louse" str)
    (string-append (string-drop-right str 5) "lice"))
   ;;
   ((string-suffix? "goose" str)
    (string-append (string-drop-right str 5) "geese"))
   ((string-suffix? "foot" str)
    (string-append (string-drop-right str 4) "feet"))
   ((string-suffix? "tooth" str)
    (string-append (string-drop-right str 5) "teeth"))
   ;;
   ((string-suffix? "man" str)
    (string-append (string-drop-right str 3) "men"))
   ;;
   ((or (string-suffix? "s" str) (string-suffix? "sh" str) (string-suffix? "ch" str)
        (string-suffix? "x" str) (string-suffix? "o" str))
    (string-append str "es"))
   ;;
   ((or (string-suffix? "ay" str) (string-suffix? "ey" str) (string-suffix? "iy" str)
        (string-suffix? "oy" str) (string-suffix? "uy" str))
    (string-append str "s"))
   ((string-suffix? "y" str)
    (string-append (string-drop-right str 1) "ies"))
   ;;
   ((string-suffix? "ff" str)
    (string-append (string-drop-right str 2) "ves"))
   ((string-suffix? "f" str)
    (string-append (string-drop-right str 1) "ves"))
   ((string-suffix? "fe" str)
    (string-append (string-drop-right str 2) "ves"))
   ;;
   (#t
    (string-append str "s"))
  ))
