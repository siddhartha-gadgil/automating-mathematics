+++
title = "SAT Solver-Prover in Lean 4"
date = 2021-06-28T07:00:52+05:30
draft = false
tags = []
categories = []
+++

The Boolean satisfiability problem (__SAT__) asks whether a finite set of formulas in _Boolean_ (i.e., _true_ or _false_ valued) variables `$P$`, `$Q$`,... has a solution. The formulas are built from the variables using logical operations such as `$\vee$` (and), `$\wedge$` (or) and `$\neg$` (not). A _SAT solver_ is a program that solves such a problem, returning _sat_ with a solution if solutions exists, and _unsat_  if no solutions exist, often with some kind of proof that there is no solution in the latter case.

In the case there is no solution, a SAT solver __does not__ simply check all possible assignments of boolean values to variables and see that they fail. Instead the solver searches for a _contradiction_, i.e., a deduction of _False_, assuming the existence of a solution.
The deductions may be returned as human readable tree-like structures, as we described in a [previous post]({{< ref "/posts/sat-solving.md" >}}) about implementation of a SAT solver.

I describe here [SATurn](https://github.com/siddhartha-gadgil/Saturn/) &mdash; a SAT solver-prover I implemented in __Lean 4__. This is a program that outputs one of

- a solution together with a proof that this is a solution, or
- a proof that there is no solution.

Furthermore, the compiler verifies that the program terminates for any valid input, and has correct output of one of the above two forms.

Indeed, the program (once it compiled) ran correctly immediately &mdash; something I have never experienced with a program of comparable (or even close to comparable) complexity.
In contrast, while attempting computer assisted proofs of any complexity (even in a strongly-typed language like scala) a lot of time and effort spent (and  cognitive load) is in checking and debugging.

## Why SAT?

The importance of SAT comes from  the Cook-Levine theorem from the early 1970s. This says that if SAT has a polynomial time solution, then _every_ problem that is in __NP__ can be solved in polynomial time. Indeed every problem in NP can be mapped to a problem in SAT so that a solution of the SAT problem can be transformed in polynomial time to a solution of the original problem. In practice even problems that are not in NP make use of SAT solvers to solve sub-problems.

An additional motivation for considering SAT is that I feel it is a typical algorithmic mathematical problem. Specifically, a solution to SAT involves a smart search, giving a structured mathematical object that is often useful for further work (though in the worst case is too large and complex to comprehend). This proof object maps to an actual proof of a statement, with correctness of the proof depending only on the correct formulation of the statement. Many mathematical algorithms are of this nature, though in general one has to allow _unknown_ as an option for the answer.

For instance a search for whether a knot is [_slice_](https://en.wikipedia.org/wiki/Slice_knot)  can give a bounding disc (showing slice), an obstruction to being slice (showing not slice) or fail to solve (i.e., return _unknown_). In case we get an answer (either a bounding disc or an obstruction), this will be illuminating beyond establishing the truth of the statement.

## Why __Lean 4__ for solver-provers?

A _solver-prover_ for a mathematical problem is a program that is guaranteed to terminate and return an answer with a proof of its correctness. The proof of correctness should either be in the foundations of a formal system, or should be transformable into such a proof (with a guarantee that the transformation function is correct and terminates). In the case of problems without algorithmic solutions (or with algorithmic solutions but where we may wish to allow a timeout), we can consider _incomplete solver-provers_, which may return _unknown_.

For solver-provers to be possible, useful and practical we need a language with three features, of which the first two are needed even for the possibility of a solver-prover.

1. Statements and proofs can be represented in the language so that the compiler can check correctness.
2. The language can run efficiently.
3. There is a decent mathematics library and community of mathematicians working with the language.

Without the first, clearly the compiler cannot check correctness and termination. Without the second, nobody will be able to run the algorithms &ndash; so they will be essentially constructive proofs.

The presence of a mathematical library means that one does not have to start from scratch. More importantly, all algorithms involving (for example) _free groups_ uses the same internal representation (that of the library), they will be able to work together. Finally, if solver-provers work well they can contribute to the library.

As far as I know, __Idris__ is the first language to meet the first two criteria, and __Lean 4__ is (or will soon be) the first to meet all three.

## Using SATurn

I will not discuss here the details of implementation, which closely follows the _scala_ implementation described in a [previous post]({{< ref "/posts/sat-solving.md" >}}). I only describe (some aspects of) how SAT problems and proofs are represented and how SATurn works in some simple examples. This section assumes familiarity with Lean or some similar language such as Agda or Idris.

### Representing SAT

Any SAT problem can be represented in __CNF__. This means that we are given a finite collection of formulas which must be satisfied, each of which is a so called _clause_. A clause is a formula of the form `$l_1\vee\dots\vee l_n$`, with each `$l_j$` (called a _literal_) of the form either `$l_j = P$` or `$l_j = \neg P$` for a variable `$P$`. 

Note that if both `$P$` and `$\neg P$` are present in a clause then it is always true. We omit such clauses. Thus, to specify a clause is equivalent to specifying for each variable `$P$` which of three possible cases listed below holds. It is natural to associate to the three cases an element in `Option Bool`.

1. If `$P$` is present: we associate `some true`.
2. If `$\neg P$` is present: we associate `some false`.
3. Neither `$P$` nor `$\neg P$` are present: we associate `none`.

We shall use indices from `$0$` to `$n - 1$` to represent the variables, where `$n$` is the number of variables. Thus, a clause is (represented by) a finite sequence of length $n$ with values in `Option Bool`. A finite sequence with values in a type `$\alpha$` is in turn represented by a dependent function 
`$(j: \textrm{Nat}) \to j < n \to \alpha$` (I switched to this from `$Fin\ n \to \alpha$` due to problems with pattern matching since `$Fin\ n$` is not an indexed inductive type in Lean).

A _valuation_, i.e., an assignment of truth to each variable, clearly corresponds to a finite sequence of booleans of length `$n$`. It is easy to see that a clause `$c$` is true at some valuation`$v$` if and only if, for some `$k$` with `$0\leq k < n$`, we have `$c (k) = some (v(k))$`. Thus, taking witnesses into account, we define propositions `sat` and `unsat` depending on a finite sequence of clauses by

```lean
def sat{dom n: Nat}(clauses : FinSeq dom (Clause (n + 1))) :=
          ∃ valuat : Valuat (n + 1),  
           ∀ (p : Nat), ∀ pw : p < dom, 
              ∃ (k : Nat), ∃ (kw : k < n + 1), 
                (clauses p pw k kw) = some (valuat k kw)
```

and

```lean
def unsat{dom n: Nat}(clauses : FinSeq dom (Clause (n + 1))) :=
          ∀ valuat : Valuat (n + 1),  
           Not (
            ∀ (p : Nat), ∀ pw : p < dom,   
              ∃ (k : Nat), ∃ (kw : k < n + 1), 
              (clauses p pw k kw) = some (valuat k kw)
              )
```

### Examples

We define three clauses `$P \vee Q$`, `$\neg P$` and `$\neg Q$` and two corresponding statements as follows:

```lean
def cl1 : Clause 2 :=   
  (some true) +: (some true) +: FinSeq.empty

def cl2 : Clause 2 := 
  (some false) +: (none) +: FinSeq.empty


def cl3 : Clause 2 := 
  (none) +: (some false) +: FinSeq.empty


def eg1Statement : FinSeq 3 (Clause 2) := 
                                    cl2 +: cl1 +: cl3 +: FinSeq.empty

def eg2Statement := tail eg1Statement
```

Typically one does not know whether the solution is positive or negative. Hence it is best to first find structured solutions using `solve` and view them. We shall see how to skip this step if desired. Thus we run 

```lean
def eg1Soln := solve (eg1Statement)
def eg2Soln := solve (eg2Statement)

#eval eg1Soln.toString
#eval eg2Soln.toString
```

and obtain the outputs: 

- a resolution tree

```lean
Examples.lean:29:0
"unsat: [none, none] from [(some false), none] & [(some true), none]; using: {[(some false), none]} and {[(some true), none] from [none, (some false)] & [(some true), (some true)]; using: {[none, (some false)]} and {[(some true), (some true)]}}"
```

- a valuation that is a solution

```lean
Examples.lean:30:0
"sat: [true, false]"
```

We can then obtain the proofs of the appropriate proposition using the `getProof` function on the structured proof. This depends on the _typeclass_ `Prover` which associates a statement and proof to the structured proof.

```lean
def eg1 : unsat eg1Statement := getProof eg1Soln 
def eg2 : sat eg2Statement := getProof eg2Soln 

#check eg1
#check eg2
```

If we specify the type using the incorrect choice between `sat` and `unsat`, then we get a compiler error. If we do not specify the type, it is inferred more weakly, so is not
readily usable. A function `proveOrDisprove` combines `solve` and `getProof` in case one wants to directly obtain a proof.

This code has not been tested for performance. Further this is my first serious work with lean, i.e., beyond following along some tutorials. Hence there is a lot of scope for improvement. Suggestions and comments are most welcome.
