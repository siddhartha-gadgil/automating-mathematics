+++
title = "Forward Reasoning in Lean 4"
date = 2022-03-10T19:20:21+05:30
draft = true
tags = []
categories = []
+++

I describe here my experiments with _forward reasoning_ (reasoning from the premises), as well as _mixed reasoning_ (reasoning both from the premises and from the conclusion) in Lean 4. The code for this is in the [Lean Loris](https://github.com/siddhartha-gadgil/lean-loris) repository. This code (and especially the ideas in it) is a successor to my scala code in [ProvingGround](https://github.com/siddhartha-gadgil/ProvingGround). The file [ProofExamples.lean](https://github.com/siddhartha-gadgil/lean-loris/blob/main/LeanLoris/ProofExamples.lean) contains some simple examples of forward and mixed reasoning.

Lean has a very powerful collection of _tactics_ to perform backward reasoning, i.e., reasoning starting from the conclusion. One hopes that the forward reasoning capabilities can complement these. In particular, forward reasoning can be open-ended, exploring consequences of the premises.

<!--more-->

## Purely forward reasoning: examples, techniques.

The main example on which I focussed while developing this code (as also part of my earlier code) was a problem from a Czech-Slovak Olympiad (the first experiments with this in ProvingGround were done by Achal Kumar, an undergraduate at IISc). This illustrates the main ingredients of forward reasoning, which I will sketch in the context of our code finding the proof (with tuning for the problem). 

I will also give a second example which is easier, and can be instantly solved in the interpreter. The easier example illustrates a way of using the Lean-Loris code.

### The Problem and a Proof

Let `$M$` be a set with a binary operation `$*$`. Suppose we have the axioms
* `$\forall a, b \in M, (a * b) * b = a$`,
* `$\forall a, b \in M, a * (a * b) = b$`,

then `$\forall m, n\in M$, $m * n = n * m$`.

To begin with, here is a _lean_ proof of this theorem (a mathematical sketch follows).

```lean
theorem CzSlOly : (∀ a b : M, (a * b) * b = a) → 
    (∀ a b : M, a * (a * b) = b) → (m n: M) → m * n = n * m := by
        intros ax1 ax2 m n
        have lem1 : (m * n) * n = m := ax1 m n
        have lem2 : (m * n) * ((m * n) * n) = n := ax2 (m * n) n
        have lem3 : ((m * n) * m) * m = m * n  := ax1 (m * n) m
        have lem4 : (m * n) * ((m * n) * n) = (m * n) * m := 
            congrArg (fun x => (m * n) * x) lem1              
        have lem5 : (m * n) * m = n := by
            rw [lem4] at lem2
            assumption
        have lem6 : ((m * n) * m) * m = n * m  := 
            congrArg (fun x => x * m) lem5 
        rw [lem3] at lem6
        assumption 
```

Fix elements `$m$` and `$n$` in `$M$`. We obtain the first 3 lemmas that are obtained by substituting various elements of $M$ in the axioms. Thus, we have

* Lemma 1: `$(m * n) * n = m$`
* Lemma 2: `$(m * n) * ((m * n) * n) = n$`
* Lemma 3: `$((m * n) * m) * m = m * n$`

The next lemma is obtained by multiplying both sides of Lemma 1 on the left by `$m * n$`. This uses the property that given an equality `$x = y$` for `$x, y\in S$` and a function `$f: S \to T$`, we can deduce the equality `$f (x) = f (y)$`. This is called `congrArg` in lean. Thus, we deduce:

* Lemma 4: `$(m * n) * ((m * n) * n) = (m * n) * m$`

So far the statements deduced have been getting successively more complicated. Crucially, in the next step we deduce a lemma whose statement is simpler than the previous ones. Using Lemmas 2 and 4 and the symmetry and transitivity of equality, we deduce

* Lemma 5: `$(m * n) * m = n$`

We now multiply both sides of this equation by `$m$` and obtain

* Lemma 6: `$((m * n) * m) * m = n * m$`

And finally Lemmas 3 and 6 give

* Theorem : `$m * n = n * m$`

#### On finding the proof

There are two things we do to find the proof:

* generate terms and proofs from previous proofs in various ways.   
* recognize non-trivial, hence potentially useful, results : here we just consider results with _simple_ statements.

### Generating and selecting terms and proofs

We make use of lean's superb meta-programming framework to generate terms and proofs. We work with collections of _expressions_.

#### Expression distributions

We start with and generate distributions of expressions. In my earlier approach (in ProvingGround) I used probability distributions. However I used a simpler approach (as experience suggested this is more robust, besides greatly speeding up computations). The collections we use, `ExprDist`, are arrays of expressions with _degrees_, with the degree a natural number. The degree roughly plays the role of `$-log(p)` for a probability `$p$`, but there is no normalization analogous to total probability one. More importantly, when distributions are combined, the resulting degree of an element present in both is taken to be the _minimum_ of the degrees.

In practice we have two arrays, one for expressions representing terms that are not proofs and one for those representing proofs. The latter is an array of triples, including also the proposition proved. At each stage it is assumed and ensured that no two terms in the array are _definitionally equal_, and the propositions corresponding to two proofs are also not _definitionally equal_. We need to use arrays, rather than `HashMap`s, as hashes are only invariant under _boolean equality_ of expressions.

#### Simple Evolvers

We call functions that generate expression distributions from existing distributions given parameters such as bounds on degrees _evolvers_. A trivial one simply returns the same distribution. Others can be formed by using functions application, including with _unification_. We use evolvers based on application in the Czech-Slovak olympiad problem. These let us deduce the first three lemmas, which are simply function applications of the axioms. In practice we use a couple of variations of function applications -- where we have two arguments (for binary operations and relations) and where the function is given by a name.

Further, evolvers can be combined by combining the distributions they generate. As mentioned above, distributions are combined by taking minimum degree.

#### Islands and Recursive Evolvers

To deduce Lemma 4, we need to deduce an equality of the form `$f(a) = f(b)$` from an equality of the form `$a = b$`. For this we need to generate functions with _domain_ the type of `$x$` (and `$y$`). For this, we use _Recursive Evolvers_, i.e., evolvers that depend on other evolvers. These are then combined and called with recursively as we outline below.

Firstly, we describe the recursive evolver we use here, which will depend on a given evolver. Suppose we have an equality `$a = b$` with type `$\alpha$`. We introduce a variable `$x$` with type `$\alpha$` and add this with degree `$0$` to the initial distribution (we view this as entering an island). We then apply the given evolver to this, with appropriate parameters (in particular, the bound on degree is reduced by one). This gives a distribution of expressions with degrees, which we call the _isle distribution_, with expressions in this distribution in general depending on the variable `$x$`. To get the final distribution of the recursive evolver we map an expression `$y$` to the expression `$x \mapsto y$`, a so-called `$\lambda$`-expression.

Implementing the above is easy because of the superb meta-programming facilities of lean 4 -- an environment can be created with a new free variable (using `withLocalDecl`), the given evolver run and a convenient function (`mkLambdaFVars`) can be used for mapping `$y$` to `$x \mapsto y$`.

We define the recursive evolver needed to prove Lemma 4 using an island as above. For efficiency we group equalities by the types of their left-hand sides (which is also the type of their right-hand sides). For each type `$\alpha$` of a left-hand side, we generate functions `$f$` with domain `$\alpha$`. We then apply these to the equalities.

For efficiency, in the isles used above we do not generate constant functions -- more precisely we filter out expressions that were in the initial distribution before mapping. In other isles, if a term `$y$` is a type we also generate the corresponding `$\Pi$`-type `$\prod_x y$`. 
#### Combining and calling recursive evolvers

As with evolvers , recursive evolvers can be combined by combining their final distributions. Further, an evolver can be made into a recursive evolver by simply ignoring the evolver passed to it as an argument. We can thus combine recursive evolvers and simple evolvers.

A recursive evolver depends on a given evolver. However, we can make a recursive evolver into a simple evolver by a recursive call (which is a _fixed point_ of the defining function). For simplicity if we ignore the other arguments of the recursive evolver, we can think of this as follows.

* `Evolver` is the type of evolvers.
* A recursive evolver is a function `recEv : Evolver \to Evolver` that takes an evolver and returns an evolver.
* Given `recEv`, we define an evolver `ev: Evolver` by the equation `ev = recEv (ev)`.

It is crucial that we first combine recursive evolvers and then take the fixed point of the resulting evolver. Otherwise a recursive evolver will call only itself on its islands.

#### Recognizing lemmas and generating equalities

Given a collection of equalities, we can generate new ones using symmetry and transitivity. We can try to generate the proof of Lemma 5 except that by this stage. However if we assign the proof degree based on how it was generated, its degree will be too high -- either the degree bound will prevent us from generating a proof of Lemma 6 using this or there will be so many expressions within the degree bound that the system will run out of resources.

We can (and do have a function to) transform expression distributions so that the weight of a proof is replaced by the weight of the statement if the latter is lower. However, in this case to use this will mean generating with weight bound large enough to generate the proof of Lemma 5, and this stretches (perhaps exceeds) available resources. Instead we can, and do, _look ahead_ and observe that the generated equality will have low weight. Thus, the evolver we use to apply symmetry and transitivity generates equalities with either the proof or the statement within the weight bound.

#### Solving the problem

The evolvers sketched above are all we need to solve the problem with some help with the initial distribution and with with appropriately chosen combinations of evolvers with suitable degree bounds. Observe that we can compose evolvers, and the evolver we use is indeed a composition. Concretely, the proof is discovered as follows.

* Our initial distribution has, with degree `$0$`, expressions for `m`, `n`, `m * n`, the two axioms and the name `mul` corresponding to multiplication. Except `m * n` all others are canonical (and would be picked up by tactics as we sketch below). Including `m * n` is extra help we are giving the prover, but could alternatively be derived from the heuristic assigning weight `$0$` to sub-expressions of the goals.
* We use a composition of two basic evolvers (both also include the trivial evolver that returns the same distribution):
    -- one with evolvers based on function application (including with unification, with two arguments, and with names of functions) and the evolver generating appropriate functions and deducing equalities of the form `$f(a) = f(b)$` from equalities `$a = b$`. This is used with weight bound `$3$`.
    -- the evolver that deduces equalities from others using symmetry and transitivity, with the look-ahead generation and degree assignment. This is used with weight bound `$1$`.
* Specifically, we apply the first evolver, then the second, then the first again and then the second again. This is done by constructing a composed evolver (with the side-effect of logging progress after each evolver).
* We see (from the logs) that the first `$4$` lemmas are generated in the first step (first evolver), Lemma 5 in the second step (second evolver), Lemma 6 in the third step (first evolver again), and the theorem in the fourth step.
* This is run in compiled code, and finishes in about a minute and a half on my laptop (a Dell XPS with 16 GB RAM).

### A second example: `$e_l = e_r$`

We consider a second example to illustrate purely forward reasoning. This is much easier, so we can include the code to prove this (instantly, in the interpreter). 

The problem we consider is often one of the first abstract problems a student encounters in mathematics -- given a product with a left identity `$e_l$` and a right identity `$e_r$`, we have `$e_l = e_r$`. We can use evolution in two forms -- based on _elaboration_ or based on _tactics_. We give the proof based on tactics as the notation is cleaner and tactics will be more familiar to most. Here is the first such proof.

```lean
def left_right_identities1(α : Type)[Mul α](eₗ eᵣ: α)
    (idₗ : ∀ x : α, eₗ * x = x)(idᵣ : ∀ x: α, x * eᵣ = x) : 
        eₗ = eᵣ := by
            evolve ev![simple-app, eq-closure]  2
```

In this case, though the goal was given it was not used at all (in fact was a distraction). While the initial state is often specified, it can be omitted as above. In that case all free variables in the local context (except the head, which is the function being defined) are taken with degree `$0$` as is the goal. All we needed to specify the evolvers used and the degree bound. Here the evolvers used were simple application (i.e., without unification) and the equality closure. This is fairly robust -- we could have used unification (instead of or in addition to the simple application), or a higher degree bound, for example.

Even though the above was simple, we give a second proof to illustrate two things. This again runs instantly in the interpreter.

```lean
def left_right_identities2(α : Type)[Mul α](eₗ eᵣ: α)
    (idₗ : ∀ x : α, eₗ * x = x)(idᵣ : ∀ x: α, x * eᵣ = x) 
        : eₗ = eᵣ:= by
            evolve ev![app] 1  =: dist1
            evolve ev![eq-closure] dist1 1 
```

Firstly, observe that the final cut-off was taken as `$1$` instead of `$2$` in the first proof -- this is because of the simple statement. Secondly, observe that the result of the first evolution is saved and used as the initial state for the second evolution -- appropriate serialization is needed for this.

## Mixed reasoning: examples and evolvers

We describe some examples where forward reasoning is mixed with backward reasoning. We do not have an explicit notion of goals -- instead (expressions for) terms in the expression distribution that are (expressions for) propositions (or even types) are viewed as goals. We have functions that lift a tactic to an evolver. In our examples, we essentially use lifts of the `induction`, `intro` and `apply` tactics, though for technical reasons we use evolvers that we directly implement.

### First example: if `$f(n + 1) = f(n)$` for all `$n$` then `$f$` is constant.

Our main example for mixed reasoning is the following: suppose `$f: \mathbb{N} \to \alpha$` is a function on natural numbers such that `$\forall n\in \mathbb{N}, f(n + 1) = f(n)$`, then `$\forall n\in \mathbb{N}, f(n) = f(0)$`. This can be proved in compiled code in 3--4 seconds (on my laptop), with evolvers tuned for this problem.

Specifically, we use two evolvers that are based on backward reasoning:

* induction for natural numbers,
* introduction of a variable (hence an island) for the domain of a `$\Pi$`-type.
* proving equalities of the form `$x = x$` by reflexivity.

The forward reasoning evolvers are some of those described above 

* function application
* using symmetry and transitivity of equality (with look-ahead reduced degree for generated equalities where appropriate). 

A second example of such mixed reasoning is Modus Ponens. This is instantly proved in the interpreter as follows.

```lean
def modus_ponens(A B: Prop) : A → (A → B)→ B := by
  evolve ev![intro, simple-app] 1 
```

Alternatively, we can use lean's apply tactic for the backward reasoning with an evolver to complete the proof.

```lean
def modus_ponens2(A B: Prop) : A → (A → B)→ B := by
  intros
  evolve ev![simple-app] 1
```

## Concluding remarks

Our methods are undoubtedly much less powerful than two dominant modes of automated proving -- tactics and SAT/SMT solvers. We hope however that the methods here complement these. This is especially so as we seek to automate reasoning further, as finding intermediate steps in purely backward reasoning is difficult. One of the things I plan to work on (and did do to some extent in ProvingGround) is to identify (simple) statements that have neither been proved nor disproved and target them with mixed reasoning.

Currently we have two ways of forming an initial state -- specifying it manually or using the local context. The most important workpoint here (and in many other contexts) is to have reasonable _premise selection_, which is learned from data. This is a natural target for machine learning.
