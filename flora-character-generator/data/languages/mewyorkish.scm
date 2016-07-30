;; Mew-Yorkish language for the word generator
;; Words are generated from English given names
(language mewyorkish
  (names
    (given-names-min-nb 2)
    (given-names-max-nb 4)
    (name-rules
      (full-name
        (masculine GiNa% FaGFF))
      (short-name
        (masculine GiNa FaGFF))
      (father-short-name
        (masculine GiNaF FaGFF))
      (mother-short-name
        (masculine GiNaM FaGFM))))
  (words
    (generator-order 2)
    (phonemes
      ; (key pronounciation native-transcription latin-transcription)
      (syllable-break "." "" "") (stress "ˈ" "" "")
      ;;
      (a-schwa "ə" "a" "a") (a-eI "eɪ" "a" "a") (a-ae "æ" "a" "a") (a-aa "ɑː" "a" "a") (a-E/schwa "ɛə" "a" "a")
      (ar-aa "ɑː" "ar" "ar") (ai-eI "eɪ" "ai" "ai") (ay-aI "aɪ" "ay" "ay") (au-oo "ɔː" "au" "au")
      (ar-schwa "ə" "ar" "ar") (aa-schwa "ə" "aa" "aa") (ah-schwa "ə" "ah" "ah") (ae-schwa "ə" "ae" "ae")
      (e-ii "iː" "e" "e") (e-E "ɛ" "e" "e") (e-I "ɪ" "e" "e") (e-i "i" "e" "e") (e-schwa "ə" "e" "e")
      (ey-eI "eɪ" "ey" "ey") (ey-i "i" "ey" "ey") (er-schwa "ə" "er" "er")
      (ew-uu "uː" "ew" "ew") (ew-juu "juː" "ew" "ew") (ea-I "ɪ" "ea" "ea")
      (i-i "i" "i" "i") (i-I "ɪ" "i" "i") (i-ii "iː" "i" "i") (i-aI "aɪ" "i" "i")
      (ie-i "i" "ie" "ie")
      (o-o "ɒ" "o" "o") (o-schwa "ə" "o" "o") (o-schwa/u "əʊ" "o" "o")
      (oe-ii "iː" "oe" "oe") (or-oo "ɔː" "or" "or") (ow-schwa/u "əʊ" "ow" "ow")
      (or-schwa "ə" "or" "or") (oh-o "ɒ" "oh" "oh")
      (u-uu "uː" "u" "u") (u-juu "juː" "u" "u") (u-^ "ʌ" "u" "u")
      (ur-schwa "ə" "ur" "ur")
      (y-i "i" "y" "y") (y-I "ɪ" "y" "y") (y-aI "aɪ" "y" "y")
      ;;
      (m-m "m" "m" "m") (nn-n "n" "nn" "nn") (n-n "n" "n" "n") (mm-m "m" "mm" "mm")
      (mes-ms "ms" "mes" "mes") (mes-mz "mz" "mes" "mes")
      (l-l "l" "l" "l") (ll-l "l" "ll" "ll") (les-lz "lz" "les" "les")
      (i-j "j" "i" "i") (w-w "w" "w" "w")
      (j-dZ "d͡ʒ" "j" "j") (ch-tS "t͡ʃ" "ch" "ch") (x-gz "ɡz" "x" "x") (x-ks "ks" "x" "x")
      (ge-dZ "d͡ʒ" "ge" "ge") (g-dZ "d͡ʒ" "g" "g") (gi-dZ "d͡ʒ" "gi" "gi")
      (ss-s "s" "ss" "ss") (s-z "z" "s" "s")(s-s "s" "s" "s")
      (ph-f "f" "ph" "ph") (f-f "f" "f" "f") (ch-S "ʃ" "ch" "ch") (c-s "s" "c" "c")
      (ce-s "s" "ce" "ce") (sh-S "ʃ" "sh" "sh") (th-th "θ" "th" "th") (z-z "z" "z" "z")
      (v-v "v" "v" "v") (tth-th "θ" "tth" "tth") (ff-f "f" "ff" "ff")
      (c-k "k" "c" "c") (p-p "p" "p" "p") (pp-p "p" "pp" "pp") (b-b "b" "b" "b")
      (g-g "ɡ" "g" "g") (tt-t "t" "tt" "tt") (tte-t "t" "tte" "tte") (d-d "d" "d" "d")
      (ck-k "k" "ck" "ck") (th-t "t" "th" "th") (t-t "t" "t" "t") (ke-k "k" "ke" "ke")
      (ch-k "k" "ch" "ch") (k-k "k" "k" "k") (ga-g "ɡ" "ga" "ga")
      (r-r "ɹ" "r" "r") (rr-r "ɹ" "rr" "rr")
      (h-h "h" "h" "h"))
    (examples
      (a-schwa syllable-break stress m-m i-ii syllable-break l-l i-i syllable-break a-schwa)
      (a-schwa syllable-break stress m-m i-ii syllable-break l-l i-j a-schwa)
      (stress j-dZ e-E syllable-break ss-s i-I syllable-break c-k a-schwa)
      (stress p-p o-o syllable-break pp-p y-i)
      (stress i-I syllable-break s-z a-schwa syllable-break stress b-b e-E syllable-break ll-l a-schwa)
      (stress r-r u-uu syllable-break b-b y-i)
      (stress l-l i-I syllable-break l-l y-i)
      (stress g-g r-r a-eI ce-s)
      (s-s o-schwa syllable-break stress ph-f i-ii syllable-break a-schwa)
      (stress s-s c-k ar-aa syllable-break l-l e-I tt-t)
      (stress f-f r-r ey-eI syllable-break a-schwa)
      (stress ch-S ar-aa syllable-break l-l o-schwa tte-t)
      (s-s i-I syllable-break stress e-E syllable-break nn-n a-schwa)
      (stress d-d ai-eI syllable-break s-z y-i)
      (stress ph-f oe-ii syllable-break b-b e-i)
      (stress a-ae syllable-break l-l i-I ce-s)
      (stress l-l u-uu syllable-break c-s y-i)
      (stress f-f l-l o-o syllable-break r-r e-schwa n-n ce-s)
      (stress j-dZ a-ae ck-k)
      (stress h-h a-ae syllable-break rr-r y-i)
      (stress j-dZ a-eI syllable-break c-k o-schwa b-b)
      (stress ch-tS ar-aa syllable-break l-l ie-i)
      (stress ch-S ar-aa syllable-break l-l ie-i)
      (stress th-t o-o syllable-break m-m a-schwa s-s)
      (stress o-o syllable-break s-s c-k ar-schwa)
      (stress w-w i-I syllable-break ll-l i-j a-schwa m-m)
      (stress j-dZ a-eI mes-mz)
      (stress j-dZ a-eI mes-ms)
      (stress ge-dZ or-oo ge-dZ)
      (stress j-dZ o-o syllable-break sh-S u-juu syllable-break a-schwa)
      (stress n-n o-schwa/u syllable-break ah-schwa)
      (stress e-ii syllable-break th-th a-schwa n-n)
      (stress l-l e-ii syllable-break o-schwa/u)
      (stress h-h e-E n-n syllable-break r-r y-i)
      (stress j-dZ o-schwa/u syllable-break s-s e-schwa ph-f)
      (stress s-s a-ae syllable-break m-m u-juu syllable-break e-schwa l-l)
      (stress s-s o-schwa/u syllable-break f-f i-i syllable-break a-schwa)
      (stress r-r i-aI syllable-break l-l ey-i)
      (stress i-I syllable-break m-m o-schwa syllable-break g-dZ e-E n-n)
      (stress d-d a-ae n-n syllable-break i-j e-schwa l-l)
      (stress r-r o-schwa/u syllable-break s-z ie-i)
      (stress a-ae syllable-break l-l i-I syllable-break stress x-gz a-aa n-n syllable-break d-d er-schwa)
      (e-schwa syllable-break stress l-l i-I syllable-break z-z a-schwa syllable-break b-b e-schwa th-th)
      (stress m-m a-ae x-ks)
      (stress h-h o-o syllable-break ll-l y-i)
      (stress l-l u-uu syllable-break c-k a-schwa s-s)
      (stress m-m o-o syllable-break ll-l y-i)
      (stress m-m a-eI syllable-break s-s o-schwa n-n)
      (m-m a-schwa syllable-break stress t-t i-I l-l syllable-break d-d a-schwa)
      (stress i-aI syllable-break s-z aa-schwa c-k)
      (stress e-E syllable-break r-r i-I n-n)
      (stress b-b e-E n-n syllable-break j-dZ a-schwa syllable-break m-m i-I n-n)
      (stress l-l e-E syllable-break x-ks i-i)
      (stress d-d y-I syllable-break l-l a-schwa n-n)
      (stress a-ae syllable-break b-b i-I syllable-break g-g ai-eI l-l)
      (stress j-dZ a-eI ke-k)
      (stress s-s u-^ syllable-break mm-m er-schwa)
      (stress e-E syllable-break d-d w-w ar-schwa d-d)
      (stress m-m e-E syllable-break g-g a-schwa n-n)
      (stress h-h a-ae syllable-break rr-r i-I syllable-break s-s o-schwa n-n)
      (stress j-dZ a-ae s-z syllable-break m-m i-I n-n)
      (stress t-t y-aI syllable-break l-l er-schwa)
      (stress o-o syllable-break l-l i-I syllable-break v-v i-i syllable-break a-schwa)
      (s-s e-I syllable-break stress b-b a-ae syllable-break s-s t-t i-I syllable-break a-schwa n-n)
      (stress a-eI syllable-break v-v a-schwa)
      (stress a-ae syllable-break d-d a-schwa m-m)
      (stress s-s o-schwa/u syllable-break ph-f ie-i)
      (stress th-th e-i syllable-break o-schwa/u)
      (stress m-m i-ii syllable-break a-schwa)
      (stress ar-aa syllable-break th-th ur-schwa)
      (stress ch-k l-l o-schwa/u syllable-break e-i)
      (stress d-d a-eI syllable-break v-v i-I d-d)
      (stress m-m i-I syllable-break ll-l ie-i)
      (stress t-t o-schwa/u syllable-break b-b y-i)
      (stress e-ii syllable-break v-v a-schwa)
      (stress l-l u-uu ke-k)
      (stress m-m ay-aI syllable-break a-schwa)
      (stress l-l ew-uu syllable-break i-I s-s)
      (stress w-w i-I syllable-break ll-l ow-schwa/u)
      (stress m-m a-ae syllable-break tth-th ew-juu)
      (stress e-E syllable-break mm-m a-schwa)
      (stress h-h ar-aa syllable-break v-v ey-i)
      (stress e-E syllable-break l-l ea-I syllable-break n-n or-schwa)
      (stress h-h ar-aa syllable-break l-l ey-i)
      (stress ge-dZ or-oo syllable-break gi-dZ a-schwa)
      (stress r-r y-aI syllable-break a-schwa n-n)
      (stress l-l i-ii syllable-break s-s a-schwa)
      (stress l-l i-ii syllable-break s-z a-schwa)
      (m-m a-schwa syllable-break stress r-r i-ii syllable-break a-schwa)
      (m-m a-schwa syllable-break stress r-r i-aI syllable-break a-schwa)
      (stress n-n a-ae n-n syllable-break c-s y-i)
      (stress d-d o-o syllable-break nn-n a-schwa)
      (stress l-l au-oo syllable-break r-r a-schwa)
      (stress m-m a-E/schwa syllable-break r-r y-i)
      (stress s-s a-E/schwa syllable-break r-r ah-schwa)
      (stress l-l i-I n-n syllable-break d-d a-schwa)
      (stress s-s u-uu syllable-break s-z a-schwa n-n)
      (stress k-k a-ae syllable-break r-r e-schwa n-n)
      (stress c-k a-ae syllable-break r-r o-schwa l-l)
      (stress b-b e-E syllable-break tt-t y-i)
      (stress r-r u-uu th-th)
      (stress k-k i-I m-m syllable-break b-b er-schwa syllable-break l-l y-i)
      (stress h-h e-E syllable-break l-l e-schwa n-n)
      (stress sh-S a-ae syllable-break r-r o-schwa n-n)
      (stress d-d e-E syllable-break b-b o-schwa syllable-break r-r ah-schwa)
      (stress ch-k r-r i-I s-s syllable-break t-t o-schwa syllable-break ph-f er-schwa)
      (stress r-r o-o syllable-break n-n a-schwa l-l d-d)
      (stress j-dZ oh-o n-n)
      (stress r-r i-I syllable-break ch-tS ar-schwa d-d)
      (stress k-k e-E syllable-break nn-n e-schwa th-th)
      (stress a-ae n-n syllable-break th-t o-schwa syllable-break n-n y-i)
      (stress r-r o-o syllable-break b-b er-schwa t-t)
      (stress p-p au-oo l-l)
      (stress s-s t-t e-ii syllable-break v-v e-schwa n-n)
      (stress k-k e-E syllable-break v-v i-I n-n)
      (stress m-m i-aI syllable-break ch-k ae-schwa l-l)
      (stress m-m ar-aa k-k)
      (stress j-dZ a-eI syllable-break s-s o-schwa n-n)
      (stress d-d o-o syllable-break n-n a-schwa l-l d-d)
      (stress b-b r-r i-aI syllable-break a-schwa n-n)
      (stress j-dZ e-E ff-f)
      (stress ch-tS ar-aa les-lz)
      (stress m-m ar-aa syllable-break ga-g r-r e-I t-t))))
