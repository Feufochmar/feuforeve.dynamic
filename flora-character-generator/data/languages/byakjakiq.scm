(language byakjakiq
  (names
    (given-names-min-nb 1)
    (given-names-max-nb 1)
    (name-rules
      (full-name
        (masculine FaGFF GiNa OtNa)
        (feminine FaGMM GiNa OtNa))
      (short-name
        (masculine FaGFF GiNa)
        (feminine FaGMM GiNa))
      (father-short-name
        (masculine FaGFF GiNaF)
        (feminine FaGMF GiNaF))
      (mother-short-name
        (masculine FaGFM GiNaM)
        (feminine FaGMM GiNaM))))
  (words
    (generator-order 3)
    (phonemes
      ; (key pronounciation native-transcription latin-transcription)
      (sylbrk "." "" "") (stress "ˈ" "" "")
      ; Consonants (initials)
      (m- "m" "ᄆ" "m") (n- "n" "ᄂ" "n") (N- "" "ᄋ" "")
      ;
      (p- "p" "ᄇ" "p") (t- "t" "ᄃ" "t") (c- "tɕ" "ᄌ" "c") (k- "k" "ᄀ" "k")
      (b- "b" "ᄈ" "b") (d- "d" "ᄄ" "d") (j- "dʑ" "ᄍ" "j") (g- "ɡ" "ᄁ" "g")
      (P- "f" "ᄑ" "f") (T- "θ" "ᄐ" "v") (C-  "ɕ" "ᄎ" "q") (K- "x" "ᄏ" "x")
      ;
      (s- "s" "ᄉ" "s") (h- "h" "ᄒ" "h")
      (z- "z" "ᄊ" "z")
      ;
      (l- "l" "ᄅ" "l")
      ;
      ; Vowels (medials)
      (a "a" "ᅡ" "a") (e "ə" "ᅥ" "e") (o "o" "ᅩ" "o") (u "u" "ᅮ" "u")  (y "y" "ᅳ" "ü") (i "i" "ᅵ" "i")
      (ai "ɛ" "ᅢ" "ä") (ei "e" "ᅦ" "ë") (oi "ø" "ᅬ" "ö") (ui "wi" "ᅱ" "wi") (yi "ɥi" "ᅴ" "ẅi") ; (X+i)
      (ia "ja" "ᅣ" "ya") (ie "jə" "ᅧ" "ye") (io "jo" "ᅭ" "yo") (iu "ju" "ᅲ" "yu") ; (i+X)
      (iai "jɛ" "ᅤ" "yä") (iei "je" "ᅨ" "yë") ; (i+X+i)
      (oa "wa" "ᅪ" "wa") (ue "wə" "ᅯ" "we") ; (o/u+X)
      (oai "wɛ" "ᅫ" "wä") (uei "we" "ᅰ" "wë") ; (o/u+X+i)
      ;
      ; Consonants (finals)
      (-m "m" "ᆷ" "m") (-n "n" "ᆫ" "n") (-N "ŋ" "ᆼ" "ñ")
                        (-nc "ntɕ" "ᆬ" "nc")
                        (-nh "nh" "ᆭ" "nh")
      ;
      (-p "p" "ᆸ" "p") (-t "t" "ᆮ" "t") (-c "tɕ" "ᆽ" "c") (-k "k" "ᆨ" "k")
                                         (-j "dʑ" "ᆹ" "j") (-g "ɡ" "ᆩ" "g")
      (-P "f" "ᇁ" "f") (-T "θ" "ᇀ" "v") (-C  "ɕ" "ᆾ" "q") (-K "x" "ᆿ" "x")
                                                            (-ks "ks" "ᆪ" "ks")
      ;
      (-s "s" "ᆺ" "s") (-h "h" "ᇂ" "h")
      (-z "z" "ᆻ" "z")
      ;
      (-l "l" "ᆯ" "l")
      (-lm "lm" "ᆱ" "lm")
      (-lp "lp" "ᆲ" "lp") (-lk "lk" "ᆰ" "lk")
      (-lP "lf" "ᆵ" "lf") (-lT "lθ" "ᆴ" "lv")
      (-ls "ls" "ᆳ" "ls") (-lh "lh" "ᆶ" "lh")
    )
    (examples
      (N- a sylbrk b- a -t sylbrk d- o -n)
      (N- a sylbrk b- a sylbrk l- a -m)
      (N- a sylbrk b- e sylbrk z- e -t sylbrk h- i sylbrk b- u)
      (N- a sylbrk b- i sylbrk g- oi)
      (N- a sylbrk b- oa sylbrk k- a -ks)
      (N- a sylbrk b- oa sylbrk h- ai -l)
      (N- a sylbrk b- oa sylbrk K- a -s)
      (N- a sylbrk b- oa -k sylbrk s- a -s)
      (N- a sylbrk b- y -n sylbrk d- ia)
      (N- a sylbrk b- y sylbrk z- u)
      (N- a sylbrk k- a sylbrk t- oai -l)
      (N- a sylbrk C- a -m)
      (N- a sylbrk d- a sylbrk m- a -s)
      (N- a -t sylbrk t- a sylbrk j- a -l)
      (N- a sylbrk d- ai -s)
      (N- a sylbrk d- o sylbrk n- i -s)
      (N- a sylbrk d- oa sylbrk m- e sylbrk l- e -K)
      (N- a sylbrk d- oa sylbrk m- ei sylbrk l- ai -k)
      (N- a sylbrk d- oa sylbrk n- o -s)
      (N- ai -C sylbrk m- a)
      (N- a sylbrk g- a sylbrk l- ia sylbrk N- ue -t)
      (N- a sylbrk g- a sylbrk N- ue -s)
      (N- a sylbrk g- a sylbrk N- oai -s)
      (N- a sylbrk g- a sylbrk t- io -n)
      (N- a sylbrk g- a sylbrk t- o sylbrk d- ei sylbrk m- o -n)
      (N- a sylbrk g- ie -l)
      (N- a sylbrk n- ia -n)
      (N- a -g sylbrk n- ia -n)
      (N- a sylbrk g- oa -t sylbrk b- a -t sylbrk m- a -h sylbrk l- a -t)
      (N- a sylbrk g- oa sylbrk N- oai -s)
      (N- a sylbrk h- ui sylbrk m- a -n)
      (N- ai -m)
      (N- a sylbrk k- a sylbrk m- a sylbrk n- a -h)
      (N- a -k sylbrk b- a sylbrk b- a)
      (N- a sylbrk k- e -m sylbrk m- a sylbrk n- a -h)
      (N- a sylbrk k- o sylbrk m- a -n)
      (N- a sylbrk k- oa -n)
      (N- a -k sylbrk P- a -n)
      (N- a sylbrk l- a)
      (N- a sylbrk l- a -l)
      (N- a sylbrk l- a -s sylbrk t- oi)
      (N- a -l sylbrk P- a sylbrk d- ei)
      (N- a -l sylbrk P- a sylbrk N- oai -s)
      (N- a -lP)
      (N- a -l sylbrk g- o -l)
      (N- a -l sylbrk l- o sylbrk c- e -s)
      (N- a -l sylbrk l- o sylbrk c- ei)
      (N- a -l sylbrk l- u)
      (N- a sylbrk l- o sylbrk s- ei)
      (N- a -lp)
      (N- a -l sylbrk p- iai -l)
      (N- a -l sylbrk N- ui sylbrk n- a -k)
      (N- a -l sylbrk N- iu -n)
      (N- a -l sylbrk t- a -n sylbrk g- a sylbrk t- y sylbrk P- y -n)
      (N- a sylbrk m- a -n)
      (N- a sylbrk m- a sylbrk z- io -t)
      (N- a sylbrk m- ai sylbrk m- o -n)
      (N- a -m sylbrk d- y sylbrk s- ia -s)
      (N- a -m sylbrk d- u sylbrk s- ia -s)
      (N- a sylbrk m- o -n)
      (N- a sylbrk m- oa sylbrk m- o -n)
      (N- a -m sylbrk C- a -s sylbrk p- a -nc)
      (N- a sylbrk m- y)
      (N- a sylbrk m- i)
      (N- a sylbrk n- a sylbrk m- a sylbrk l- e -K)
      (N- a sylbrk n- a sylbrk m- a sylbrk l- ai -k)
      (N- a sylbrk n- a sylbrk m- ei sylbrk l- ai -k)
      (N- a sylbrk n- a -n sylbrk s- iei)
      (N- a sylbrk n- a sylbrk N- oa sylbrk z- ai -l)
      (N- a -n sylbrk c- i sylbrk t- i -P)
      (N- a -n sylbrk d- ai -n)
      (N- a -n sylbrk d- a sylbrk k- a)
      (N- a -n sylbrk d- oa -s)
      (N- a -n sylbrk d- uei -lp sylbrk h- u -s)
      (N- a -n sylbrk d- ue sylbrk N- a -l sylbrk P- u -s)
      (N- a -n sylbrk d- ui sylbrk N- a -g)
      (N- a -n sylbrk d- oa -l sylbrk P- y -s)
      (N- a -n sylbrk d- io sylbrk m- a sylbrk l- iu -s)
      (N- a -n sylbrk g- a sylbrk d- a)
      (N- a -n sylbrk g- a -t)
      (N- a -n sylbrk g- oi sylbrk b- o -t)
      (N- a -n sylbrk g- oa sylbrk m- ai sylbrk n- iu)
      (N- a -n sylbrk g- yi sylbrk b- o -j)
      (N- a sylbrk n- i sylbrk N- oa -n)
      (N- a -n sylbrk k- a)
      (N- a sylbrk n- a sylbrk b- ai -j)
      (N- a sylbrk n- a sylbrk b- ui)
      (N- a -n sylbrk b- ai -g)
      (N- a sylbrk n- i -n sylbrk g- a)
      (N- a -n sylbrk p- iai -l)
      (N- a -n sylbrk t- ai sylbrk s- ei)
      (N- a -n sylbrk t- i -K sylbrk l- i -t)
      (N- a -n sylbrk z- u)
      (N- a sylbrk p- i -s)
      (N- a sylbrk p- o -l sylbrk l- io -n)
      (N- a -p sylbrk s- a sylbrk N- oa -s)
      (N- a sylbrk k- iai -l)
      (N- a sylbrk N- oa sylbrk C- y sylbrk l- a)
      (N- a sylbrk N- ai -l)
      (N- ai sylbrk c- o -n)
      (N- ai sylbrk d- i sylbrk b- ai sylbrk h- ai -c)
      (N- a sylbrk N- ui sylbrk m- a -n)
      (N- a sylbrk N- io -k)
      (N- ai sylbrk m- a sylbrk N- io -s)
      (N- ai sylbrk P- a -k sylbrk s- a -t)
      (N- a sylbrk N- io sylbrk g- a -n sylbrk s- e)
      (N- a sylbrk N- iu sylbrk n- a sylbrk s- u sylbrk N- oa)
      (N- a sylbrk s- a -g)
      (N- a sylbrk s- a -k sylbrk k- u)
      (N- a sylbrk z- a -P)
      (N- a -s sylbrk b- e -l)
      (N- a -s sylbrk k- a sylbrk N- io -t)
      (N- a sylbrk s- i -k sylbrk p- a sylbrk C- a)
      (N- a sylbrk s- i sylbrk m- a)
      (N- a -s sylbrk m- o sylbrk d- ai)
      (N- a -s sylbrk m- o sylbrk d- ei)
      (N- a -s sylbrk m- o sylbrk d- iu -s)
      (N- a -s sylbrk m- u -g)
      (N- a sylbrk s- ui -s)
      (N- a sylbrk s- u sylbrk N- oa -s)
      (N- a sylbrk s- oa sylbrk P- i -l)
      (N- a -s sylbrk t- a sylbrk N- io -t)
      (N- a -s sylbrk t- a sylbrk N- o -T)
      (N- a -s sylbrk t- a sylbrk t- ei)
      (N- a sylbrk s- y sylbrk m- a -n)
      (N- a sylbrk s- u sylbrk N- oa)
      (N- a sylbrk t- ei)
      (N- a sylbrk t- oa -s)
      (N- a sylbrk t- iei)
      (N- a sylbrk t- io sylbrk p- o -s)
      (N- o sylbrk d- y -m sylbrk l- a)
      (N- o sylbrk z- i sylbrk t- i -P)
      (N- o sylbrk t- o sylbrk j- ai -n)
      (N- a -g sylbrk z- a sylbrk P- a -t)
      (N- ai sylbrk n- a -s)
      (N- ai sylbrk p- e sylbrk N- io -s)
      (N- a sylbrk z- a sylbrk N- ai -l)
      (N- a sylbrk z- a sylbrk N- iai -l)
      (N- a sylbrk z- a sylbrk z- ai -l)
      (N- a sylbrk z- a sylbrk z- e -l)
      (N- a sylbrk z- ei)
      (N- a sylbrk z- i sylbrk d- a sylbrk h- a sylbrk k- a)
      (N- a sylbrk z- iai -l)
      (N- a sylbrk z- ui sylbrk C- ai -p)
      (N- a sylbrk z- oa sylbrk N- ai -l)
      (N- a sylbrk z- oa sylbrk N- i -l)
      (b- a -l)
      (b- a -l sylbrk b- ei sylbrk N- i -t)
      (b- a -l sylbrk g- a -t)
      (b- a -l sylbrk P- a sylbrk N- oa -s)
      (b- a -l sylbrk s- e sylbrk m- ai -n)
      (b- a -l sylbrk z- iei sylbrk P- o)
      (b- a -l sylbrk z- ei sylbrk P- o -n)
      (b- a sylbrk b- i -N sylbrk N- e sylbrk p- e -t)
      (b- a sylbrk k- y -s)
      (b- a -t)
      (b- a sylbrk d- y -m sylbrk n- a)
      (b- a sylbrk N- e -l)
      (b- a sylbrk N- ai -l)
      (b- a sylbrk h- a sylbrk m- a -n)
      (b- a -h sylbrk m- a -n)
      (b- a sylbrk k- a sylbrk s- u sylbrk N- oa)
      (b- a sylbrk l- a sylbrk d- ei sylbrk b- a)
      (b- a sylbrk l- a -m)
      (b- a sylbrk l- a -n)
      (b- a -l sylbrk b- e sylbrk N- ui -T)
      (b- a -l sylbrk d- ei)
      (b- a sylbrk l- i)
      (b- a sylbrk l- i sylbrk N- oa -j)
      (b- a -l sylbrk t- a sylbrk z- o)
      (b- a -n sylbrk C- e)
      (b- a -n sylbrk C- ei)
      (b- a sylbrk P- o sylbrk m- e -t)
      (b- ai sylbrk b- a -s)
      (b- ai sylbrk b- a sylbrk t- o -s)
      (b- ai sylbrk b- e sylbrk l- o -t)
      (b- a sylbrk N- io -N)
      (b- a sylbrk T- i -n)
      (b- a sylbrk T- y -m)
      (b- a -c sylbrk k- u -m sylbrk b- a sylbrk s- a)
      (b- a -c sylbrk k- u -m sylbrk p- a sylbrk C- a)
      (b- a sylbrk b- a sylbrk k- u -m sylbrk b- a)
      (b- a sylbrk N- iei sylbrk m- o -n)
      (b- ei sylbrk N- a -l)
      (b- e -l sylbrk z- e sylbrk b- u -p)
      (b- ai -l sylbrk z- e sylbrk b- y -t)
      (b- e sylbrk h- e sylbrk m- o -T)
      (b- ei sylbrk h- ei sylbrk m- o -t)
      (b- e sylbrk h- e sylbrk N- i -t)
      (b- ei sylbrk h- ai sylbrk N- i -t)
      (b- ai -l)
      (b- e sylbrk l- a -m)
      (b- ai -l sylbrk b- a -k)
      (b- ai -l sylbrk b- o -g)
      (b- e sylbrk l- ia -l)
      (b- ei sylbrk l- ia -l)
      (b- e sylbrk l- e -T)
      (b- e -l sylbrk P- e sylbrk g- oi)
      (b- ai -l sylbrk P- ei sylbrk g- oi)
      (b- ai -l sylbrk z- e sylbrk b- y -p)
      (b- ai -l sylbrk z- ei sylbrk b- y -t)
      (b- ai -g sylbrk m- ai -n sylbrk l- e -n)
      (b- e sylbrk N- i -T)
      (b- e sylbrk N- i -t)
      (b- ei sylbrk N- i -t)
      (b- ei sylbrk N- iu -t)
      (b- ai sylbrk N- ue sylbrk b- oa)
      (b- ai sylbrk g- ei -s)
      (b- u sylbrk t- a)
      (b- i sylbrk b- ei sylbrk z- ia)
      (b- i sylbrk l- i -s)
      (b- i sylbrk t- iu)
      (b- i sylbrk P- io -n)
      (b- o sylbrk b- u)
      (b- o -l sylbrk P- i)
      (b- o sylbrk N- iu sylbrk t- a)
      (b- o sylbrk t- i -s)
      (b- u sylbrk h- ei)
      (b- u sylbrk k- a sylbrk b- a -c)
      (b- u sylbrk n- e)
      (b- u sylbrk C- ia -s sylbrk t- a)
      (b- y sylbrk t- a sylbrk d- ie)
      (b- i sylbrk l- ai -t)
      (c- a sylbrk c- ui sylbrk n- o sylbrk l- a -s)
      (k- a sylbrk k- ui sylbrk n- o sylbrk l- a -s)
      (c- a -s sylbrk s- i sylbrk m- o sylbrk l- ai)
      (k- a sylbrk s- i sylbrk m- o sylbrk l- ai)
      (k- a sylbrk h- a sylbrk m- ei sylbrk N- oa -j sylbrk n- ei sylbrk N- iei)
      (c- ai -m)
      (c- a sylbrk n- io)
      (k- a sylbrk N- oa sylbrk b- ia)
      (c- ei sylbrk b- e sylbrk N- ue)
      (C- a sylbrk N- iu -n)
      (C- a -ks)
      (C- e sylbrk m- o -C)
      (C- ei sylbrk N- iai -p)
      (C- ei sylbrk t- ai -p)
      (C- o sylbrk N- io -n sylbrk z- o -n)
      (k- ui sylbrk z- o sylbrk p- o -l)
      (c- i sylbrk m- e sylbrk N- ie -s)
      (c- i sylbrk m- e sylbrk j- e -s)
      (s- iu sylbrk s- ei)
      (c- ia -s sylbrk s- ia sylbrk l- a sylbrk b- o sylbrk l- a -s)
      (k- ia sylbrk s- ia sylbrk l- a sylbrk b- o sylbrk l- a -s)
      (c- oi sylbrk s- o -n)
      (k- oa sylbrk p- u sylbrk l- ai)
      (c- io sylbrk c- e -l)
      (c- u -l sylbrk s- u)
      (d- a sylbrk b- a sylbrk N- i sylbrk d- a)
      (d- a -k sylbrk t- i -l)
      (d- ai sylbrk b- a)
      (d- a sylbrk g- o -n)
      (d- a sylbrk h- a -k)
      (d- a -h sylbrk m- a -n)
      (d- a sylbrk j- a -l)
      (d- a sylbrk m- a sylbrk C- y -s)
      (d- a -m sylbrk n- ei sylbrk t- y -s)
      (d- a sylbrk n- iai -l)
      (d- a -n sylbrk j- a -l)
      (d- a -n sylbrk t- a sylbrk l- io -n)
      (d- a sylbrk N- iu sylbrk j- i)
      (d- ai sylbrk b- a -n)
      (d- a sylbrk b- y sylbrk j- o sylbrk n- e -s)
      (d- e sylbrk b- ei)
      (d- ei sylbrk k- a sylbrk N- oa sylbrk b- ia)
      (d- e sylbrk c- a sylbrk N- oa sylbrk b- ia)
      (d- ei sylbrk c- ai -l)
      (d- ai sylbrk j- ia -l)
      (d- e sylbrk m- iu sylbrk g- e)
      (d- e sylbrk m- o sylbrk g- oi sylbrk g- o -n)
      (d- ei sylbrk m- o sylbrk g- oi sylbrk g- o -n)
      (d- ai sylbrk m- iu -C sylbrk n- ei sylbrk N- iei)
      (d- oi sylbrk m- y -s)
      (d- oi sylbrk m- o)
      (d- e sylbrk b- i -l)
      (d- ia -m sylbrk b- i sylbrk l- i -C)
      (d- ia -P)
      (d- i sylbrk g- o sylbrk n- ai)
      (d- i -P)
      (d- i sylbrk b- e sylbrk s- e sylbrk p- i -t)
      (j- i -l sylbrk b- ei sylbrk g- ai -n)
      (d- o sylbrk b- i)
      (d- o sylbrk l- ai -s)
      (d- o sylbrk m- o sylbrk b- oi)
      (d- oa sylbrk C- i sylbrk N- ui sylbrk b- i -n)
      (d- ui sylbrk g- a)
      (d- oa -k)
      (d- oa sylbrk g- o -n)
      (d- ue sylbrk k- a sylbrk b- a -c)
      (d- io -l)
      (d- iu sylbrk b- a)
      (d- io -z)
      (t- i sylbrk g- o -P)
      (d- uei sylbrk g- ai)
      (d- y -z)
      (d- i sylbrk z- ei)
      (d- i sylbrk t- i sylbrk k- a -n)
      (j- i sylbrk b- o sylbrk j- o -n)
      (z- oa sylbrk b- i -t)
      (N- ia sylbrk t- oa -s)
      (N- e sylbrk b- ui -s)
      (N- ei -p sylbrk l- i -s)
      (N- ei sylbrk d- ui -s)
      (N- ei sylbrk j- ei sylbrk N- ui)
      (N- ei sylbrk C- e -T)
      (N- ai -lP)
      (N- ai -l sylbrk P- oa)
      (N- e sylbrk l- i sylbrk g- o -s)
      (N- ei sylbrk n- o -k)
      (N- ai -s sylbrk k- y sylbrk l- a -p)
      (N- oi sylbrk N- ui sylbrk d- i -s)
      (P- ia sylbrk N- u sylbrk N- io -s)
      (P- ia sylbrk b- io -s)
      (P- ei sylbrk k- oi)
      (P- ai -n sylbrk N- ui -s)
      (P- o sylbrk c- a sylbrk l- oi)
      (P- o sylbrk N- oai)
      (P- o sylbrk N- oa -s)
      (P- oi sylbrk c- a -s)
      (P- oi sylbrk n- iu -s)
      (P- ui sylbrk c- a -s)
      (P- ui sylbrk P- ui)
      (g- a -p)
      (g- a sylbrk d- ei sylbrk h- e -l)
      (g- a sylbrk k- i)
      (g- a sylbrk m- i sylbrk g- i -n)
      (g- a sylbrk z- iai -l)
      (g- u -l)
      (g- ia sylbrk s- ia sylbrk l- a sylbrk b- o sylbrk l- a -s)
      (g- ia -s sylbrk s- ia sylbrk l- a sylbrk b- o sylbrk l- i -s)
      (g- io sylbrk k- y -s)
      (g- o sylbrk m- o sylbrk N- y)
      (g- oi sylbrk g- o -n)
      (g- ue sylbrk m- o sylbrk N- y)
      (g- ui sylbrk g- o sylbrk N- ui)
      (g- oa sylbrk l- i sylbrk C- u)
      (g- oa sylbrk N- io sylbrk t- a)
      (g- y sylbrk p- ai)
      (g- u sylbrk s- io -n)
      (g- u sylbrk s- oi -n)
      (h- a sylbrk g- e -n sylbrk t- i)
      (h- a sylbrk b- o sylbrk N- ui -m)
      (h- a sylbrk d- ai -s)
      (h- a -l sylbrk P- a -s)
      (h- a -n sylbrk t- u sylbrk N- oa sylbrk N- ia)
      (h- a sylbrk p- i)
      (h- a sylbrk N- u sylbrk N- oa -s)
      (h- a sylbrk N- u sylbrk N- ue -s)
      (h- a sylbrk b- ue -s)
      (h- ei sylbrk l- a)
      (h- u sylbrk m- a sylbrk n- i)
      (N- ia sylbrk m- ai -n)
      (N- i sylbrk b- ui -s)
      (N- i -p sylbrk l- i -s)
      (N- i -k sylbrk n- oi sylbrk m- o -n)
      (N- i sylbrk P- ui -t)
      (N- i sylbrk P- yi -n)
      (N- i -n sylbrk k- u -p)
      (N- i -n sylbrk k- y sylbrk b- o)
      (N- i -n sylbrk c- u sylbrk b- u -s)
      (N- i sylbrk p- e -s)
      (N- i sylbrk p- ai -s)
      (N- i sylbrk p- o -s)
      (N- i sylbrk z- a sylbrk k- a sylbrk N- iu -m)
      (N- i -s sylbrk p- a sylbrk N- oai sylbrk t- a)
      (j- a -k)
      (j- a -g sylbrk h- ai sylbrk n- a -t)
      (j- a sylbrk k- i -z)
      (j- a -l sylbrk d- a sylbrk b- a sylbrk N- o -t)
      (j- a sylbrk m- a sylbrk l- o sylbrk k- a)
      (j- ei sylbrk d- ai)
      (j- ei sylbrk h- o sylbrk b- a)
      (j- ei sylbrk n- u -n)
      (j- ei sylbrk z- ei sylbrk h- a sylbrk N- oa)
      (j- ei sylbrk z- ei sylbrk t- o -p)
      (j- i -n)
      (j- i sylbrk k- i sylbrk n- i -n sylbrk k- i)
      (j- o sylbrk g- o sylbrk n- a sylbrk t- a)
      (j- o sylbrk l- i sylbrk b- oa)
      (j- oi sylbrk m- y -n sylbrk g- a -n sylbrk d- yi)
      (j- y -K sylbrk n- ai -h)
      (j- y sylbrk n- iei)
      (j- y sylbrk p- i sylbrk t- ei sylbrk N- a sylbrk m- o -n)
      (k- a sylbrk b- a -n sylbrk d- a)
      (k- a -p sylbrk h- a -n sylbrk d- a)
      (k- a sylbrk b- i sylbrk N- ue -s)
      (k- a sylbrk b- u sylbrk t- ei sylbrk m- a sylbrk n- e sylbrk k- ai -nc)
      (k- a sylbrk b- u sylbrk t- ei)
      (k- a sylbrk k- o -s)
      (k- a sylbrk l- i)
      (k- a -l sylbrk p- a sylbrk t- a sylbrk N- iu)
      (k- a sylbrk m- i -s)
      (k- ai sylbrk p- a sylbrk g- a sylbrk t- a sylbrk N- iu)
      (k- a sylbrk s- a sylbrk d- ia)
      (k- a sylbrk t- a sylbrk K- a sylbrk n- ai -s)
      (k- a -t sylbrk m- iu)
      (k- ai sylbrk b- oa)
      (k- ai -l sylbrk b- i)
      (k- e sylbrk l- ai -n)
      (k- ai -l sylbrk p- i)
      (k- e sylbrk N- i sylbrk k- o -P)
      (k- ia sylbrk k- ia -k)
      (k- i sylbrk j- u -n)
      (k- i -l sylbrk l- a sylbrk k- e sylbrk c- a -t)
      (k- i sylbrk m- a sylbrk N- ui -s)
      (k- io sylbrk n- ai -s)
      (k- ia sylbrk b- ei)
      (k- ie sylbrk d- e)
      (k- o sylbrk b- a -l)
      (k- o sylbrk b- o -lk)
      (k- o sylbrk k- a sylbrk b- ie -l)
      (k- o -l sylbrk P- i)
      (k- u -g sylbrk h- a -s)
      (k- u sylbrk p- a sylbrk N- i -s)
      (k- oa sylbrk g- a)
      (k- ui sylbrk k- a sylbrk l- a)
      (k- u sylbrk N- ui sylbrk g- a -nc)
      (k- oa sylbrk k- e -n)
      (k- oa -m sylbrk p- u -s)
      (k- oa sylbrk t- i -m)
      (k- ue -K sylbrk t- i -N)
      (k- io sylbrk d- o)
      (k- io sylbrk n- i)
      (k- u -m sylbrk b- a sylbrk k- ai sylbrk n- a)
      (k- y sylbrk p- ai)
      (l- a -n sylbrk t- i sylbrk l- a)
      (l- e sylbrk C- ie -s)
      (l- e sylbrk g- io -n)
      (l- e -m sylbrk p- o)
      (l- ei sylbrk N- o sylbrk n- ai -t)
      (l- e sylbrk N- oa sylbrk N- ie)
      (l- e sylbrk N- oa sylbrk j- e)
      (l- e sylbrk b- ia sylbrk T- a -n)
      (l- e sylbrk N- ia -k)
      (l- i sylbrk l- i)
      (l- i sylbrk l- i -m)
      (l- i sylbrk l- i -n)
      (l- i sylbrk l- i -T)
      (l- o -k)
      (l- o sylbrk N- iai)
      (l- u sylbrk c- i sylbrk P- ei)
      (l- u sylbrk c- i sylbrk P- u sylbrk g- e)
      (m- a sylbrk l- a sylbrk P- ai)
      (m- a sylbrk l- e sylbrk P- ai)
      (m- a sylbrk l- i sylbrk n- a)
      (m- a -l sylbrk P- a -s)
      (m- a -l sylbrk T- u -s)
      (m- a -m sylbrk m- o -n)
      (m- a -n sylbrk d- oa sylbrk g- oi)
      (m- a sylbrk N- oa)
      (m- a sylbrk N- oa -K)
      (m- ai sylbrk b- a -s)
      (m- ai sylbrk C- o sylbrk s- ia -s)
      (m- a sylbrk N- i sylbrk C- a)
      (m- ai sylbrk T- i -m)
      (m- a sylbrk s- i -h sylbrk N- a -t sylbrk t- a sylbrk j- a -l)
      (m- a -s sylbrk t- e sylbrk m- a)
      (m- a sylbrk T- i -m)
      (m- e sylbrk P- i -s sylbrk t- o sylbrk P- e sylbrk l- e -s)
      (m- ei sylbrk P- i -s sylbrk t- o sylbrk P- ei sylbrk l- ai -s)
      (m- e sylbrk N- i sylbrk h- e -m)
      (m- i sylbrk m- i)
      (m- o sylbrk l- o -K)
      (m- o sylbrk N- oa -K)
      (m- oi sylbrk d- a -k sylbrk n- ei sylbrk N- iei)
      (m- oi sylbrk P- iu -s)
      (m- y -n sylbrk k- iu)
      (m- ui sylbrk m- ui)
      (n- a sylbrk m- a -h)
      (n- a sylbrk b- a -m)
      (n- a sylbrk b- e sylbrk N- iu -s)
      (n- a sylbrk b- ei sylbrk iu -s)
      (n- a -K sylbrk m- a sylbrk n- e sylbrk k- e -n)
      (n- a -K sylbrk b- iu sylbrk t- ie)
      (n- a sylbrk g- oa -l)
      (n- a sylbrk h- a sylbrk m- a)
      (n- ai -n sylbrk l- o sylbrk N- i -n)
      (n- ai -n)
      (n- a sylbrk k- a sylbrk N- io -n sylbrk k- iu)
      (n- a -m sylbrk b- io -t)
      (n- a -m sylbrk t- ai)
      (n- a sylbrk N- oa -k)
      (n- a -s sylbrk t- oa -nc)
      (n- a -s sylbrk t- iu -nc)
      (n- a -k sylbrk s- a -k)
      (n- ei sylbrk b- io -s)
      (n- ei sylbrk k- iu)
      (n- ai sylbrk m- io -t)
      (n- ei sylbrk P- ei sylbrk l- i -m)
      (n- ei sylbrk N- iei)
      (n- ai sylbrk g- a -l)
      (n- ai sylbrk j- ai -l)
      (n- ei sylbrk t- o -s)
      (n- i sylbrk b- ia -n)
      (n- i sylbrk k- ai)
      (n- i -k)
      (n- i -lP sylbrk h- ai -m)
      (n- i sylbrk n- ui sylbrk t- a)
      (n- i sylbrk N- iu sylbrk d- i)
      (n- i sylbrk N- io -n sylbrk d- i)
      (n- i -s)
      (n- i -s sylbrk g- o sylbrk d- iai -N)
      (n- i sylbrk t- oai -s)
      (n- i -k sylbrk s- a -s)
      (n- i -k sylbrk s- a)
      (n- o sylbrk n- o -s)
      (n- oi -n)
      (n- oi -s sylbrk g- y -p)
      (n- y sylbrk m- a sylbrk p- o -m sylbrk p- i sylbrk l- iu -s)
      (n- i sylbrk b- a -s)
      (n- i sylbrk s- io -k)
      (N- oa sylbrk n- ai -s)
      (N- o sylbrk b- ei sylbrk N- io -n)
      (N- o sylbrk d- ai)
      (N- o sylbrk d- i -n)
      (N- oa sylbrk l- ai -t)
      (N- o sylbrk k- i sylbrk z- i -ks)
      (N- o sylbrk l- i sylbrk b- iei)
      (N- o -m sylbrk b- iai -l)
      (N- o sylbrk m- ei -s sylbrk t- ai -s)
      (N- o sylbrk n- o -s sylbrk k- e sylbrk l- i -s)
      (N- o sylbrk P- io sylbrk n- ei)
      (N- o sylbrk N- iai)
      (N- oi sylbrk c- u -s)
      (N- o sylbrk N- ia -s)
      (N- oi sylbrk N- ia -K)
      (N- oi sylbrk d- o -g)
      (N- oi sylbrk m- o -s)
      (N- oi sylbrk m- u -z)
      (N- oi sylbrk m- y -s)
      (N- oi sylbrk m- y -z)
      (N- o sylbrk N- io sylbrk b- a -s)
      (N- o sylbrk N- io sylbrk m- a sylbrk s- i -s)
      (N- o sylbrk N- io sylbrk m- a -z)
      (N- oi sylbrk P- ei)
      (N- oi sylbrk t- o -n)
      (N- o sylbrk s- e)
      (N- o sylbrk t- i -s)
      (N- o sylbrk t- o sylbrk k- a sylbrk t- a)
      (N- oa sylbrk h- i -C)
      (N- ui sylbrk k- a)
      (N- u sylbrk l- o -n sylbrk t- o sylbrk N- io -n)
      (N- ui -ks)
      (N- o -z)
      (p- a -n)
      (p- ai sylbrk m- o -n)
      (p- a sylbrk z- u sylbrk z- u)
      (p- e sylbrk l- e sylbrk s- i -t)
      (p- e sylbrk n- e sylbrk m- ue)
      (p- ei sylbrk N- ui -s)
      (P- e sylbrk n- e -K)
      (P- iei sylbrk j- ei sylbrk t- o -n)
      (P- u sylbrk k- a)
      (p- i sylbrk T- iu sylbrk -s)
      (p- o sylbrk c- o -N)
      (p- o -n sylbrk t- ia sylbrk n- a -k)
      (p- io sylbrk c- e -l)
      (p- io sylbrk t- ai sylbrk C- o -n sylbrk t- e)
      (p- iu sylbrk P- ia -s)
      (p- iu sylbrk n- i -k)
      (p- y -k)
      (p- u sylbrk l- o sylbrk m- a -n)
      (p- i sylbrk t- o -n)
      (k- ai -s)
      (N- oa sylbrk b- a -c)
      (N- oa sylbrk C- a sylbrk d- ei)
      (N- oa sylbrk j- i sylbrk n- i -s)
      (N- oa sylbrk h- a -p)
      (N- oa sylbrk h- oa)
      (N- oa -k sylbrk C- a sylbrk s- a)
      (N- oa -N sylbrk d- a)
      (N- oa sylbrk n- i sylbrk N- oa sylbrk z- a -l)
      (N- oa sylbrk P- a sylbrk N- ai -l)
      (N- oa sylbrk N- u -m)
      (N- oa -m)
      (N- oa sylbrk b- a -n)
      (N- oai -t sylbrk k- a -p)
      (N- ue sylbrk m- o -n)
      (N- ue -m sylbrk n- o -n)
      (N- io sylbrk t- o sylbrk m- a sylbrk g- o)
      (N- ui sylbrk b- e sylbrk z- a -l)
      (N- ui sylbrk b- e -n sylbrk z- a -l)
      (N- ui sylbrk g- u)
      (N- ui sylbrk m- o -n)
      (N- io sylbrk b- ei)
      (N- io sylbrk d- e sylbrk N- ui -k)
      (N- io sylbrk d- ui -g)
      (N- io sylbrk P- o sylbrk c- a sylbrk l- e)
      (N- io sylbrk m- y sylbrk l- y -s)
      (N- io sylbrk n- o sylbrk b- e)
      (N- io sylbrk n- uei)
      (N- io sylbrk z- iei)
      (N- iu sylbrk b- e sylbrk z- a -l)
      (N- iu -g sylbrk n- ei)
      (N- iu sylbrk s- a -l sylbrk k- a)
      (N- iu -C)
      (N- ui sylbrk m- ei)
      (s- a sylbrk b- a sylbrk N- o -t)
      (s- a sylbrk b- a sylbrk s- iu -s)
      (s- a sylbrk b- a sylbrk t- a -n)
      (s- a -p sylbrk n- a -k)
      (s- a -p sylbrk n- o -k)
      (s- a sylbrk k- a sylbrk N- oa -s)
      (s- a sylbrk d- ia -l)
      (s- a sylbrk d- iai -l)
      (s- a sylbrk K- ai)
      (s- a sylbrk k- i sylbrk m- u sylbrk n- i)
      (s- a sylbrk l- e sylbrk N- o -s)
      (s- a -l sylbrk m- a -k)
      (s- a sylbrk l- o sylbrk m- o -n)
      (s- a sylbrk m- a sylbrk N- e -l)
      (s- a sylbrk m- a sylbrk N- ai -l)
      (s- a sylbrk p- o -n sylbrk d- o sylbrk m- a -t)
      (s- ai sylbrk k- oi -l)
      (s- a sylbrk t- a -n)
      (s- a sylbrk t- a sylbrk n- a sylbrk k- i)
      (s- a sylbrk t- a sylbrk m- i -nc)
      (s- a sylbrk t- iu)
      (s- o sylbrk z- i -n)
      (s- o -t sylbrk b- yi sylbrk s- o -n)
      (s- ai sylbrk N- ui -m)
      (C- a sylbrk d- a sylbrk C- i sylbrk b- a sylbrk N- u -n)
      (C- ei sylbrk d- i -m)
      (C- ai sylbrk t- a -n)
      (C- ei sylbrk N- o -l)
      (C- u -m sylbrk n- y -s)
      (C- oi -t sylbrk t- e sylbrk l- i -s)
      (k- u sylbrk m- i -n)
      (k- o -ks)
      (s- i sylbrk l- a)
      (s- ei -p sylbrk h- a sylbrk N- ai -l)
      (s- ei -p sylbrk h- i -l)
      (s- ai -g sylbrk j- i -n)
      (s- ei sylbrk h- ei sylbrk l- a -n sylbrk n- ei sylbrk N- iei)
      (s- e sylbrk m- ia -z)
      (s- ei sylbrk p- ai)
      (s- ei sylbrk P- i sylbrk N- io -t)
      (s- e sylbrk N- io -C)
      (s- ei sylbrk N- iu -g)
      (s- ai -t)
      (C- a sylbrk m- a sylbrk b- e sylbrk d- a -m)
      (C- ai sylbrk t- a -n)
      (C- a -K)
      (C- e sylbrk d- i -m)
      (C- u sylbrk p- ai -l sylbrk t- i -n)
      (s- i sylbrk d- oa sylbrk g- a sylbrk z- u -m)
      (s- i sylbrk j- ei sylbrk N- a sylbrk n- i)
      (s- i sylbrk l- ai -n)
      (s- i -m)
      (s- i sylbrk m- oi -g)
      (s- i sylbrk N- oa -t)
      (s- iu sylbrk C- a -t)
      (s- i sylbrk t- i -m)
      (k- a -l sylbrk d- a)
      (k- i -n sylbrk k- oa -P sylbrk t- i sylbrk g- a -n)
      (s- o sylbrk l- a -s)
      (s- o sylbrk l- ai -P)
      (s- o sylbrk l- i sylbrk m- a -n)
      (s- o sylbrk n- ai sylbrk N- io -n)
      (s- o sylbrk t- oai)
      (s- u sylbrk g- ai sylbrk t- o sylbrk N- io -n)
      (s- o sylbrk b- a -s sylbrk m- y sylbrk n- y sylbrk z- i -n)
      (p- ai -k sylbrk t- ue)
      (P- i -nc)
      (p- y -n sylbrk k- i)
      (t- a sylbrk P- iu)
      (t- a -l sylbrk k- ei)
      (T- e -n sylbrk n- o)
      (t- o sylbrk l- a -s)
      (t- o sylbrk l- e -n sylbrk N- b- ui -m)
      (t- ui -j)
      (t- i -ks)
      (s- oa -N sylbrk g- i)
      (s- y sylbrk k- oi sylbrk b- ei sylbrk n- o -t)
      (s- y sylbrk k- y -p)
      (s- u sylbrk c- u sylbrk b- u -s)
      (s- y sylbrk m- a sylbrk n- y -s)
      (s- ui sylbrk g- a -t)
      (s- yi sylbrk t- yi)
      (s- y -s sylbrk t- iu sylbrk j- iai -l)
      (s- i -lP)
      (s- i sylbrk N- oai -n)
      (s- i sylbrk t- ui)
      (t- a sylbrk N- oa)
      (t- a sylbrk k- ui -n)
      (t- ai -n sylbrk g- ai sylbrk N- ui)
      (t- a sylbrk m- u -s)
      (t- a sylbrk n- i sylbrk N- oa)
      (t- a -n sylbrk n- i -n)
      (t- a -p)
      (t- a sylbrk N- oa sylbrk t- ai sylbrk h- e sylbrk t- o sylbrk m- io)
      (t- ai -m sylbrk z- ai sylbrk p- u sylbrk l- iai)
      (t- ei sylbrk n- ai)
      (t- ai sylbrk N- uei)
      (t- ai sylbrk b- a sylbrk g- a -n)
      (t- ai sylbrk b- ie)
      (t- oi -s)
      (t- oi sylbrk t- a sylbrk t- ai -s)
      (t- a sylbrk m- y -z)
      (t- ei sylbrk N- a -n sylbrk t- i -s)
      (t- i sylbrk b- a sylbrk l- a -N)
      (t- i sylbrk t- a sylbrk n- ia)
      (t- o sylbrk N- ia)
      (t- o -m sylbrk t- e sylbrk g- o -p)
      (t- o sylbrk p- iai -l sylbrk n- i -t sylbrk s- i -s)
      (t- o sylbrk k- i)
      (t- oi -n sylbrk g- ai sylbrk s- y -k)
      (t- o sylbrk t- a -m)
      (t- u sylbrk p- a -n)
      (t- o sylbrk N- io -l)
      (t- oa -z sylbrk g- o -s)
      (t- io sylbrk l- ai -n)
      (t- io -t)
      (t- io -z)
      (t- u sylbrk C- u -l sylbrk C- a)
      (t- i sylbrk b- i sylbrk l- ei sylbrk n- y -s)
      (N- u sylbrk k- o sylbrk b- a -K)
      (N- y sylbrk k- o sylbrk b- a -k)
      (N- y sylbrk P- i)
      (N- ui sylbrk d- a)
      (N- yi sylbrk g- a -n sylbrk d- e)
      (b- a -P sylbrk t- iu -t sylbrk n- i -s)
      (b- a -g sylbrk n- o -t)
      (b- a sylbrk N- i sylbrk k- a sylbrk N- oa sylbrk n- i)
      (b- a sylbrk l- a -c)
      (b- a sylbrk l- a sylbrk P- ai)
      (b- a sylbrk l- e sylbrk P- ai)
      (b- a sylbrk l- ai -n)
      (b- a -l sylbrk k- i sylbrk N- ui)
      (b- a -n)
      (b- a sylbrk p- u sylbrk l- a)
      (b- a sylbrk N- io sylbrk n- i -n)
      (b- a -s sylbrk s- a sylbrk g- o)
      (b- ai sylbrk l- e sylbrk d- a)
      (b- e sylbrk p- ai)
      (b- ei sylbrk p- ai)
      (b- ai sylbrk N- oa -n sylbrk d- i)
      (b- ai sylbrk d- e sylbrk l- ai)
      (b- ai sylbrk j- o sylbrk l- i)
      (b- ai -s sylbrk t- a)
      (b- oi sylbrk p- a sylbrk C- a)
      (b- i -t sylbrk b- iai -n)
      (b- i sylbrk n- e)
      (b- i -n)
      (b- o sylbrk l- a -k)
      (b- o -l sylbrk t- a)
      (N- oa sylbrk t- ei sylbrk N- ai -lP)
      (N- oa -l sylbrk h- a sylbrk l- a)
      (N- oa -l sylbrk k- i sylbrk N- ui)
      (N- oa -l)
      (b- e sylbrk C- e -l sylbrk b- a -lk)
      (N- ue -n sylbrk d- i sylbrk g- o)
      (N- ui sylbrk l- i -s)
      (N- ui sylbrk b- ue)
      (b- o sylbrk d- e -n)
      (b- o sylbrk l- o sylbrk t- i -s)
      (K- a sylbrk P- a -n)
      (z- a sylbrk P- a -n)
      (K- e -z sylbrk b- e -T)
      (z- e -z sylbrk b- e -t)
      (z- i sylbrk t- oa sylbrk g- y -p sylbrk t- e -n)
      (N- ia sylbrk g- a sylbrk b- a sylbrk b- a)
      (N- ia -n sylbrk g- a -n sylbrk t- i sylbrk t- a -n)
      (N- i sylbrk C- ai -n sylbrk b- o sylbrk n- o -g)
      (N- iai -n sylbrk b- a -N)
      (N- ie sylbrk k- o -n)
      (N- ie sylbrk t- e sylbrk N- ie -l)
      (N- io sylbrk m- u -n sylbrk g- a -n sylbrk d- ui)
      (N- iu sylbrk m- a)
      (z- a sylbrk b- y sylbrk l- o -n)
      (z- a sylbrk k- a sylbrk N- ui)
      (z- a sylbrk k- u -m)
      (z- ei sylbrk b- o -s)
      (z- a sylbrk g- a -m)
      (z- a sylbrk g- a -n)
      (z- a sylbrk p- o)
      (z- a sylbrk N- ia -t sylbrk n- a -t sylbrk m- i -k)
      (z- a sylbrk z- a sylbrk N- oa sylbrk g- oa -n)
      (z- ai sylbrk n- ei sylbrk b- o -k)
      (z- e sylbrk p- ai)
      (z- ei sylbrk p- ai)
      (z- i sylbrk m- i sylbrk n- iai)
      (z- i sylbrk N- ui -k)
      (z- o sylbrk z- o)
      )))
