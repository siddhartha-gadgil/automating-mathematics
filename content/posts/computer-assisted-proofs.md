+++
title = "Computer Assisted Proofs"
date = 2019-10-03T21:14:02+05:30
draft = false
tags = []
categories = []
+++ 

_Formal verification_, a rapidly growing young field, is the _computer assisted proving_ of results - ordinary mathematical theorems, as well as claims that pieces of hardware or software, network protocols, and mechanical and hybrid systems meet their specifications. Computers can assist both in the  _discovery_ of proofs as well as _checking correctness_. Indeed computer assisted finding of proofs (so called _Automated Theorem Proving_) is crucial for formal verification of any complex result or system, as manually supplying all details of complex proofs can be hard and tedious.

Formal verification offers an assurance of correctness far beyond other forms of testing. However, it is not easy to develop such proofs, so we have to weigh the benefits of safety against the cost of the extra effort (and the consequent loss of productivity). In recent times, our _ability_ to develop such proofs has greatly increased (thus lowering the cost), and the importance of the greater safety from proofs, especially in some domains, has greatly increased. Together these make a compelling case for increasing use of formal verification.

### Who guards the guards?

If the system that checked our proofs is wrong, then we naturally cannot be sure of the correctness of the proofs, so on the face of it we are left with human verification of a piece of software (the formal proof system) instead of proofs. This issue is mitigated by following _trusted kernel_ principle - the _kernel_ is a separate program that checks the correctness of proofs. The kernel can be of moderate size (since it only needs to check, not find, proofs), and can be rigorously reviewed and tested. An excellent implementation of this principle is with the _Lean theorem prover_ - the proofs are exported to an easy to read format, and there are three independent programs, written in three different programming languages, that check proofs. Further all these proof-checkers are open sourced and of moderate size.

## The necessity and value of proofs

Traditionally systems undergo various kinds of tests that ensure that they fail only very rarely. However, there are circumstances where even such rare failures are not acceptable.

* In safety critical systems, such as trains and hospital equipment, even an occasional failure is not acceptable. Thus, one example of the use of formal systems is in the driverless Paris metro trains.
* In hardware, even a small error is expensive and difficult to correct - for instance to correct a mistake in the design of a chip a large number of systems have to be recalled. After one such instance (the Pentium floating point bug), _Intel_ has increasingly adopted formal verification in chip design.
* An error in software at the system level is a _vulnerability_ - even if a user is unlikely to ever come across this error, _malware_ can deliberately target this to attack and control a system or network.
* Mathematical results form vast edifices, and an error in a basic result means that all results using it (within mathematics or in applications of mathematics) could be wrong.

As systems become increasingly complex, and the mathematical and scientific literature grows, traditional ways of checking such as statistical testing and reviews by other people (including of human mathematical proofs) become increasingly inadequate in ensuring correctness.

Further, proofs not only establish correctness of results, but illuminate them. Specifically, the act of formally proving a result makes clear what assumptions go into this result, both clarifying its scope and potentially leading to further advances in knowledge.

## How to prove it

Many advances have come together to make formal verification feasible.

* Starting with the pioneering work of Church and Turing, there have been many conceptual advances in the _foundations_ of mathematics and computation. _Dependent Type Theory_ unifies foundations of mathematics and computation, and formal proofs in such foundations are much closer to the usual informal proofs of working mathematics.
* _Automated Theorem Provers_  have become much more powerful. This is partly due to conceptual and technical advances in automated theorem proving, but also because the hardware on which we run these has become much more powerful, as has software (such as satisfiability solvers) that is used by automated theorem provers.
* The _libraries_ of formalized proofs have grown much larger - these can be used while proving new results.

These advances work together - better provers make it easier to add to the libraries, which in turn strengthen provers. Further as each component grows stronger, it increases the value of the other components, and hence the resources invested in it.

## The road ahead

Many future advances will come from conceptual and technical advances in foundations and provers and growing libraries of formalized results. There are also approaches with great potential that have not yet been incorporated in a significant way.

* A major advance in foundations of mathematics is based on the discovery of deep connections of Type Theory with Algebraic Topology, leading to the field of _Homotopy Type Theory_. While this has many conceptual advantages over older forms of type theory, so far its practical use in formal verification is limited.
* There have been many remarkable advances in Artificial Intelligence - deep learning, reinforcement learning, natural language understanding etc. These have so far played a peripheral role in formal verification and automated theorem proving.

As formal verification grows in power, one can hope to use this in many other areas and to a much greater extent. For instance, people are working on formal verification of cryptographic protocols. There are also efforts to make formal verification practically useful in some areas of mathematics.

Yet, this is a young field with a small community working in it, so the potential for making significant contributions at this stage is high. And one can hope that the value of these contributions grows as automated theorem proving and formal verification become more widespread.
