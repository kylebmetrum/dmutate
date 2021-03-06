
setClass("covobj")
setClass("covset")

##' Covobj and covset objects.
##'
##' @param x a formula; may be quoted
##' @rdname covset
##' @name covset
##' @export
##'
##' @examples
##'
##' obj <- new_covobj(Y[0,80] ~ rnorm(20,50))
##'
##' obj
##'
##' as.list(obj)
##'
new_covobj <- function(x,envir = parent.frame(),...) {
  if(x=="") return(new_covobj("NULL~rnorm()"))
  if(is.covobj(x)) {
    if(valid_covobj(x)) {
      return(x)
    }
  }
  if(is.language(x)) x <- deparse(x,width.cutoff=500)
  formula <- x
  x <- parse_form_3(x,envir)
  x$formula <- formula
  x$envir <- envir
  x <- structure(x,class="covobj")
  if(valid_covobj(x)) {
    return(x)
  }
}

##' @export
##' @rdname covset
print.covobj <- function(x,...) {
  cat(paste0("Formula ", x$formula))
}

##' @rdname covset
##' @export
setMethod("as.list", "covobj", function(x,...) {
  structure(x,class=NULL)
})
##' @rdname covset
##' @export
setMethod("as.list", "covset", function(x,...) {
  x <- lapply(x,structure, class=NULL)
  structure(x,class=NULL)
})

is.covobj <- function(x) {
  inherits(x,"covobj")
}

valid_covobj <- function(x,...) {
  a <- is.character(x$dist)
  b <- is.character(x$by)
  c <- is.numeric(x$n)
  d <- is.character(x$formula)
  e <- is.expression(x$call)
  f <- all(is.expression(x$lower),is.expression(x$upper))
  g <- is.covobj(x)
  if(!all(a,b,c,d,e,f)) {
    stop("Invalid covobj object.",call.=FALSE)
  }
  return(TRUE)
}

call_type <- function(x) {
  match(x$dist,c("expr"),nomatch=0) + 1
}


is_covset <- function(x) {
  if(!is.list(x)) return(FALSE);
  return(all(sapply(x,is.covobj)))
}

##' @rdname covset
##' @export
print.covset <- function(x,...) {
  form <- paste0("  ", s_pick(x,"formula"))
  print(data.frame(`Formulae` = form), row.names=FALSE,right=FALSE)
}

