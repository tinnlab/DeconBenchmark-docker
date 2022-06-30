#' Non-linear  for compressed sensing
#'
#' The function runs nonlinear optimization of l1-penalty
#' to train compression for a single gene
#'
#' @param need vector, numeric vector of gene that is needed
#' @param train matrix, numeric expression matrix of training data
#' @param seed numeric, random seed
#' @param lambda numeric, penalty parameter
#'
#' @return list with coefficients and predictive R2
#'
#' @importFrom R1magic solveL1
#' @importFrom caret createFolds
#'
#' @export
l1Magic <- function(need,
                    train,
                    seed = 1218,
                    lambda = .1){

    set.seed(seed)
    Tt = diag(nrow(train))
    p = matrix(0,nrow(train),1)

    mod = R1magic::solveL1(t(train),
                           need,
                           Tt,
                           p)

    ### DO CV
    pred = vector('numeric',
                  length(need))
    train.folds = caret::createFolds(y = need,
                                     k=5,
                                     returnTrain = T)

    for (i in 1:length(train.folds)){

        new.train = train[,train.folds[[i]]]
        Tt = diag(nrow(new.train))
        p = matrix(0,nrow(new.train),1)
        new.mod = R1magic::solveL1(t(new.train),
                               need[train.folds[[i]]],
                               Tt,
                               p)
        pred[-train.folds[[i]]] = new.mod$estimate %*% train[,
                                                             -train.folds[[i]]]


    }


    return(list(coef = mod$estimate,
                r2 = cor(need,pred)^2))

    }

