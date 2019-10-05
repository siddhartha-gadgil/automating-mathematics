+++
title = "Computer Assisted Proofs"
date = 2019-10-03T21:14:02+05:30
draft = false
tags = []
categories = []
+++ 

_Formal verification_ is the computer assisted proving of results - ordinary mathematical theorems, as well as claims that pieces of hardware or software, network protocols, and mechanical and hybrid systems meet their specifications. Computers can assist both assistance in the  _discovery_ of proofs as well as _checking correctness_. Indeed computer assisted finding of proofs (so called _Automated Theorem Proving_) is crucial for formal verification of any complicated result or system, as supplying all details of the proof in such situations is unreasonably hard and/or tedious.

Formal verification offers an assurance of correctness far beyond and other form of testing. However, it is not easy to develop such proofs, so we have a trade-off between safety and productivity. In recent times, our _ability_ to develop such proofs has greatly increased (thus lowering the cost in terms of productivity), and the importance of the greater safety from proofs, especially in some domains, has greatly increased, leading to the increasing adoption of these.

### Who guards the guards?

If the system that checked our proofs is wrong, then we naturally cannot be sure of the correctness of the proofs. This issue is addressed by following the so called _trusted kernel_ principle - the correctness of the proof is separated into a _kernel_ which should not be too long, and this is verified independently by several people. An excellent implementation of this principle is with the _Lean theorem prover_ - the proofs are exported to an easy to read format, and there are three independent programs, written in three programming languages, that check proofs. Further all these checkers are open sourced and not very long.

## The necessity and value of proofs

Traditionally systems undergo various kinds of tests that ensure that they fail only very rarely. However, there are circumstances where even such rare failures are not acceptable.

* In safety critical systems, such as trains and hospital equipment, even an occasional failure is not acceptable. One example of the use of formal systems is in the driverless Paris metro trains.
* In hardware, even a small error is expensive and difficult to correct - for instance to correct a mistake in the design of a chip all systems with the chip installed have to be recalled. After one such instance (the Pentium floating point bug), __Intel__ has increasingly adopted formal verification in chip design.
* An error in software at the system level is a _vulnerability_ - even if a user is unlikely to ever come across this error, malware can deliberately target this to control a system or network.
* Mathematical results form vast edifices, and an error in a basic result means that all results using it, within mathematics or in applications of mathematics, could be wrong.

As systems become increasingly complex, and the mathematical and scientific literature grows, traditional ways of checking such as statistical testing and reviews by other people (including of human mathematical proofs or protocols of experiment) become increasingly inadequate in ensuring correctness.

Further, proofs not only establish correctness of results, but illuminate them. Specifically, the act of formally proving a result makes clear what assumptions go into this result, both clarifying its scope and potentially leading to further advances in knowledge.

## How to prove it

Many advances have come together to make formal verification feasible, with the additional effort of formally verifying a system not unreasonable.

* Starting with the pioneering work of Church and Turing, there have been many conceptual advances in the _foundations_ of mathematics and computation.
