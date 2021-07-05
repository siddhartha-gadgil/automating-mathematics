+++
title = "Sat Solving"
date = 2021-05-18T08:53:42+05:30
draft = false
tags = []
categories = []
css = "sat.css"
+++

To better understand the `SAT` (i.e., _boolean satisfiability_) problem and `SAT` solvers, I decided to implement a basic one. I was pleasantly surprised that wikipedia has enough details to implement the so called __DPLL__ algorithm quite easily, with even some improvements described in wikipedia. Even better, in the case when there was no solution, the same algorithm gives a proof that there is no solution. The proof that there is no solution was based on _resolution_ due to Davis-Putnam &mdash; so the algorithm gives as a bonus a proof that resolution is refutation complete for propositional calculus.
<!--more-->

The code corresponding to this blog is in the `fol` project (and directory) of my [ProvingGround](https://github.com/siddhartha-gadgil/ProvingGround) repository.

## The `SAT` (Boolean satisfiability) problem

Suppose we are given finitely many variables `$P$`, `$Q$`, ... which are _boolean_, i.e. represent whether a statement is true or false, and finitely many relations among them. The relations are logical statements built from the variables using logical operators such as `$\neg$` (_not_), `$\vee$`(_or_), `$\wedge$`(_and_), `$\Rightarrow$`(_implies_) and `$\Leftrightarrow$` (_equivalent_). The  `SAT` (_boolean satisfiability_) problem  asks whether we can assign truth values to these (i.e., declare each of `$P$`, `$Q$` , ... to be `true` or `false`) so that all the relations are satisfied.

In the sequel, we shall use the standard logic terminology. Logical statements are called _Propositions_ (these can be either true or false, unlike the standard meaning of the word proposition in mathematics). Statements built from logical variables by logical operators are called _formulas_. All the variables we consider are boolean. Note that a boolean variable is itself a formula.

## CNF

If `$P$` is a (boolean) variable, the formulas `$P$` and `$\neg P$` are called _literals_. A _clause_ is a formula of the form `$l_1\vee l_2\vee\dots\vee l_n$` with each `$l_i$` a literal. A formula in __CNF__ is a formula of the form `$C_1\wedge C_2\wedge\dots\wedge C_m$` such that each `$C_j$` is a clause. Observe that `$C_1\wedge C_2\wedge\dots\wedge C_m$` is satisfied if and only if all the formulas `$C_j$` are satisfied. Hence we can (and will) view a formula in `$CNF$` as a collection of clauses, all of which are required to be satisfied.

Any formula can be rewritten as a CNF formula to which it is equivalent. Namely, we first rewrite all instances of `$A\Rightarrow B$` as `$\neg B\vee A$` and all instances of `$A\Leftrightarrow B$` as `$(\neg A\wedge \neg B)\vee (A\wedge B)$` to eliminate operators other than `$\vee$`, `$\wedge$` and `$\neg$`. Next we use `$\neg(A \vee B) = \neg A \wedge \neg B$` and `$\neg(A \wedge B) = \neg A \vee \neg B$` recursively to rewrite the formula as combinations of literals using `$\vee$` and `$\wedge$` only. Finally, using the distributivity property `$A \vee (B\wedge C)= (A\vee B)\wedge (A \vee C)$` recursively we get a formula in CNF.

### Tautologies and Contradictions

Since `$l\vee l = l$`, we can assume that no literal appears more than once in a clause. Further, if a clause contains both `$P$` and `$\neg P$` for some variable `$P$`, then this clause is always true, i.e., is a _tautology_. We can drop such clauses. We henceforth assume both these simplifications have been made.

On the other hand, an empty clause can never be satisfied (as _some_ literal in the clause must be true for it to be satisfied). Thus, an empty clause is a _contradiction_, and we denote it by `$\bot$`. In particular, the formula in CNF has an empty clause, then it cannot be satisfied. This will rarely happen, but we shall see how to deduce new clauses in such a way as to get an empty clause for unsatisfiable formulas.

### Resolution

Given two clauses that are of the form `$C = P\vee l_1\vee l_2\vee \dots\vee l_n$` and `$C' = \neg P\vee l'_1\vee l'_2\vee \dots\vee l'_{n'}$` (after possibly reordering literals), we can deduce the clause `$l_1\vee l_2\vee \dots\vee l_n\vee l'_1\vee l'_2\vee \dots\vee l'_{n'}$`. Namely, if `$P$` is false then as `$C$` is true we must have `$l_1\vee l_2\vee \dots\vee l_n$`. On the other hand if `$P$` is true, as `$C'$` is true we must have `$l'_1\vee l'_2\vee \dots\vee l'_{n'}$`. Either way, `$l_1\vee l_2\vee \dots\vee l_n\vee l'_1\vee l'_2\vee \dots\vee l'_{n'}$` holds.

The clause `$l_1\vee l_2\vee \dots\vee l_n\vee l'_1\vee l'_2\vee \dots\vee l'_{n'}$` is said to be obtained by _resolution_ from `$C$` and `$C'$`. A theorem of Martin Davis and Hilary Putnam says that resolution is _refutation complete_ not just for `SAT` but in a more general context, namely first-order logic. This means that if a collection of clauses is not satisfiable, then we can deduce the empty clause by (repeated) resolution starting with the given clauses. Note that the final step will be resolving (singleton) clauses of the form `$P$` and `$\neg P$` to get the empty clause `$\bot$`.

The algorithm I implemented gives either a solution to a collection of clauses or a deduction using resolution of the empty clause `$\bot$`. Thus, we get in particular a proof that resolution is refutation complete in the context of `SAT`.

## An example: the N-Queens problem

Before we sketch our algorithm, we consider a class of examples &ndash; the N-Queens problem. This asks whether we can place `$N$` queens on an `$N\times N$` chessboard with no two queens attacking each other.

To formulate this in terms of `SAT`, we consider a collection of `$N^2$` boolean variables `QueenAt(i, j)` for `$0 \leq i, j < N$` representing whether a queen is present at the corresponding square on the grid (as is common with programs the indices begin at `$0$`). As is usual, instead of using (the clumsy) equation for their being (at least) `$N$` queens on the board, we use `$N$` equations saying that each row has a queen. We also have a bunch of equation for queens not attacking each other horizontally, vertically and along diagonals. These equations are generated (programmatically) as clauses.

### Solution to 8-Queens

The classical 8-Queens problem is solved instantly. A little scripting lets us display the solution in a table (using a unicode character for the queen).

|||||||||
|--- |--- |--- |--- |--- |--- |--- |--- |
||||♕|||||
||||||||♕|
|♕||||||||
|||♕||||||
||||||♕|||
||♕|||||||
|||||||♕||
|||||♕||||

### No solution for 3-Queens

On the other hand, the 3-Queens problem has no solutions. Indeed, our program gives a proof of this by deducing a contradiction using resolution, starting with the assumptions. A little scripting lets us write this solution as nested lists, with resolutions written in terms of the final clause being deduced from the given clauses. This gives a tree-like structure, with the root a contradiction and the leaves the given assumptions.

- *Contradiction* **from** (¬QueenAt(1,0)) **and** (QueenAt(1,0)),
    **using**
    - (¬QueenAt(1,0)) **from** (¬QueenAt(1,0) ∨ QueenAt(0,0)) **and**
        (¬QueenAt(0,0) ∨ ¬QueenAt(1,0)), **using**
        - (¬QueenAt(1,0) ∨ QueenAt(0,0)) **from** (¬QueenAt(1,0) ∨
            ¬QueenAt(0,2)) **and** (¬QueenAt(1,0) ∨ QueenAt(0,0) ∨
            QueenAt(0,2)), **using**
            - (¬QueenAt(1,0) ∨ ¬QueenAt(0,2)) **from** (¬QueenAt(1,0)
                ∨ QueenAt(2,2)) **and** (¬QueenAt(0,2) ∨ ¬QueenAt(2,2)),
                **using**
                - (¬QueenAt(1,0) ∨ QueenAt(2,2)) **from**
                    (¬QueenAt(2,1) ∨ ¬QueenAt(1,0)) **and**
                    (¬QueenAt(1,0) ∨ QueenAt(2,1) ∨ QueenAt(2,2)),
                    **using**
                    - (¬QueenAt(2,1) ∨ ¬QueenAt(1,0)) by assumption
                    - (¬QueenAt(1,0) ∨ QueenAt(2,1) ∨ QueenAt(2,2))
                        **from** (¬QueenAt(2,0) ∨ ¬QueenAt(1,0)) **and**
                        (QueenAt(2,1) ∨ QueenAt(2,2) ∨ QueenAt(2,0)),
                        **using**
                        - (¬QueenAt(2,0) ∨ ¬QueenAt(1,0)) by
                            assumption
                        - (QueenAt(2,1) ∨ QueenAt(2,2) ∨ QueenAt(2,0))
                            by assumption
                - (¬QueenAt(0,2) ∨ ¬QueenAt(2,2)) by assumption
            - (¬QueenAt(1,0) ∨ QueenAt(0,0) ∨ QueenAt(0,2)) **from**
                (¬QueenAt(0,1) ∨ ¬QueenAt(1,0)) **and** (QueenAt(0,0) ∨
                QueenAt(0,2) ∨ QueenAt(0,1)), **using**
                - (¬QueenAt(0,1) ∨ ¬QueenAt(1,0)) by assumption
                - (QueenAt(0,0) ∨ QueenAt(0,2) ∨ QueenAt(0,1)) by
                    assumption
        - (¬QueenAt(0,0) ∨ ¬QueenAt(1,0)) by assumption
    - (QueenAt(1,0)) **from** (QueenAt(1,0) ∨ QueenAt(2,1)) **and**
        (¬QueenAt(2,1) ∨ QueenAt(1,0)), **using**
        - (QueenAt(1,0) ∨ QueenAt(2,1)) **from** (QueenAt(1,2) ∨
            QueenAt(1,0) ∨ QueenAt(2,1)) **and** (¬QueenAt(1,2) ∨
            QueenAt(2,1)), **using**
            - (QueenAt(1,2) ∨ QueenAt(1,0) ∨ QueenAt(2,1)) **from**
                (QueenAt(1,2) ∨ QueenAt(1,0) ∨ ¬QueenAt(2,0)) **and**
                (QueenAt(1,2) ∨ QueenAt(1,0) ∨ QueenAt(2,0) ∨
                QueenAt(2,1)), **using**
                - (QueenAt(1,2) ∨ QueenAt(1,0) ∨ ¬QueenAt(2,0))
                    **from** (QueenAt(1,1) ∨ QueenAt(1,2) ∨
                    QueenAt(1,0)) **and** (¬QueenAt(2,0) ∨
                    ¬QueenAt(1,1)), **using**
                    - (QueenAt(1,1) ∨ QueenAt(1,2) ∨ QueenAt(1,0)) by
                        assumption
                    - (¬QueenAt(2,0) ∨ ¬QueenAt(1,1)) by assumption
                - (QueenAt(1,2) ∨ QueenAt(1,0) ∨ QueenAt(2,0) ∨
                    QueenAt(2,1)) **from** (QueenAt(1,2) ∨ QueenAt(1,0)
                    ∨ ¬QueenAt(2,2)) **and** (QueenAt(2,0) ∨
                    QueenAt(2,2) ∨ QueenAt(2,1)), **using**
                    - (QueenAt(1,2) ∨ QueenAt(1,0) ∨ ¬QueenAt(2,2))
                        **from** (QueenAt(1,1) ∨ QueenAt(1,2) ∨
                        QueenAt(1,0)) **and** (¬QueenAt(2,2) ∨
                        ¬QueenAt(1,1)), **using**
                        - (QueenAt(1,1) ∨ QueenAt(1,2) ∨ QueenAt(1,0))
                            by assumption
                        - (¬QueenAt(2,2) ∨ ¬QueenAt(1,1)) by
                            assumption
                    - (QueenAt(2,0) ∨ QueenAt(2,2) ∨ QueenAt(2,1)) by
                        assumption
            - (¬QueenAt(1,2) ∨ QueenAt(2,1)) **from** (¬QueenAt(1,2) ∨
                QueenAt(2,1) ∨ QueenAt(0,1)) **and** (¬QueenAt(0,1) ∨
                ¬QueenAt(1,2)), **using**
                - (¬QueenAt(1,2) ∨ QueenAt(2,1) ∨ QueenAt(0,1))
                    **from** (¬QueenAt(1,2) ∨ QueenAt(2,1) ∨
                    ¬QueenAt(0,0)) **and** (¬QueenAt(1,2) ∨ QueenAt(0,0)
                    ∨ QueenAt(0,1)), **using**
                    - (¬QueenAt(1,2) ∨ QueenAt(2,1) ∨ ¬QueenAt(0,0))
                        **from** (¬QueenAt(1,2) ∨ QueenAt(2,0) ∨
                        QueenAt(2,1)) **and** (¬QueenAt(0,0) ∨
                        ¬QueenAt(2,0)), **using**
                        - (¬QueenAt(1,2) ∨ QueenAt(2,0) ∨
                            QueenAt(2,1)) **from** (¬QueenAt(2,2) ∨
                            ¬QueenAt(1,2)) **and** (QueenAt(2,0) ∨
                            QueenAt(2,2) ∨ QueenAt(2,1)), **using**
                            - (¬QueenAt(2,2) ∨ ¬QueenAt(1,2)) by
                                assumption
                            - (QueenAt(2,0) ∨ QueenAt(2,2) ∨
                                QueenAt(2,1)) by assumption
                        - (¬QueenAt(0,0) ∨ ¬QueenAt(2,0)) by
                            assumption
                    - (¬QueenAt(1,2) ∨ QueenAt(0,0) ∨ QueenAt(0,1))
                        **from** (¬QueenAt(0,2) ∨ ¬QueenAt(1,2)) **and**
                        (QueenAt(0,0) ∨ QueenAt(0,1) ∨ QueenAt(0,2)),
                        **using**
                        - (¬QueenAt(0,2) ∨ ¬QueenAt(1,2)) by
                            assumption
                        - (QueenAt(0,0) ∨ QueenAt(0,1) ∨ QueenAt(0,2))
                            by assumption
                - (¬QueenAt(0,1) ∨ ¬QueenAt(1,2)) by assumption
        - (¬QueenAt(2,1) ∨ QueenAt(1,0)) **from** (¬QueenAt(2,1) ∨
            QueenAt(1,1) ∨ QueenAt(1,0)) **and** (¬QueenAt(1,1) ∨
            ¬QueenAt(2,1)), **using**
            - (¬QueenAt(2,1) ∨ QueenAt(1,1) ∨ QueenAt(1,0)) **from**
                (¬QueenAt(1,2) ∨ ¬QueenAt(2,1)) **and** (QueenAt(1,1) ∨
                QueenAt(1,2) ∨ QueenAt(1,0)), **using**
                - (¬QueenAt(1,2) ∨ ¬QueenAt(2,1)) by assumption
                - (QueenAt(1,1) ∨ QueenAt(1,2) ∨ QueenAt(1,0)) by
                    assumption
            - (¬QueenAt(1,1) ∨ ¬QueenAt(2,1)) by assumption

## Solving SAT

I now describe the algorithm I implemented to solve `SAT` for a collection of clauses, giving either an assignment of truth values that satisfies all the clauses or a contradiction using resolution starting with the given clauses. We shall see this in stages.

A `SAT` problem is specified by a finite set `$V$` of Boolean variables and a finite set `$E$` of clauses in these variables &mdash; we refer to this as _the `SAT` problem `$SAT(V, E)$`_. We also assume that `$E$` does not contain tautologies, and none of the clauses contain a literal more than once. We also regard clauses as equal if they become so after reordering.

### Recursive solving: the DP algorithm

Assume that we are given sets `$V$` and `$E$` as above. We pick a variable `$P\in V$` and look for solutions first when `$P$` is assigned the value true and then when it is assigned false (in my code I actually randomized the order of the branches). For solutions where `$P$` is true:

1. Any clause containing `$P$` is true, so can be dropped.
2. Any clause of the form `$\neg P\vee l_1\vee\dots\vee l_n$` (up to reordering) is true if and only the clause `$C =l_1\vee\dots\vee l_n$` obtained by dropping `$\neg P$` is true. We can thus replace `$\neg P \vee C := \neg P\vee l_1\vee\dots\vee l_n$` by `$C$` when considering solutions with `$P$` true.
3. Finally, clauses `$C$` containing neither `$P$` nor `$\neg P$` are unaffected, and should be satisfied even after assigning `$P$`.

Thus, we get a new set of clauses, which we denote `$\rho(E, P)$`, in the variables `$V\setminus\{P\}$`, giving the _restricted_ `SAT` problem `$SAT(V\setminus\{P\}, \rho(E, P))$`.
If the restricted problem has a solution then we get a solution to the original problem `$SAT(V, E)$` by assigning true to `$P$`. Otherwise we look for a solution where `$P$` is false, once more obtaining a restricted `SAT` problem `$SAT(V\setminus\{P\}, \rho(E, \neg P))$` with fewer variables (with `$\rho(E, \neg P))$` defined analogous to `$\rho(E, P))$`). If the latter problem has a solution so does the original one `$SAT(V, E)$`. If not, we know both the restricted problems have no solutions. Since `$P$` must be true or false, the original problem `$SAT(V, E)$` has no solution.

Thus, we can reduce the solution of a `SAT` problem to the solution of `SAT` problems with fewer variables. This gives a recursive algorithm once we solve in the base case, which is the case with no variables. But in this case the only clause is the empty clause. Thus there are only two `SAT` problems.

- `$E = \phi$`. Here every clause is satisfied, so there is a solution.
- `$E = \{\bot\}$`, i.e., a singleton consisting of the empty clause. This is not satisfiable as the empty clause cannot be satisfied.

To summarize, we have a recursive algorithm by reducing to a simpler case, namely with fewer variables, in case the set of variables is non-empty, and (easily) solving in the case where the set of variables is empty.

### DPLL algorithm

There are two ways in which the DP algorithm can be improved, giving the DPLL algorithm. Firstly, if some clause is a _unit literal_, i.e., a literal `$l$` with `$l = P$` or `$l = \neg P$`, then `$P$` must be assigned the value that makes `$l$` true. On doing this, all clauses containing `$l$` are true and can be dropped, while a clause of the form `$\neg l\vee C$` can be replaced by the clause `$C$` obtained by deleting `$\neg l$`, i.e., we replace `$E$` by `$\rho(E, l)$`. On making such simplifications, new units may be created and this process repeated. For instance, if each clause has length 2 (so called `2-SAT`), this clearly gives a fast algorithm.

A second improvement is to use _pure literals_, which are literals `$l$` so that `$\neg l$` is not present in any clause. Then the `SAT` problem has a solution if and only if it has a solution with `$l$` true. Hence we can assign the value of the variable `$P$` with `$l = P$` or `$l = \neg P$` to make `$l$` true, and drop all the clauses containing `$l$`.

I have implemented this without further heuristics, except for some use of a _conflict driven_ approach to avoid full back-tracking, based on
keeping track of proofs. I next sketch how we keep track of proofs (the algorithmic improvement will be evident).

### Lifting proofs

Suppose the given `SAT` problem `$SAT(V, E)$` has no solution. We can enhance our algorithm to in this case give a proof using resolution of a contradiction starting with the given clauses `$E$`. I sketch this here. The main step is the _lifting_ of a proof from a restricted problem. We shall denote the set of clauses deduced by resolution from a set of clauses `$E$` by `$D(E)$`. Thus, `$D(E)\supset E$`, and is the smallest set containing `$E$` that is closed under resolution.

To start with consider the base case where there is no variable. Here if the `SAT` problem is not satisfiable, we must have the empty clause in `$E$`. Thus a given clause is itself a contradiction.

Now consider the general case with `$n$` variables, and assume that our algorithm gives either a solution or deduces a contradiction using resolution whenever we have fewer than `$n$` variables. Pick a variable `$P$` and assign that `$P$` is true. As above, we get a restricted problem `$SAT(V\setminus\{P\}, \rho(E, P))$` not involving the variable `$P$`.

Suppose the original problem `$SAT(V, E)$` has no solution, then the restricted problem `$SAT(V\setminus\{P\}, \rho(E, P))$` does not either. By the induction hypothesis, using resolution we can deduce a contradiction starting with  `$\rho(E, P)$`, i.e., we have `$\bot\in  D(\rho(E, P))$`.
We cannot in general conclude from this that `$\bot\in D(E)$`. Nevertheless we can lift the proof of a contradiction to something useful.

Observe that, by the construction of `$\rho(E, P)$`, if `$C \in \rho(E, P)$` then either `$C \in E$` or `$\neg P\vee C\in E$` (if both hold we choose the first case in the sequel for efficiency). We claim that an analogous statement holds for clauses deduced by resolution. Namely, if `$C \in D(\rho(E, P))$` then either `$C \in D(E)$` or `$\neg P\vee C\in D(E)$`.

This claim can be proved by induction on the number of steps in the deduction using resolution. For the case with `$0$` steps, we just get elements of `$\rho(E, P)$`, for which we have the claim by the above observations as `$E\subset D(E)$`.

Next, if `$C \in D(\rho(E, P))$` is deduced in `$n > 0$` steps, then `$C$` can be deduced from clauses `$C_1$` and `$C_2$` by resolution, and the clauses `$C_i$` can be deduced from `$\rho(E, p)$` in fewer than `$n$` steps.

By induction hypothesis, it follows that, for each `$i =1, 2$`, either `$C_i \in D(E)$` or `$\neg P\vee C_i\in D(E)$`. By definition of resolution, if both `$C_1$` and `$C_2$` are in `$D(E)$` then `$C\in D(E)$`, and in all other cases `$\neg P\vee C\in D(E)$`.

As `$\bot \in D(\rho(E, P))$`, it follows that either `$\bot\in D(E)$` or `$\neg P = \neg P\vee \bot \in D(E)$`.
If  `$\bot\in D(E)$`, we have proved unsatifiability. Otherwise we apply the same algorithm to the restricted problem `$SAT(V \setminus \{P\}, \rho(E, \neg P))$` obtained by assigning the value false to `$P$`. In this case we deduce either `$\bot\in D(E)$` or that `$P\in D(E)$`. Thus, we either have a proof of unsatisfiability or both `$P\in D(E)$` and `$\neg P\in D(E)$` hold. But resolution using `$P$` and `$\neg P$` gives `$\bot$`, showing that `$\bot\in D(E)$`.

The above has been sketched as an existence result, but indeed all steps are effective, algorithmically giving a proof in the case of problems that are not satisfiable. Note that by checking if the contradiction requires the assumption of the truth value of `$P$` while lifting, we have also avoided full back-tracking in some cases.

## Looking ahead: formal programs and proofs

Using languages implementing _Dependent Type Theory_ such as `Lean 4` or `Idris`, one can hope for more &mdash; a program that outputs one of the following:

- a solution together with a proof that this is a solution, or
- a proof that there is no solution &mdash; not just a resolution tree but a proof in the given foundations.

Furthermore, the compiler should be able to verify that the program terminates for any valid input, and has correct output of one of the above forms. It appears that there is no obstruction in principle to doing this, but some work is needed.
