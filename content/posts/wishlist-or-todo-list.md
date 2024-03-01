+++
title = "Wishlist/ToDo List"
date = 2024-03-01T07:56:06+05:30
draft = true
tags = []
categories = []
+++

There is a bunch of topics related to the **Lean Theorem Prover** and **Artificial Intelligence for Mathematics** that I hope I will work on someday (i.e., *ToDo list*) and I would also be happy if somebody does them (i.e., my *Wishlist*). Naturally I will be happy to collaborate on any of these topics.

While I discuss specific themes below, any mathematics that is not already formalized in Lean is worth formalizing. The more basic and/or important the Mathematics, the more important it is to formalize it. While most of undergraduate mathematics has been formalized, there are large gaps in the formalization of beginning graduate level mathematics. Another attractive class of results to formalize are *real time formalizations*, i.e., formalization of important and recent results.

Further, while a lot of theorems have been formalized in Lean, relatively basic *algorithms* have not been. Here one would want the algorithms to be proved to be correct. In case these are decision procedures they should be encoded as instances of the `Decide` Typeclass, allowing them to be used in proofs and combined efficiently.

I now get to my current list, or at least that part of it that I recall now. The following topics range in difficulty from those needing weeks of work to those needing years of work. In a couple of cases I am actively working on them.

### FunSearch in Lean: Implement, Experiment.

In [FunSeach](https://www.nature.com/articles/s41586-023-06924-6) from Google-Deepmind, a language model was used in an evolutionary algorithm to find programs that generated interesting mathematical objects. This gave an improved result for a case of the *CapSet problem* among other things. The evolutionary algorithm used a language model to combine and mutate code for a function.

This method is very general, and has great potential for extension especially when using Lean. For instance, we can seek functions along with proofs of their properties. 

I have a basic implementation of this in Lean in the [LeanFunSearch](https://github.com/siddhartha-gadgil/LeanFunSearch) repository. This has not been tested at the time of writing.

### Symbolic integration using in-context learning.

This is an attempt to replicate and embed in Lean some of the work of Lample-Charton on [Symbolic Integration](https://arxiv.org/abs/1912.01412) using language models. Their approach is to 

* Generate synthetic data by:
  * Using the inverse relation between differentiation and integration to generate integrals from derivatives.
  * Using integration by parts to generate integrals from other integrals.
* Train a language model on this data.

My hope is to generate such data in Lean. Rather than train a language model, I would like to experiment with using the data for *in-context learning* for a foundation model. All this is for *elementary functions*, i.e., those built from polynomials, `sin`, `cos`, `exp` and `log` using algebraic operations and compositions.

I have started a repository, [Leantegration](https://github.com/siddhartha-gadgil/Leantegration), for this. One step needed is to show equality of elementary functions. Fortunately, it turns out that `aesop` and `ring` tactics can handle fairly complicated cases. Examples of this are all that are implemented at the time of writing.

### "Deduction Engine" of AlphaGeometry in Lean.

[AlphaGeometry](https://www.nature.com/articles/s41586-023-06747-5) is a system from Google-Deepmind that can solve geometry problems, reaching close to an IMO gold medallist level. 

AlphaGeometry works with a representation of geometric figures given by a finite set of points and some relations involving these. The relations typically involve lines/circles through these points. For example, four of the points may be `A`, `B`, `C` and `D` and we have the relation `perp A B C D` saying that the line through `A` and `B` is perpendicular to the line through `C` and `D`.

There are two main components to AlphaGeometry: a *deduction engine* and a *language model* suggesting auxiliary constructions. The deduction engine is a set of rules for deducing new relations from given ones using given rules of deduction. The rules of deduction are axioms or theorems in Euclidean geometry. The deduction engine is based on a *Deduction Database* and efficient working with *Algebraic Relations* between angles, lengths and ratios. The deduction engine does not introduce new points, but only deduces new relations between given points.

If a proof involves introducing new points, then the language model is used to suggest these. More specifically, the language model suggests one among a set of possible auxiliary constructions. Each of these involve adding one or more points and relations involving these.

My goal is to implement the deduction engine in Lean. This will mean representing the relations (as a *Typeclass*) and proving the rules of deduction. Further, one has to prove that the constructions exist, in the sense that points can be added satisfying the given relations. Thus, about a 100 theorems of Euclidean geometry will have to be proved, though some may already have been done by others.

### Lemma suggestions from language models.

A key *intuitive* step in proving a theorem is to find the right lemmas. This is often the most difficult part of a proof. One can hope that language models can help in suggesting lemmas. This can be done either in the context of formal proofs in Lean or informal proofs in natural language. Autoformalization can bridge between these.

The repository [LeanAide](https://github.com/siddhartha-gadgil/LeanAide) includes code to extract data on Lemmas used in Mathlib. The data can be used to train a language model to suggest lemmas.

### Counterexamples and Exists instantiations from LLMs.

Besides suggesting lemmas, language models can be used to suggest candidate counterexamples. Similarly, for a proof of a theorem of the form `∃ x, P x`, a language model can suggest a candidate for `x`. Similarly, we may apply a theorem (say the Mean Value Theorem) to a specific term (function for the MVT) which is non-trivial to find. An LLM can suggest such terms.

Considerations similar to predicting lemmas apply here. Again, the repository [LeanAide](https://github.com/siddhartha-gadgil/LeanAide) includes code to extract relevant data.

### Widgets mapping between pictures and symbolic representations.

In many areas of mathematics, it is far nicer and more powerful to work with pictures than with symbolic representations. The pictures also contain abstractions, for instance *$n$-twists in a knot*. The widget framework in Lean can be used to create interactive pictures. These can use arbitrary javascript.

It would be very useful to have a library of such widgets for a range of pictures in topology. These include:

* Knots and links.
* Curves on surfaces.
* Kirby diagrams and other representations of Manifolds.

Indeed there are already nice javascript libraries for these. These must be integrated with Lean.

### GAP system embedded in Lean.

Symbolic algebra systems are very powerful. However, they do not give a guarantee of correctness. Such a guarantee can either be given by proving an algorithm correct or post facto by proving the result correct.

Given the power of Lean 4 to have domain specific languages, one would like to embed a symbolic algebra system in Lean. The GAP system is a good candidate for this. It is a self-contained language, is open source, and has a very powerful set of algorithms for group theory. 

As GAP is stateful the embedding will have to involve a Monad, say `GapM`. This should come with a `run` function that allows one to run a `GapM` computation and get the result in Lean. The interpreter mode can be replaced by the InfoView in Lean.

### Free Groups, Combinatorial/Geometric Group Theory.

In many ways, Combinatorial and Geometric group theory, especially related to the free group, is a particularly good area for formalization. This is because the objects are very concrete and the proofs are often combinatorial. However, the proofs are non-trivial and deep. Further, this is an active area of research. Specifically, basic questions regarding `$Out(F_n)$`, free-by-cyclic groups, complex of splittings of free groups etc are open. 

Computer assisted mathematics must involve a computer assisting in some actual mathematics of interest. This is a good area for this especially for me, because of the above and as I have worked on related stuff and enjoy this area of mathematics.