##
## anonymize.R
##
## recodes a list of factors to a number
##
## Rollie Parrish
## 12/31/2013


anonymize <- function(x) {
  set.seed(42)

  if(is.factor(x)) {
    new.ID <- sample(seq(from=100, to=100+length(levels(x))), length(levels(x)))
#      new.ID <- sample(1:length(x), length(x))

  }
#  return(LETTERS[new.ID])
    return(new.ID)
}

