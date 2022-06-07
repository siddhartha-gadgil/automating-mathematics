+++
title = "Formalizing Gardam's disproof of Kaplansky's Unit Conjecture"
date = 2022-06-07T06:50:53+05:30
draft = false
tags = []
categories = []
+++

A little over an year ago, Giles Gardam [disproved](https://arxiv.org/abs/2102.11818) a long-standing conjecture, often called the _Kaplansky Unit Conjecture_. This was a striking result -- the statement was a simple and basic one, it had a long history, and it was one of a cluster of related conjectures with important relations to many areas (including the Whitehead conjecture in topology). Gardam's work is published in the _Annals of Mathematics_.

Anand Rao Tadipatri and I have [formalized](https://github.com/siddhartha-gadgil/Polylean) Gardam's disproof in __lean 4__. We used __lean 4__ as a proof assistant, but also took advantage of its being a (full fledged and really nice) programming language. This post is an account of the Unit conjecture and our formalization of it.

<!--more-->

## Kaplansky's Unit Conjecture

Kaplansky's unit conjecture says that the only units in the _group ring_ `$k[G]$` of a _torsion-free_ group `$G$` over a field `$k$` are elements of the form `$a\cdot g$` where `$a$` is a unit in `$k$` and `$g$` is an element of `$G$`. We first recall the definition of group rings and motivate the question.

### Group Rings

Group rings are analogues of polynomials, or better still <em>Laurent polynomials</em>, i.e., finite sums 
`$\sum_{i=1}^k a_i x^{n_i}$` with `$n_i\in \Z$` for all `$i$`. The coefficients `$a_i$` are in general elements of a ring `$R$`. 

To motivate Kaplansky's conjectures, observe that if we assume that the coefficients lie in a field `$k$`, then by considering degrees we can easily deduce the following  for a pair of Laurent polynomials `$p(x)$` and `$q(x).$`

* If `$p(x)q(x)=0$`, then `$p(x)=0$` or `$q(x)=0$`.
* If `$p(x)q(x)=1$`, then both `$p(x)$` and `$q(x)$` are of the form `$cx^d$`, `$c\neq 0$`, `$d\in\Z$`.

Fix a group $G$ and a ring $R$. The group ring `$R[G]$` is the set of formal sums `$\sum_{i=1}^n a_i g_i$`, i.e., the free `$R$`-module with basis `$G$` (a _free module_ is the analogue of a vector space with a given basis, allowing coefficients to be in a ring instead of a field). The multiplication in `$R[G]$` is the bilinear extension of that of  $G$, i.e., 
						`$$(\sum_{i=1}^k a_i g_i)\cdot (\sum_{j=1}^l b_j h_j) = \sum_{i=1}^k\sum_{j=1}^l (a_ib_j)(g_ih_j).$$`
Note that we group together terms in the right hand side corresponding to the same group elements.

Observe that the group ring `$R[\Z]$` is precisely the ring of Laurent polynomials with coefficients in `$R$`, with `$\Z$` viewed as the infinite cyclic multiplicative group `$\langle x\rangle$`, i.e., with `$n\in\Z$` identified with the element `$x^n\in \langle x\rangle.$`

### Why group rings?

A vector space `$V$` over a field `$k$` with a group of linear symmetries `$G$` becomes a module over the group ring `$k[G]$`. Similarly modules over a ring `$R$` with the group of symmetries `$G$` become modules over the group ring `$R[G]$`. A typical example is the chain complex of a covering space, with `$G$` the group of deck transformations. Many important topological invariants, such as the Alexander polynomials and Reidemeister torsion, are constructed from such `$R[G]$`-modules.

Indeed, the above is abstracted to give the notion of the cohomology of a group. A specific case, _Galois cohomology_, is very important in algebraic number theory.

### Kaplansky's conjectures

Consider group rings over a field `$k$`. Suppose `$g$` is a torsion element in a group `$G$`, i.e., we have `$g^n = e$` for some `$n > 1$` but `$g\neq e$`. In contrast to the case of Laurent polynomials (i.e. `$G=\Z$`), we do have zero-divisors in `$k[G]$` as `$$(1-g)(1 + g + \dots + g^{n-1}) = 1 - g^n = 0.$$`
Similarly, for many groups with torsion, $k[G]$ has <em>non-trivial</em> units, i.e., units not of the form $ag$.

The Kaplansky conjectures assert that we do not have non-trivial units or zero divisors if `$G$` is __torsion free__, i.e., if `$k$` is a field and `$G$` is a torsion free group. Thus, if `$k$` is a field, and `$G$` is a torsion free group, we have the following conjectures.

* __Unit Conjecture:__ for `$\alpha$`, `$\beta$` in `$k[G]$`, if `$\alpha\beta=1$` then there exists `$a\in k$`, `$g \in G$`  such that `$\alpha = ag$`.
* __Zero divisor conjecture:__  for `$\alpha$`, `$\beta$` in `$k[G]$`, if `$\alpha\beta=0$` then `$\alpha=0$` or `$\beta=0$`.

Beyond the simplicity and generality of the statements, these are attractive because of their similarity, both formally and structurally, to many important questions. For example, in understanding a basic question in topology -- the relation between homotopy type and homeomorphism type -- Whitehead introduced an intermediate relation, _simple homotopy type_, and showed that simple homotopy types are classified by elements of the _Whitehead Group_. Again, torsion elements lead to non-trivial Whitehead groups, while the __Whitehead Conjecture__ postulates that torsion-free groups have trivial Whitehead groups. Indeed there are direct relations too between the Whitehead group and Kaplansky's conjectures.

## Gardam's theorem

__Theorem (Gardam)__ Kaplansky's unit conjecture is false.

Specifically, Gardam considered a certain (well studied) group `$P$`, called the _Promislow_ or _Hantzsche–Wendt_ group. This was known to be torsion free. Gardam showed that there are elements `$\alpha, \alpha'\in \mathbb{F}_2[P]$` with `$\alpha\cdot\alpha'=1$` and with `$\alpha$` not of the form `$ag$`. The elements were discovered by a computer search using [SAT solvers]({{< ref "/posts/sat-solving.md" >}}) and were given explicitly by Gardam.

Gardam gives many descriptions of the group `$P$`. Indeed, for topologists, it is the fundamental group of a `$3$`-manifold `$M$` obtained by gluing two copies of the twisted `$I$`-bundle over the Klein bottle along their boundaries. But the description that was most convenient to us was as a _Metabelian_ group. We next recall metabelian groups.

### Metabelian Groups 

A _Metabelian Group_ is a group `$G$` with an _abelian normal subgroup_ `$K$` so that the quotient `$Q=G/K$` is also abelian. The simplest such groups are the products `$K \times Q$`, which are in fact abelian.  However for fixed `$K$` and `$Q$`, there are in general other corresponding metabelian groups `$G$`, as we see with following examples.

* The permutation group  `$G=S_3$` on `$3$` letters is a metabelian group, with abelian normal subgroup `$K\cong \Z/3$` generated by the cycle `$\sigma$` and quotient `$Q\cong \Z/2$`.
* Let `$G=\Z$` and `$K=2\Z$` be the subgroup of even integers. Then `$Q = G/K \cong \Z/2$`. This gives `$\Z$` a description as a metabelian group with `$K\cong \Z$` and `$Q\cong \Z/2$`.

The two examples illustrate the two ways in which `$G$` can fail to be a product. We see that, in a precise sense, these are the only two ways. Thus, we can determine all metabelian groups `$G$` corresponding to fixed `$K$` and `$Q$` in terms of some explicit data. We remark that this is a special case of the so called _group extension_ problem.

Firstly, observe that as a _set_ we can always identify `$G$` with `$K\times Q$` by choosing a _section_ `$s: Q \to G$`, i.e., a function `$s: Q \to G$` such that `$q(s(x))=x$` for all `$x$` in `$Q$`, where `$q: G \to Q$` is the quotient homomorphism. Every element `$g\in G$` is then uniquely of the form `$g =k\cdot s(q)$` with `$k\in K$` and `$q \in Q$`. 

In the case of the permutation group we can choose `$s$` to be a homomorphism by mapping the generator `$1_2$` of `$\Z/2$` to a transposition `$\tau$`. Thus `$Q$` can be identified with a subgroup of `$G$` and `$s$` regarded as the inclusion (and omitted from the notation). However, an elements of the group `$K\subset G$` does not in general commute with an element of `$Q\subset G$`, so `$G$` is not a product of `$K$` and `$Q$`. Instead, we can write `$kqk'q' = kk'^{q}qq'$`, where `$k'^q=qk'q^{-1}$` is the result of conjugation. Conjugation gives a _group action_ of `$Q\subset G$` on `$K$`. Conversely, given an arbitrary group action `$Q \times K\to K$`,  `$(q, k) \mapsto q\cdot k$`, we can define a metabelian group with underlying set `$K\times Q$` and multiplication given by the formula 
`$$(k, q)\cdot (k', q') = (k + q\cdot k', q+ q').$$`
This is a special case of the familiar _semi-direct product_ construction.

Indeed, as `$K$` is abelian, for all metabelian groups we have an action of `$Q$` on `$K$` which does not depend on `$s$`. This action is part of the data determining a metabelian group. Suppose henceforth we have fixed `$K$`, `$Q$` and a group action of `$Q$` on `$K$`.

The second example illustrates that the group action is not enough to determine `$G$`; indeed, as `$G$` is abelian the action is trivial, but `$G$` is not the product of `$K$` and `$Q$`. The reason for this is we cannot choose the section `$s:Q \to G$` to be a homomorphism; the image `$s(1_2)$` must be an odd number `$2k + 1$`, and while `$1_2 + 1_2 = 0$`, `$s(1_2) + s(1_2) = 4k + 2\neq 0$` (and `$s(0) = 0$` for a homomorphism). 

We can measure the extent to which `$s$` is not a homomorphism by considering, for elements `$q, q'\in Q$`, the quantity `$c(q, q') := s(qq')\cdot(s(q)s(q'))^{-1}$.` As `$s$` is a section, we can deduce that in fact `$c(q, q')\in K\subset G$`, so `$c$` gives a function `$c: Q \times Q \to K$`.

The associativity of `$G$` implies a certain condition on the function `$c$`, called the _cocycle condition_. Functions `$c: Q \times Q \to K$` satisfying this condition are called _cocycles_. Conversely, given a (group action and) a cocycle, we can define a group structure on `$G= K \times Q$` by 
`$$(k, q)\cdot (k', q') = (k + q\cdot k' + c(q, q'), q+ q').$$`
Indeed all metabelian groups are of this form. Thus, a metabelian group is determined by $K$, $Q$, an action of $Q$ on $K$ and a cocyle. 

As an aside (not used in the sequel), note that even if $G$ is a (semi-)direct product an arbitrary section `$s: Q \to G$` need not be a homomorphism (indeed is usually not a homomorphism). Thus, the cocycle `$c$` is not zero. However, note that if `$s$` is a section and `$\varphi: Q \to K$` is a function, then `$s': q \mapsto \varphi(q)s(q)$` is a section, and indeed all sections are of this form. It is easy to compute the cocycle `$c'$` corresponding to `$s'$` in terms of `$c$` and `$\varphi$`, namely `$c'$` differs from `$c$` by a so called _coboundary_. Thus, metabelian groups are determined by $K$, $Q$, an action of $Q$ on $K$, and a cocyle up to a coboundary. A cocycle up to a coboundary is an element of a group called `$Ext(Q, K)$` (for extension), which is also the group cohomology `$H^1(Q, K)$`.

### The Group `$P$` and its Torsion Freeness

The group `$P$` is a metabelian group with kernel `$K=\Z^3$` and quotient `$Q=\Z/2\times \Z/2$`. Gardam gives an explicit description of the action and the cocycle which determine `$P$`. This allows us to explicitly (without much effort) work with elements in `$P$`. In particular, the (well known) result that `$P$` is torsion free can be proved as follows:

* Let `$g\in P$` and `$n > 1$` be such that `$g^n=e$`.
* Observe that `$(g^2)^n = (g^n)^2 = e$` (this is true for any group).
* Using the explicit description of `$P$`, we see that `$g^2\in K\cong \Z^3$`.
* As `$K\cong \Z^3$` is torsion free and `$(g^2)^n=e$`, it follows that `$g^2=e$`.
* Using the explicit description of `$P$` once more, we see that `$g^2=e$` implies `$g =e$`, completing the proof of torsion freeness. 

# Formalization: proofs, computation

Formalization is the process of explaining a proof to a computer, i.e., writing a proof in a form that a computer can understand. This is typically done in an interactive theorem prover, as in our case where we used __lean 4__. 

The system in particular checks the correctness of the proof. Further, the part of the system that checks correctness is a small _kernel_, whose correctness can be carefully checked. One can also write independent checkers that check proofs. Thus, formalization gives a superhuman guarantee of correctness. 

But the applications, present and future, of formalization are not limited to checking correctness of proofs. The article ["Why formalize mathematics?"](https://www.imo.universite-paris-saclay.fr/~pmassot/files/exposition/why_formalize.pdf) by Patrick Massot is a superb account of why formalization is worthwhile.

Our particular formalization used, and is in part motivated by illustrating, the integration of computation (that is provably correct) and proving within the same system. Such an integration is an attractive aspect of __lean 4__ -- the latest (under development) version  of the __lean theorem prover__. Gardam's theorem was very well suited for such a formalization. We were additionally motivated by our interest in Geometric Group Theory.

We sketch below some of the aspects of the formalization, in particular illustrating methods and choices for integrating proofs and computations. Henceforth, __show__ or __prove__ mean __formally prove in lean 4.__

## Free Modules and Group rings

We need to construct the group ring `$\mathbb{F}_2[P]$` and also be able to decide (with proof) when two elements of `$\mathbb{F}_2[P]$` are equal. Being able to decide whether a proposition is true or false together with a proof in either case is encoded in a so-called _typeclass_ called `Decidable`. We make extensive use of this, as well as so called _typeclass inference_ that automates (among other things) solving decision problems using solutions of simpler decision problems.

A group ring `$R[G]$` is a free `$R$`-module with an additional structure, the product. Further the product is a bilinear extension of a function given on the basis `$G$` of the free `$R$`-module. Thus, our goal is to construct free `$R$`-modules with basis `$X$`, including when `$X$` is infinite, allowing both of the following.

* We can decide when two elements of the free `$R$`-module are equal, provided we can decide equality in `$R$` and in `$X$`.
* We can define `$R$`-module homomorphisms given their values on the basis `$X$`.

The first is a computational goal and the second a theoretical one. To achieve both, we make two constructions, and essentially prove they are equivalent. Both are quotients of _formal sums_. We first sketch the first construction, which is the definition used, and decidable equality using this. We then sketch the second construction and its equivalence to the first.

### Formal sums, Coordinates and Free modules 

Fix a ring `$R$` and `$X$`. A _formal sum_ is an expression of the form `$\sum_{i=1}^n a_i x_i$` where `$a_i\in R$` and `$x_i\in X$`-element. We simply encode these as lists of pairs `$(a_i, x_i)$`.

Given a formal sum `$\sum_{i=1}^n a_i x_i$`, we can associate to it coordinates as a function `$\chi_s: X\to R$`, with the coordinate of an element `$x_0$` of `$X$` being the sum of the coefficients `$a_i$` corresponding to indices `$i$` with `$x_i=x_0$`. Note that only finitely many coordinates are non-zero (but we do not formally state or prove this).

Note that to define the coordinate function `$\chi_s$` as a (computable) function, we need decidability of equality in `$X$`. Lean allows us to make existential definitions marked __noncomputable__, but as we will use this definition in computations we need an effective (i.e., not declared as noncomputable) definition.

We define two formal sums `$s_1$` and `$s_2$` to be equivalent if `$\chi_{s_1} = \chi_{s_2}$`. It is easy to show that this is an equivalence relation. The free module `$R[X]$` is defined as the quotient of the formal sums of `$X$` by this equivalence relation.
### Supports and Decidable equality

Observe that if `$X$` is infinite (as it is in our case), we cannot check equality of coordinate functions by checking at all values. Thus, we need some other way to check equality of coordinates. We do this by relating coordinates to supports.

We define the support `$supp(s)$` of the formal sum `$s=\sum_{i=1}^n a_i x_i$` to be list consisting of the elements `$x_i$` (this is a coarse notion of support, ignoring that coefficients may be zero and/or may cancel). We show that if `$x_0\in X$` is not in the support of `$s$`, then `$\chi_s(x_0)$` is zero. 

Thus, for formal sums `$s_1$` and `$s_2$`, `$\chi_{s_1} = \chi_{s_2}$` if and only if we the following two statements are true:
* for all `$x_0\in supp(s_1)$`, `$\chi_{s_1}(x_0) = \chi_{s_2}(x_0)$`
* for all `$x_0\in supp(s_2)$`, `$\chi_{s_1}(x_0) = \chi_{s_2}(x_0)$`

Having proved this, we are reduced to deciding when two functions with values in `$R$` are equal for members of a list in `$X$`. This is easily done using induction (using the assumption that we can decide equality in `$R$`). Thus, we can decide when formal sums are equivalent.

With a little work, we can deduce decidability of equality in `$R[X]$` from decidability of equivalence of formal sums (these are mathematically identical).

### Elementary moves and Universal properties

In particular to construct multiplication in the Group Ring, we need to extend function from `$X$` to `$R$`-modules to `$R[X]$`-module homomorphisms. We do not formally define `$R$`-modules or prove such an extension result, but we implicitly make the definitions and prove the results involved and use them in the group ring construction.

Given a function `$f: X \to N$`, with `$N$` an `$R$`-module, `$f$` clearly extends to formal sums by `$f(\sum_{i=1}^n a_i x_i) = \sum_{i=1}^n a_i f(x_i)$`. What needs to be shown is that if formal sums are equivalent then they map to the same element. This is not so easy when `$X$` is infinite.

We instead give a second description of free modules. Namely, we define a relation on formal sums as given by elementary moves: merging coefficients for equal elements, deleting terms with zero coefficients, swapping terms, and prepending the same term to two formal sums related by an elementary move. Note that this is not an equivalence relation. Nevertheless, in lean, the quotient is defined, and is the quotient by the equivalence relation generated by the elementary moves. 

It is straightforward to show that coordinates are unchanged by elementary moves. The key result, which takes some work, is to show that two formal sums with the same coordinate function are related by a sequence of elementary moves, i.e., have equal images in the quotient by elementary moves. This in turn depends on the technical result that if a formal sum `$s$` has `$a_0:=\chi_s(x_0)\neq 0$` for some `$x_0\in X$`, then `$s$` is related by a sequence of elementary moves to a formal sum of the form `$a_0x_0 + t$`, with the number of terms in `$t$` less than the number in `$s$`. This is proved by well-founded recursion, and the main result is also deduced from this by well-founded recursion.

The relations between moves and coordinates show that the equivalence relation generated by moves is the same as that given by having the same coordinate functions. In practice, we use the consequence that a function on formal sums is constant on equivalence classes (corresponding to equal coordinates), and hence well-defined on the Free Module, if and only if it is invariant under elementary moves. This can be conveniently used by using the induction tactic for an elementary move.

### Group Rings

Using the construction and properties of Free Modules, we construct the group ring `$R[G]$`. First, we define multiplication on formal sums recursively in two steps, first recursively defining multiplication of a formal sum on the right by a monomial `$ag$`, and then recursively defining multiplication of formal sums. 

Various properties are proved by (iterated) recursion with this definition. These allow us to define the product on `$R[G]$` by showing invariance under elementary moves. This is also done in two steps, where in the first the first term is a formal sum.

Further, we show that there is a ring structure on the group ring. This is not actually used but is done as a check, as the only real point where a formal proof could be wrong is in the definitions.

## Lifting Decisions using Enumeration, Bases

As the group `$Q$` is finite, deciding whether the cocycle condition holds for a function `$c: Q \to Q \to K$`, for example, can be done by enumeration, since this is a decidable property for each triple of elements of `$Q$`. We automate such enumerations using a typeclass `DecideForall`. This captures the property of `$Q$` that if `$p:Q \to Prop$` is a property of elements of `$Q$` such that each `$p(q)$` is decidable, so is the proposition `$\forall x: Q, p(x)$`.

By recursion we prove that for `Fin n`, which consists of the natural numbers below `n`, we have an _instance_ of `DecideForAll`. This means we can decide the proposition `∀ x : Fin n, p(x)` if we can decide `p(x)` for each `x`. Further, we construct instances of `DecideForAll` of products and sums given those for components. This lets us infer an instance for `$Q$`.

Further, in the case of _finitely generated free abelian groups_, we can define homomorphisms by specifying their values on the basis, and we can decide equality of homomorphisms by enumeration of basis elements. Once more we define a typeclass, `FreeAbelianGroup` -- corresponding to an abelian group `$A$` being free with basis `$X$`. We construct instances for `$\Z$` with basis a singleton (represented by `Unit` in lean), and for direct products of free abelian groups, with basis the direct sum of the bases of the factors. Note that we do not require `$X$` to be contained in `$A$`, instead a field of the typeclass is an inclusion.

We show that if `$A$` is free abelian with basis `$X$` for some `$X$`, then equality of homomorphisms on `$A$` is decidable (provided the codomain has decidable equality). We also show that functions from `$X$` to abelian groups extend uniquely to homomorphisms on `$A$`.

## The Group `$P$`

The construction and properties of the group `$P$` in lean 4 are mostly a translation of the mathematical description from above, with the use of simplification and other tactics to show desired results (along with use of enumeration as sketched above).

### Constructing the Group

The group is constructed by first constructing metabelian groups in general given group actions and cocycles, and then specializing to the specific case of the group `$P$`. Given the action and the cocycle, the multiplication on `$K\times Q$` is straightforward. Work is needed to show that this is indeed a group, especially that the group action property and the cocycle condition imply associativity.

### Torsion freeness

Torsion freeness similarly follows the mathematical sketch above to reduce to the torsion freeness of the subgroup `$K$`. At this stage typeclass inference is used to infer isomorphisms as well as torsion freeness. In particular a general result (encoded as an instance) shows that the subgroup is isomorphic to `$K$`. Further, it is shown that products of torsion free groups are torsion free. Thus, the problem reduces to `$\Z$` being torsion free, which is proved directly.

## The Unit Conjecture

With the group `$P$` constructed, its torsion freeness proved, and the group ring constructed, Gardam's disproof of the unit conjecture is a simple verification. Note that `$P$` is a product of types with decidable equality, so has decidable equality -- this is part of lean. Similarly the field `$\mathbb{F}_2$` has decidable equality. It follows that `$\mathbb{F}_2[P]$` has decidable equality.

As mentioned earlier, Gardam has given an explicit formula for a non-trivial unit `$\alpha$` and its inverse. We simply use the `native_decide` tactic to show, using lean's evaluation, that `$\alpha$` is a unit in `$P$`. To show that `$\alpha$` is non-trivial we show that there are two distinct coordinates that are non-zero -- with `native_decide` used to show that the coordinates are distinct and non-zero.

## Concluding Remarks

We hope that such a blend of computation and proving will be useful for many results, both formal proofs and proved algorithms. This formalization took only about two weeks (after preliminary mathematical work), suggesting that the gap between formalization and human exposition is not too large, at least for certain results (including, like Gardam's theorem, some important mathematical results).