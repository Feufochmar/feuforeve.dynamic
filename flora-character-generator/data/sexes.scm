(sexes
  (male
    (description "male")
    (is-mother? #f)
    (default-gender-distribution
      (masculine 85)
      (feminine 10)
      (neutral-person 4)
      (neutral-thing 1)))
  (female
    (description "female")
    (is-mother? #t)
    (default-gender-distribution
      (masculine 10)
      (feminine 85)
      (neutral-person 4)
      (neutral-thing 1)))
  (none
    (description "without a sex")
    (is-mother? #:maybe)
    (default-gender-distribution
      (masculine 30)
      (feminine 30)
      (neutral-person 30)
      (neutral-thing 10)))
  (both
    (description "both male and female")
    (is-mother? #:maybe)
    (default-gender-distribution
      (masculine 33)
      (feminine 33)
      (neutral-person 33)
      (neutral-thing 1)))
)
