+++
title = "Integrating AI with the Lean Prover: How and Why"
date = 2025-11-12T09:22:22Z
draft = true
tags = []
categories = []
+++

Generative AI is famous for being both powerful and unreliable, though more recently it has become more reliable even as it has grown in power. A natural way to attempt to overcome issues with its reliability are by using a *Formal Proof System* such as the *Lean Prover* to verify the correctness of outputs of AI. To use such an approach in a real world situation (say designing circuits) will involve building various *bridges* between these systems, and also human systems.

In this post, I discuss what is needed to integrate Generative AI with the Lean Prover for real world domains. Interestingly, much of the role of generative AI can also be played by humans, so all this is relevant for people using Lean or hybrid human-AI systems.

We will take as a running example *Chess Puzzles* (or *Chess Analysis*). This is purely for illustrative purposes, and with the disclaimer that my knowledge of Chess is superficial.

## Components of Solving Chess puzzles

Consider a chess puzzle of a common form: "White to play and mate in two moves". The solution may be attempted by a person or some form of generative AI. In practice a modern computer can solve these by brute force, but we will assume not too much brute force is used as our goal is to illustrate what to do beyond the range of brute force.

* The creative element in the solution is the moves that White makes, in particular often the first move.
* The moves have to be legal - while not really an issue for chess players this has to be verified for AI moves.
* We have to consider all responses of Black, and suggest moves in each of these cases.
* We must again verify that these are legal.
* As the problem is mate in two moves we must verify that we really have checkmates - this is a case where even a human may make an error.
* We also have to ensure that all cases are covered, i.e., all responses by Black.
* However, in practice considering many responses, which are obviously bad moves can be avoided:
  * Many moves will be of the nature where Black is not responding to the threat, say moving a piece away from the scene of action. The same move by white will work in all these cases.
  * Automation, without any intuition/creativity, may be able to show White winning in many cases (without an excess of bute force).

In this flow, Lean Prover can help in various ways.

* Firstly, verify that all moves made by White are legal.
* Verify all cases are considered, or split into cases so each case becomes a separate goal.
* If the puzzle is easy at some stage, perhaps in some case, solve it.
* The latter can be guided by specifying a tactic and even some hints.
* Once a solution is given in the non-trivial cases, complete the easy cases with automation.
  * This can be guided with a tactic and some hints.
  * In particular if the same move works for all remaining cases, then a tactic given that move as a hint can solve these.

In addition, there is another way in which the Lean Prover can help, which is very important in real-world situations though not as crucial with Chess puzzles. The solution given by an AI system or a person to a Chess puzzle may depend on something that is "well known", such as a Bishop and a King alone can never checkmate the opponent. While "well known", such results may not be proved in Lean, so Lean will not regard that the solution (say to the problem of achieving a draw) has been proved to be correct. However, we can prove to Lean that the solution is correct *assuming* some facts, and Lean will be able to tell us what facts were assumed in a solution. In a real-world situation, these may be, for example, empirically known or be human conventions or rules. It is of great value to know not just that some empirical facts were used to obtain results, but exactly which facts were used for what results.

## Building bridges

Lean does not know even the rules of Chess, and most likely does not know details of the domain for which we wish to use it. Some work is needed before Lean can be used, which we sketch below.

### Representing the Domain in Lean

Firstly, we must represent a Chess Board, pieces, legal moves, checkmates and the rules of chess in Lean. These can be represented by *structures*, *functions*, *terms*, *inductive types* etc.

A more complex domain may have more ingredients, requiring more sophisticated Lean code (such as typeclasses and monads).

It is crucial that this representation is correct. Making it open source and documenting it well is one way to try to ensure this. We will discuss other checks on this a bit later.

### Domain Specific Language (DSL)

Domains have their own specific notation. For instance, moves in chess can be denoted `e4`, `N×e5`, `Ba7+` etc, with conventions about how games are represented. It greatly helps users to be able to use such notation. Fortunately, Lean has easily extensible syntax, using which we can build a so called **Domain Specific Language** (DSL) within Lean, so valid Chess notation (enclosed in appropriate begin and end marks) becomes valid Lean notation.

In addition to being helpful to human users, as LLMs learn from examples, a DSL will be useful to LLMs as well.

### Theorems: Helpers and Tests

Once a domain is modelled, basic properties should be proved as theorems. General theorems are useful in proving specific results of interest. In addition, they prove to be a test of the definitions.

For instance, in analysing games it is useful to have a theorem that a Queen and King can always checkmate a King alone. On the other hand, a theorem saying that a Bishop stays on the same colour, but can reach all squares of that colour, is a check that the model of Bishop moves is correct.

As the main failure point given verification in Lean is an error in definitions - being different from intended or not correctly modelling the world, it is important to check definitions by building on them.

### Tactics

Lean provides automation for proving results in the form of *tactics*. Many of these are general and powerful enough to apply to any specific domain. Others can be enhanced by providing appropriate hints specific to the domain. For instance, the `simp` tactic simplifies using theorems and definitions that are annotated as simplification rules. When we prove theorems about a domain we should annotate some of them as appropriate.

In addition, we may wish to write tactics that are appropriate to the domain. For instance, in Chess if the goal is to show how White wins, we are helped by a tactic that splits the goal after a move by White based on the moves by Black, and tactics that try to prove that from a certain position White can win in at most `k` moves. We can have a tactic combining these that asks us only to explain in the non-trivial cases.

### Autoformalization

While one can work directly using the model in Lean, or more conveniently with a DSL for the domain, users are most comfortable using Natural Language, possibly with embedded notation. Data for training or prompting LLMs is also usually in Natural Language.

Autoformalization is the automatic translation of natural language to Lean code. Adding autoformalization to the system for using Lean in a domain will add significant value.

There are many systems/projects under development for Autoformalization to Lean. For a specific domain, we need the models to output in the specific Lean code or DSLs. To do this with a system for Autoformalization based on (leading) Foundation models, it should suffice to simply provide enough examples and some documentation in the prompt.

## What we get from Lean

Besides verification, there are many other ways in which Lean helps in working with complex domains, by humans and especially with AI assistance.

* **Organization**: A Lean formalization is cleanly structured. We can decompose a problem and ensure that we have not missed any cases.
* **Interactive Development**: As we build and check stuff, Lean let's us know what remains to be done.
* **External Results**: We may need to use results derived from experiment or incorporate human rules or conventions. Lean lets us keep track of exactly what we used, and specifically what results proves depended on what external ones.
