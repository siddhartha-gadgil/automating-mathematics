+++
title = "Formalizing Gardam's disproof of Kaplansky's Unit Conjecture"
date = 2022-06-01T06:50:53+05:30
draft = true
tags = []
categories = []
+++

A little over an year ago, Giles Gardam disproved a long-standing conjecture, often called the _Kaplansky Unit Conjecture_. This was a striking result -- the statement was a simple and basic one, it had a long history, and it was one of a cluster of related conjectures with important relations to many areas (including the Whitehead conjecture in topology). 

Anand Tadipatri and I have formalized Gardam's disproof in `lean 4`. We used `lean 4` as a proof assistant, but also took advantage of its being a (full fledged and really nice) programming language. This post is an account of the Unit conjecture and our formalization of it.

<!--more-->

## Kaplansky's Unit Conjecture

Kaplansky's unit conjecture says that the only units in the _group ring_ `$k[G]$` of a _torsion-free_ group `$G$` over a filed `$k$` are elements of the form `$a\cdot g$` where `$a$` is a unit in `$k$` and `$g$` is an element of `$G$`. We first recall the definition of group rings and motivate the question.

### Group Rings

Group rings are analogues of polynomials, or better still <em>Laurent polynomials</em>, i.e., finite sums 
`$\sum_{i=1}^n a_i x^{n_i}$` with `$n_i\in \Z$` for all `$i$`. The coefficients `$a_i$` are in general elements of a ring `$R$`. 

To motivate Kaplansky's conjectures, observe that if we assume that the coefficients lie in a field `$k$`, then by considering degrees we can easily deduce the following  for a pair of Laurent polynomials `$p(x)$` and `$q(x).$`

* If `$p(x)q(x)=0$`, then `$p(x)=0$` or `$q(x)=0$`.
* If `$p(x)q(x)=1$`, then both `$p(x)$` and `$q(x)$` are of the form `$cx^d$`, `$c\neq 0$`, `$d\in\Z$`.

Now, fix a group $G$ and a ring $R$. The group ring `$R[G]$` is the set of formal sums `$\sum_{i=1}^n a_i g_i$`, i.e., the free `$R$`-module with basis `$G$` (a free module is the analogue of a vector space with a given basis, allowing coefficients to be in a ring instead of a field). The multiplication in `$R[G]$` is the bilinear extension of that of  $G$, i.e., 
						`$$(\sum_{i=1}^k a_i g_i)\cdot (\sum_{j=1}^l b_j h_j) = \sum_{i=1}^k\sum_{j=1}^l (a_ib_j)(g_ih_j).$$`
Note that we group together terms in the right hand side corresponding to the same group elements.

Observe that the group ring `$R[\Z]$` is precisely the ring of Laurent polynomials, with `$\Z$` viewed as the multiplicative group `$\langle x\rangle$`, i.e., with `$n$` identified with `$x^n$`.

### Why group rings?

A vector space `$V$` over a field `$k$` with a group of linear symmetries `$G$` becomes a module over the group ring `$k[G]$`. Similarly modules over a ring `$R$` with the group of symmetries `$G$` become modules over the group ring `$R[G]$`. A typical example is the chain complex of a covering space, with `$G$` the group of deck transformations. Many important topological invariants such as the Alexander polynomials and Reidemeister torsion, are constructed from such `$R[G]$`-modules.

Indeed, the above is abstracted to give the notion of the cohomomology of a group. A specific case, _Galois cohomology_, is very important in algebraic number theory.

### Kaplansky's conjectures

We consider now group rings over a field `$k$`.

Suppose `$g$` is a torsion element in a group `$G$`, i.e., we have `$g^n = e$` for some `$n > 1$` but `$g\neq e$`. In contrast to the case of Laurent polynomials (i.e. `$G=\Z$`), we do have zero-divisors in `$R[G]$` as `$$(1-g)(1 + g + \dots + g^{n-1}) = 1 - g^n = 0.$$`
Similarly, for many groups with torsion, $k[G]$ has <em>non-trivial</em> units, i.e., units not of the form $a\cdot g$.

The Kaplansky conjectures assert that we do not have non-trivial units or zero divisors if `$k$` is torsion free, i.e., if `$k$` is a field and `$G$` is a torsion free group.

* __Unit Conjecture:__ for `$\alpha$`, `$\beta$` in `$k[G]$`, if `$\alpha\beta=1$` then there exists `$g \in G$`, `$a\in k$` such that `$\alpha = ag$`.
* __Zero divisor conjecture:__  for `$\alpha$`, `$\beta$` in `$k[G]$`, if `$\alpha\beta=0$` then `$\alpha=0$` or `$\beta=0$`.

## Whys: formalize? lean 4? Gardam's theorem?

A superb account of why we should formalize is the article [Why formalize mathematics?](https://www.imo.universite-paris-saclay.fr/~pmassot/files/exposition/why_formalize.pdf) by Patrick Massot.



## Computations in Proofs

## Free Modules and Group rings

## Gardam's group

