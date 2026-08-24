+++
title = "Complex Structures on the 6-sphere (via AI?)"
date = 2026-08-24T09:49:52+05:30
draft = true
tags = []
categories = []
+++

Early this morning I read an announcement of a result by an AI system (Claude, skilfully steered by Levent Alpoge) had answered a question that I have personally regarded as a central problem in mathematics for decades --- whether $S^6$ has a complex structure. I do not know whether the proof is correct, and the nature of the answer makes this less than a *field creating* result. Nevertheless, this will be a spectacular result, and is in any case a good excuse to give a high-level view of a large part of mathematics.

For clarity of exposition, I will assume a reasonable familiarity with mathematics --- for instance, knowing what a manifold is. Hopefully those with less of a background will get some impressionistic ideas from the post.

## Spaces and Structures

A lot of mathematics, including Geometry and Topology, involve studying spaces equipped with structures. A structure is *weaker* than another if, given an instance of the stronger structure, we automatically get a unique instance of the weaker structure. A fundamental class of questions is when we can go in the other direction --- whether any instance of the weaker structure comes from a unique instance of the stronger one. If so the two structures become equivalent.

The weakest structure I will consider in this post is that of a *topological manifold* --- which I will always assume to be compact and without boundary. A stronger structure is that of a smooth manifold. The strongest I will consider is a *smooth projective variety* --- a space defined by a "nice" collection of polynomial equations over complex numbers.

A smooth projective variety automatically has both the structure of a complex manifold and of a Riemannian manifold, and these are compatible with each other. Further, we also have a so-called *symplectic structure*.
Requiring only the Complex and Riemannian structures with appropriate compatibility gives the structure of a Kahler manifold. Kahler manifolds also have associated symplectic structures.

Our zoo of structures so far thus has *smooth projective varities* as the strongest, *kahler manifolds* as a weakening, *complex manifolds* and *symplectic manifolds* as structures weaker than *kahler manifolds*, *smooth manifolds* weaker than both these and finally *topological manifolds* as the weakest of all.

A common weakening of *complex manifolds* and *symplectic manifolds* is that of a smooth manifold with an *almost complex structure*. This is a complex structure on each tangent space that varies smoothly. This is a **soft** structure in the sense that it can be fully understood in terms of algebraic topology. This means that if another structure is equivalent to it, it too can be fully understood. Complex structures are often called an *integrable complex structures* to disambiguate from *almost complex structures*.

## Structure Strengthening Results: Proofs, Disproofs, Examples

To prove that a weaker structure is not equivalent to a stronger one, we need to:

* Prove some property implied by the stronger structure.
* Construct an example that has the weaker property but not the stronger one.

In different cases, either or both of these steps could be the hard one. Such a result is typically *field creating* --- the properties discovered fuel the study of the new structure.

On the other hand, if we wish to prove that a weaker structure always comes from a stronger one, we should construct the stronger structure from the weaker one. The construction may be abstract or concrete. Such a result is often *field finishing/collapsing*, merging the study of the two structures (and sometimes making a range of questions trivial).

### Capturing Ignorance

If we cannot prove or disprove that a weaker structure is equivalent to a stronger one, it becomes useful to capture the limits of our techniques in a specific example that has the weaker structure but may or may not have the stronger structure.

We can then look for consequences of having a stronger structure to rule out our candidate example. Finding this will settle the question in the negative. This will be a field creating result.

We can also seek to construct the stronger structure on our example. If our example has resisted such efforts before yielding, it is likely that we have found a fruitful new construction that generalises. New understanding will result and we can refine what we expect to hold for stronger structures based on our new examples.

### History

Milnor showed in the 1950s that topological manifolds do not have unique smooth structures, and Kervaire showed they need not exist at around the same time. Hopf showed in the 1940s that there are *complex manifolds* that are not *kahler* (and asked if $S^6$ has a complex structure). That there are smooth projective varities that are not *kahler* is more classical, but the gap was fully understood by Kodaira in the 1950s. Thurston showed that there are symplectic manifolds that are not *kahler*. Gromov created the field of Symplectic Topology showing many properties of symplectic manifolds. It readily followed from Gromov's work that neither existence nor uniqueness of symplectic structures given almost-complex structures is true. In dimension $4$ (complex dimension $2$), the Kodaira-Enriques classification of surfaces gave techniques to show the absence of integrable complex structures on some manifolds with complex structures, thus showing that almost complex structures are strictly weaker than integrable complex structures.

All these are landmark results in mathematics, and cover most of the *structure strengthening* questions. Notable questions not answered by these are the uniqueness of smooth structures on $S^4$ and whether every almost complex structure in dimension $6$ and above is equivalent to a (unique) complex structure, plus a handful of other questions.

### What just happened (perhaps)

Thus, the broader question addressed in the recent AI generated work is (at least in my view) undoubtedly a central question in mathematics. If the result had showed that $S^6$ does not have a complex structure, this would be a truly landmark result, at the level we see once every few years in mathematics.

What was actually shown was that $S^6$ does have a complex structure. As this has long been regarded as the *ignorance capturing* example (and which has remained open for decades), if the result is correct it is truly spectacular and knowledge about integrable complex structures has undoubtedly advanced.

Once we have such an example, the techniques to construct it are likely to generalise. It is likely that the construction will be abstracted, criteria that allow it to work will be found, and more spaces will have complex structures constructed on them. The central question is how far this will go.

An example from history shows that sometimes abstraction and generalisation can go very far. At one stage, Thurston believed that knot complements cannot have hyperbolic structures. Then a special algebraic construction was found in one case -- the figure-eight knot complement. Understanding and reverse-engineering this lead to Thurston's geometrisation for fibred knots and eventually the Thurston-Perelman Geometrisation Theorem.
