;; North-Citrican language for the word generator
;; North-Citrican is based on Spanish.
(language north-citrican
  (names
    (given-names-min-nb 1)
    (given-names-max-nb 2)
    (name-rules
      (full-name
        (masculine GiNa% FaGMM FaGFF))
      (short-name
        (masculine GiNa FaGFF)
        (feminine GiNa FaGFF))
      (father-short-name
        (masculine GiNaF FaGFF)
        (feminine GiNaF FaGMF))
      (mother-short-name
        (masculine GiNaM FaGFM)
        (feminine GiNaF FaGMM))))
  (words
    (generator-order 3)
    (phonemes
      (sylbrk "." "" "") (stress "ˈ" "" "")
      ;; Vowels
      (a "a" "a" "a") (e "e" "e" "e") (i "i" "i" "i") (o "o" "o" "o") (u "u" "u" "u")
      (aa "aː" "aa" "aa")
      (a/ "a" "á" "á") (e/ "e" "é" "é") (i/ "i" "í" "í") (o/ "o" "ó" "ó") (u/ "u" "ú" "ú")
      (I "j" "i" "i") (U "w" "u" "u") (Y "j" "y" "y")
      ;; Consonents
      (b "b" "b" "b") (c "k" "c" "c") (C "θ" "c" "c") (ch "tʃ" "ch" "ch") (d "d" "d" "d")
      (f "f" "f" "f") (g "ɡ" "g" "g") (G "x" "g" "g") (gu "ɡ" "gu" "gu") (h "" "h" "h")
      (j "x" "j" "j") (l "l" "l" "l") (ll "ʎ" "ll" "ll") (m "m" "m" "m") (n "n" "n" "n")
      (n~ "ɲ" "ñ" "ñ") (p "p" "p" "p") (qu "k" "qu" "qu") (r "ɾ" "r" "r") (R "r" "r" "r")
      (rr "r" "r" "r") (s "s" "s" "s") (t "t" "t" "t") (v "b" "v" "v") (x "ks" "x" "x")
      (xj "x" "x" "x") (X "s" "x" "x") (z "θ" "z" "z"))
    (examples
      ;; Masculine given names
      (d a sylbrk stress n I e l)
      (stress p a sylbrk b l o)
      (a sylbrk l e sylbrk stress j a n sylbrk d r o)
      (d a sylbrk stress v i d)
      (stress m a sylbrk r I o)
      (j a sylbrk stress v I e r)
      (stress l u sylbrk c a s)
      (n i sylbrk c o sylbrk stress l a/ s)
      (stress j o r sylbrk G e)
      (stress c a r sylbrk l o s)
      (s a n sylbrk stress t I a sylbrk g o)
      (s a sylbrk stress m U e l)
      (j o sylbrk a sylbrk stress qu i/ n)
      (a sylbrk g u s sylbrk stress t i/ n)
      (stress j U a n)
      (j o sylbrk stress s e/)
      (a n sylbrk stress d r e/ s)
      (l e sylbrk o sylbrk stress n a r sylbrk d o)
      (m i sylbrk stress gu e l)
      (R o sylbrk stress d r i sylbrk g o)
      (i g sylbrk stress n a sylbrk C I o )
      (aa sylbrk stress r o/ n)
      (f e r sylbrk stress n a n sylbrk d o)
      (f r a n sylbrk stress C i s sylbrk c o)
      (a n sylbrk stress t o sylbrk n I o)
      (stress l U i s)
      (i sylbrk s a sylbrk stress a c)
      (stress m a/ sylbrk x i sylbrk m o)
      (stress p e sylbrk d r o)
      (e sylbrk stress d U a r sylbrk d o)
      (s i sylbrk stress m o/ n)
      (j o sylbrk stress s U e/)
      (i sylbrk stress v a n)
      (a l sylbrk stress v a sylbrk r o)
      (j a sylbrk stress c o sylbrk b o)
      (j e sylbrk stress s u/ s)
      (c a sylbrk stress m i sylbrk l o)
      (e sylbrk stress l i/ sylbrk a s)
      (stress a I sylbrk m e)
      (j a sylbrk stress c o b)
      (xj i sylbrk stress m e sylbrk n o)
      (X i sylbrk stress m e sylbrk n o)
      (j i sylbrk stress m e sylbrk n o)
      (m a sylbrk stress r I a sylbrk n o)
      (l u sylbrk stress C I a sylbrk n o)
      (stress j u sylbrk l I o)
      (j u sylbrk stress l I a/ n)
      (stress h u sylbrk g o)
      (a sylbrk stress d r I a/ n)
      (stress d I e sylbrk g o)
      (e sylbrk m i sylbrk stress l I a sylbrk n o)
      (j e sylbrk stress r o/ sylbrk n i sylbrk m o)
      (e sylbrk stress m a sylbrk n U e l)
      (stress m a sylbrk n U e l)
      (stress m a r sylbrk c o s)
      (stress i sylbrk z a n)
      (stress s e r sylbrk G I o)
      (m a r sylbrk stress t i/ n)
      (s e sylbrk b a s sylbrk stress t I a/ n)
      (m a sylbrk stress t i/ sylbrk a s)
      (m a sylbrk stress t e sylbrk o)
      (b e n sylbrk j a sylbrk stress m i/ n)
      (t o sylbrk stress m a/ s)
      (stress g a sylbrk b r I e l)
      (f e sylbrk stress l i sylbrk p e)
      (stress a/ n sylbrk G e l)
      (e sylbrk stress m i sylbrk l I o)
      (stress b r u sylbrk n o)
      (v i sylbrk stress C e n sylbrk t e)
      (v a sylbrk l e n sylbrk stress t i sylbrk n o)
      (s a n sylbrk stress t i sylbrk n o)
      (stress I a n)
      (f a sylbrk stress c u n sylbrk d o)
      (R a sylbrk stress f a sylbrk e l)
      (stress f r a n sylbrk c o)
      (R i sylbrk stress c a r sylbrk d o)
      (b a U sylbrk stress t i s sylbrk t a)
      (c r i s sylbrk stress t o/ sylbrk b a l)
      (v a sylbrk l e n sylbrk stress t i/ n)
      (e s sylbrk stress t e sylbrk b a n)
      (stress a sylbrk l a n)
      (a sylbrk stress l o n sylbrk s o)
      (d a sylbrk stress m I a/ n)
      (l o sylbrk stress r e n sylbrk z o)
      (l a U sylbrk stress t a sylbrk r o)
      (stress d a n sylbrk t e)
      (f e r sylbrk d i sylbrk stress n a n sylbrk d o)
      (h e r sylbrk stress n a/ n)
      (h e r sylbrk stress n a n sylbrk d o)
      (stress s a n sylbrk ch o)
      ;; Feminine given names
      (l u sylbrk stress C i/ sylbrk a)
      (m a sylbrk stress r i/ sylbrk a)
      (stress s a sylbrk r a)
      (stress l a U sylbrk r a)
      (stress a sylbrk n a)
      (m a sylbrk stress r I a sylbrk n a)
      (l u sylbrk stress C I a sylbrk n a)
      (g a sylbrk stress b r I e sylbrk l a)
      (v i c sylbrk stress t o sylbrk r I a)
      (xj i sylbrk stress m e sylbrk n a)
      (j i sylbrk stress m e sylbrk n a)
      (n a sylbrk stress t a sylbrk l I a)
      (a sylbrk stress m a n sylbrk d a)
      (stress j U a sylbrk n a)
      (a n sylbrk stress d r e sylbrk a)
      (a sylbrk g u s sylbrk stress t i sylbrk n a)
      (a sylbrk stress b r i l)
      (f l o sylbrk stress r e n sylbrk C I a)
      (stress m a I sylbrk t e)
      (r e sylbrk stress G i sylbrk n a)
      (a sylbrk stress d r I a sylbrk n a)
      (j u sylbrk l i sylbrk stress a sylbrk n a)
      (i sylbrk s a sylbrk stress b e l)
      (stress l o sylbrk l a)
      (d o sylbrk stress l o sylbrk r e s)
      (o sylbrk stress l i sylbrk v I a)
      (i sylbrk s i sylbrk stress d o sylbrk r a)
      (m a g sylbrk d a sylbrk stress l e sylbrk n a)
      (R o sylbrk stress d r i sylbrk g a)
      (stress c a r sylbrk l a)
      (a n sylbrk stress t o sylbrk n I a)
      (a sylbrk l e sylbrk stress j a n sylbrk d r a)
      (c a sylbrk stress m i sylbrk l a)
      (f r a n sylbrk stress C i s sylbrk c a)
      (j a sylbrk stress c o sylbrk b a)
      (stress j u sylbrk l I a)
      (stress p a U sylbrk l a)
      (stress c l a U sylbrk d I a)
      (d a sylbrk stress n I e sylbrk l a)
      (m a r sylbrk stress t i sylbrk n a)
      (s o sylbrk stress f i/ sylbrk a)
      (v a sylbrk stress l e sylbrk r I a)
      (stress a l sylbrk b a)
      (stress m a r sylbrk t a)
      (i sylbrk stress r e sylbrk n e)
      (stress c a r sylbrk m e n)
      (i sylbrk s a sylbrk stress b e sylbrk ll a)
      (v a sylbrk l e n sylbrk stress t i sylbrk n a)
      (c a sylbrk t a sylbrk stress l i sylbrk n a)
      (j u sylbrk stress l I e sylbrk t a)
      (R e sylbrk stress n a sylbrk t a)
      (e sylbrk stress m i sylbrk l I a)
      (stress z o sylbrk e)
      (f e r sylbrk stress n a n sylbrk d a)
      (m a sylbrk stress n U e sylbrk l a)
      (g U a sylbrk d a sylbrk stress l u sylbrk p e)
      (e sylbrk stress l e sylbrk n a)
      (stress b I a n sylbrk c a)
      (i sylbrk stress v a sylbrk n a)
      (c a sylbrk r o sylbrk stress l i sylbrk n a)
      (R a sylbrk f a sylbrk stress e sylbrk l a)
      (stress a l sylbrk m a)
      (v I o sylbrk stress l e sylbrk t a)
      (s a sylbrk l o sylbrk stress m e/)
      (j a z sylbrk stress m i/ n)
      (d e l sylbrk stress f i sylbrk n a)
      (c o n sylbrk stress s t a n sylbrk z a)
      (p a U sylbrk stress l i sylbrk n a)
      (R e sylbrk stress b e sylbrk c a)
      (m i sylbrk c a sylbrk stress e sylbrk l a)
      (f a sylbrk stress b I a sylbrk n a)
      (m i sylbrk stress r a n sylbrk d a)
      (j o sylbrk s e sylbrk stress f i sylbrk n a)
      (a sylbrk stress l e sylbrk j a)
      (stress f a/ sylbrk t i sylbrk m a)
      (m a sylbrk stress l e sylbrk n a)
      (R o sylbrk stress m i sylbrk n a)
      (a sylbrk stress m e sylbrk l I a)
      (a sylbrk stress r I a d sylbrk n a)
      (s i l sylbrk stress v a sylbrk n a)
      (stress c l a sylbrk r a)
      (j o sylbrk stress s e sylbrk f a)
      (a sylbrk stress m a sylbrk Y a)
    )))
