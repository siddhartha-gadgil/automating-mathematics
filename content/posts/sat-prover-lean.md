+++
title = "Sat Solver-Prover in Lean 4"
date = 2021-06-28T07:00:52+05:30
draft = true
tags = []
categories = []
+++

The Boolean satisfiability problem (`SAT`) asks whether a finite set of formulas in _Boolean_ variables `$P$`, `$Q$`,... has a solution. The formulas are built from the variables using logical operations such as `$\vee$` (_and_), `$\wedge$` (_or_) and `$\neg$` (_not_). A _`SAT` solver_ is a program that solves such a problem, returning a solution if solutions exists, or a proof that there is no solution if none exist. We emphasize that in the case of no solution, a `SAT` solver does not simply check all possible solutions and rule them out &mdash; instead what is returned is a deduction of _False_ (denoted `$\bot$`), i.e., a _contradiction_, assuming the existence of a solution. 
The deductions are indeed human readable structures, as we described in a [previous post]({{< ref "/posts/sat-solving.md" >}}) about implementation of a `SAT` solver (and we see again later in this post).

I describe here [SATurn](https://github.com/siddhartha-gadgil/Saturn/)  a `SAT` solver-prover I implemented in _Lean 4_. This is a program that outputs (as mentioned as a goal in the previous post)

- a solution together with a proof that this is a solution, or
- a proof that there is no solution &mdash; not just a resolution tree but a proof in the given foundations.

Furthermore, the compiler verifies that the program terminates for any valid input, and has correct output of one of the above forms. Indeed, the program (once it compiled) ran correctly immediately &mdash; I have never experienced this with a program of comparable complexity that I have written. This is in contrast to (at least my experience with) computer assisted proofs of any complexity even in strongly-typed language like scala  &mdash; a lot of time spent, and especially cognitive burden, is in checking and debugging.

## Why `SAT`?

The importance of `SAT` comes from  the Cook-Levine theorem from the early 1970s. This says that if `$SAT$` has a polynomial time solution, then _every_ problem that is in `NP` can be solved in polynomial time. Indeed every problem in `NP` can be mapped to a problem in `SAT` so that a solution of the `SAT` problem can be transformed in polynomial time to a solution of the original problem. In practice even problems that are not in `NP` make use of `SAT` solvers to solve sub-problems.

An additional motivation for considering `SAT` is that I feel it is a typical algorithmic mathematical problem. Specifically, a solution to `SAT` involves a smart search, giving a structured mathematical object that is often useful for further work (though in the worst case is too large and complex to comprehend). This proof object maps to an actual proof of a statement, with correctness of the proof depending only on the correct formulation of the statement, which is easy. Many mathematical algorithms are of this nature, though in general one has to allow a third `unknown` result in addition to _sat_ and _unsat_. 

For instance a search for whether a knot is (_slice_)[https://en.wikipedia.org/wiki/Slice_knot]  can give a bounding disc (showing slice), an obstruction to being slice (showing not slice) or fail. In case we get an answer (either positive or negative), this will be illuminating beyond establishing the truth of the statement.

## Why _Lean 4_ for solver-provers?

A _solver-prover_ for a mathematical problem is a program that is guaranteed to terminate and return an answer with a proof of its correctness. The proof of correctness should either be in the foundations of a formal system, or should be transformable into such a proof, again with a guarantee that the transformation function is correct and terminates. In the case of problems without algorithmic solutions (or with algorithmic solutions but where we may wish to allow a timeout), we can consider _incomplete solver-provers_, which may return `unknown`.

For solver-provers to be possible, useful and practical we need a language with three features &mdash; the first two are needed even for the possibility.

1. Statements and proofs can be represented in the language so that the compiler checking correctness.
2. The language can run efficiently.
3. There is a decent mathematics library and community of mathematicians working with the language.

Without the first, clearly the compiler cannot check correctness and termination. Without the second, nobody will be able to run the algorithms; so they will be essentially constructive proofs.

The presence of a mathematical library means that one does not have to start from scratch. More importantly, if each implementation of algorithms involving, for example, free groups uses its own representation, they will not be able to work together. Finally, if solver-provers work well they can contribute to the library.

## Using Saturn

I will not discuss here the details of implementation, which closely follows the _scala_ implementation described in a [previous post]({{< ref "/posts/sat-solving.md" >}}). I only describe (some aspects of) how `SAT` problems and proofs are represented and how SATurn works in some simple examples. This section assumes familiarity with Lean or some similar language such as Agda or Idris.

### Representing `SAT`

Any `SAT` problem can be represented in __CNF__. This means that we are given a finite collection of formulas which must be satisfied, each of which is a so called _clause_. A clause is a formula of the form `$l_1\dots l_n$`, with each `$l_j$` (a _literal_) of the form either `$P$` or `$\neg P$` for a variable `$P$`. 

Note that if both `$P$` and `$\neg P$` are present then the formula is always true. We omit such formulas. Thus, to specify a clause is equivalent to specifying for each variable `$P$` which of three possible cases listed below holds. It is natural to associate to the three cases an element in `Option Bool`, namely

1. `$P$` is present: we associate `some true`,
2. `$\neg P$` is present: we associate `none`,
3. neither `$P$` nor `$\neg P$` are present: we associate `none`.

We shall use indices from `$0$` to `$n - 1$` to represent the variables if `$n$` is the number of variables. Thus, a clause is (represented by) a finite sequence of length $n$ with values in `Option Bool`. A finite sequence with values in a type `$\alpha$` is in turn represented by a dependent function 
`$(j: \textrm{Nat}) \to j < n \to \alpha$` (I switched to this from `$Fin n \to \alpha$` due to problems with pattern matching since `$Fin n$` is not an indexed inductive type in Lean).

A _valuation_, i.e, assignment of truth to each variable, clearly corresponds to a finite sequence of booleans. It is easy to see that a clause `$c$` is true at some valuation`$v$` if and only if, for some `$j$` in the appropriate range, `$c (j) = some (v(j))$`. Thus, taking witnesses into account, we define `sat` and unsat` for a finite sequence of clauses by

```lean
def sat{dom n: Nat}(clauses : FinSeq dom (Clause (n + 1))) :=
          ∃ valuat : Valuat (n + 1),  
           ∀ (p : Nat),
            ∀ pw : p < dom, 
              ∃ (k : Nat), ∃ (kw : k < n + 1), (clauses p pw k kw) = some (valuat k kw)
```

and

```lean
def unsat{dom n: Nat}(clauses : FinSeq dom (Clause (n + 1))) :=
          ∀ valuat : Valuat (n + 1),  
           Not (∀ (p : Nat),
            ∀ pw : p < dom,   
              ∃ (k : Nat), ∃ (kw : k < n + 1), (clauses p pw k kw) = some (valuat k kw))
```

### Examples

We define three clauses and two corresponding statements as follows:

```lean
def cl1 : Clause 2 :=   -- P ∨ Q
  (some true) +: (some true) +: FinSeq.empty

def cl2 : Clause 2 := -- ¬P
  (some false) +: (none) +: FinSeq.empty


def cl3 : Clause 2 := -- ¬Q
  (none) +: (some false) +: FinSeq.empty


def eg1Statement : FinSeq 3 (Clause 2) := cl2 +: cl1 +: cl3 +: FinSeq.empty
def eg2Statement := tail eg1Statement
```

Typically one does not know whether the solution is positive or negative. Hence it is best to first find structured solutions using `solve` and view them. We shall see how to skip this step if desired. Thus we run 

```lean
def eg1Soln := solve (eg1Statement)
def eg2Soln := solve (eg2Statement)

#eval eg1Soln.toString
#eval eg2Soln.toString
```

and obtain the output

```lean
Examples.lean:29:0
"unsat: [none, none] from [(some false), none] & [(some true), none]; using: {[(some false), none]} and {[(some true), none] from [none, (some false)] & [(some true), (some true)]; using: {[none, (some false)]} and {[(some true), (some true)]}}"
Examples.lean:30:0
"sat: [true, false]"
```

We can then obtain the proofs of the appropriate proposition using the `getProof` method on the structured proof. This depends on the _typeclass_ `Prover` which associates a statement and proof to the structured proof.

```lean
def eg1 : unsat eg1Statement := getProof eg1Soln -- should be unsat
def eg2 : sat eg2Statement := getProof eg2Soln -- should be sat
```

If we use `sat` or `unsat` incorrectly, then the type is wrong and we get a compiler error. If we do not specify the type, it is inferred more weakly, so is not 
readily usable. A method `proveOrDisprove` combines `solve` and `getProof`.
