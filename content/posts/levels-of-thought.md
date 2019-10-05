+++
title = "Levels of Thought"
date = 2018-08-06T15:55:56+05:30
draft = false
tags = []
categories = []
+++

Computers excel at routine tasks and are capable of performing these with great precision and speed. Indeed one can even argue that the more routine a task is, the more the _comparative_ advantage of a computer in performing this task, and so people have a _comparative_ advantage in more sophisticated tasks. Yet it would be a fallacy to conclude from this that people are better at high-level tasks than computers.

It is true that as computers can perform many more steps accurately and rapidly, the easiest way to get a computer to solve a problem is often using a lower level of thinking than for a person to solve the same problem, i.e., trade _brute force_ for sophistication.

However, the major waves in automation have come from computers being able to handle tasks at successively higher cognitive levels. This is masked to some extent by the ability of computers to substitute a higher level of cognition with raw power at a lower level - but this has its limitations. Indeed we shall illustrate that in the present era (starting with about 2008), computers have exhibited all forms of high-level cognition.

# Levels by "how?"

### Arithmetic and Logic

A pocket calculator can perform basic arithmetic operations. Arithmetic operations require also

* __logic__ - while subtracting `m` from `n`, _if_ a digit of `m` is larger than the corresponding one for `n` we subtract.
* __loops__ - once we know the basic method, we can apply it _for_ each digit of a number to add/subtract arbitrarily long numbers. Further, while multiplying arbitrary numbers `m` and `n`, we have one term for each digit of `n`, with each term involving multiplying that digit with each digit of `m`. In doing these, we have used _nested loops_.

It does not need any more sophistication to handle instead lists of numbers, lists of lists of numbers (matrices), list of letters (words) etc. Indeed all computation can in principle be reduced to this level. Doing this would be the most extreme version of brute force.

### Breaking tasks into simpler ones: procedures and functions

A core of thinking is to break up a task into its constituents. For instance, in solving a quadratic equation we perform several arithmetic operations. But we do not think of the description of the solution as _including_ descriptions of adding and multiplying numbers. Instead we _refer_ to descriptions of these more basic operations, which we have learnt elsewhere. When using the function, we pass _arguments_ - such as numbers to subtract.

_Functions_ (and _procedures_) in programming languages play this role. Indeed many general purpose programming languages, such as _Fortran_ and _Cobol_ do not go far beyond this level. This significantly limits their capabilities - for instance, there is no compiler for Fortran written in Fortran.

#### Why this is a higher level

It is worth considering, as a contrast, a so called _macro_ or _templating_ language. Such languages are often used in special situations, for instances to add some smart shortcuts for word processing software or spreadsheets, or in templates for a web site.

In a macro language, we can describe the basic arithmetic operations and then describe the solution of a quadratic equation in terms of these, using logic and loops). However, when processing this, the interpreter copy-pastes the description of, say, addition, whenever an addition is used in solving a quadratic equation. This means the program can be resolved to one at the lower level. Evidently this works, but is much less efficient and becomes increasingly harder (and less pleasant) to use as we try to encode more sophisticated tasks.

All level jumps involve this - we can do stuff at the lower level in principle, but at a cost that makes it impractical and unpleasant.

### Recursion, Higher order functions

Functions can be defined in terms of other (simpler) functions. _Recursive_ definitions define functions in terms of themselves, with _arguments_ being simpler, such as the factorial function `(n+1)! = (n+1)n!`. At a more sophisticated level, the arguments of a function can be a function itself.

### Building objects from constituents

Just as we can define functions by _decomposing_ into simpler functions, or functions called with _simpler_ arguments, we can build objects (or structures) from constituents. Indeed this capability is at the heart of natural languages - we can build arbitrarily complex sentences using rules such as combining an _adjectival phrase_ and a _noun phrase_ gives a _noun phrase_. Notice that this is rule is _recursive_.

Functions and structures built recursively give all the complexity needed in practice in the sense of architecture of thought, or of hardware and software. The advances in Aritificial intelligence have come not (mainly) from more complex software, but doing things differently.

# Levels by "what?"

Advances of machine learning, while involving many great ideas, are not due to doing things in a more sophisticated way, but rather by doing things differently. Indeed many of the key ideas date back to the 1980s, and some even to the 1950s. However for these to be effective needed powerful hardware. Ironically, sophisticated solutions needs more brute force than brute force solutions.

### Hard to solve, easy to check

We tend to call answers _clever_, or even _creative_, if we can see that they are correct but cannot see how they were found. Indeed puzzles (such as Sudoku) are typically of this nature.

Indeed we have an analagous situation even with subjective judgements - while it takes a certain sense of language and rhythm to enjoy a poem such as Poe's Raven, writing such a poem requires an entirely different level of thinking.

Computers have long been capable of solving many such problems very well. It is higher levels at which they failed.

### Tacit knowledge

As [wikipedia](https://en.wikipedia.org/wiki/Tacit_knowledge) defines it:
tacit knowledge (as opposed to formal, codified or explicit knowledge) is the kind of knowledge that is difficult to transfer to another person by means of writing
it down or verbalizing it.

This is encapsulated in the assertion "we can know more than we can tell" of Michael Polanyi. A typical example of such tacit knowledge is the ability to ride a bicycle. A top chess player has tacit knowledge of the strength of white in a game that is far better than the explicit rules that can be written down.

A fundamental weakness of computers till a decade ago was that they depended on being programmed to carry out explicitly understood solutions. This made them hopeless at many cognitive tasks. Systems based on _machine learning_ instead learn how to handle tasks with experience, which is also our source of tacit knowledge. The task of programming becomes one of explicitly specifying how to learn, not unlike teaching someone to bicycle.

### Intuitive ideas

We often make choices whose correctness depends on either things in the future or unknown. We can try to make these choices _logically_, where we explicitly consider as many possibilities for the future as is reasonable, and have a policy for dealing with what remains unknown. For example, we can consider a certain number of moves in chess, and consider the best outcome based on the results at the end of these moves. Traditional chess playing programs do this (and are also limited by using the inferior explicit function to judge the position at the end of these).

We often instead make choices that are not logical. Often these are in fact _illogical_, i.e., simply bad choices. But in many cases we do have strong _intuition_, so we make choices that turn out in the fullness of time to often be the correct ones.

In this sense, systems based on _deep learning_ do show _intuition_. The choices are based on a function that is some complicated that we cannot describe it in understandable terms. Further, if we simplify it to be easily describable, it does not work well.

### Judgement and Taste

Besides immediate applications, the value of a mathematical, or scientific, discovery lies in it leading to more (good) mathematics, and possibly future applications. A subtle skill, but essential at a high level, is to have the judgement or taste to recognise value before the consequences are evident. This is even more subtle than making choices based on intuition.

The systems _AlphaGo_ and _AlphaZero_ have shown refined judgement in evaluating positions in board games, with evaluation better than human champions.

### Organized knowledge

Our knowledge is organized based on meaning and use. For instance we perceive two words as similar based on their meanings more than their sounds. Further, a visual scene is perceived as composing of distinct objects, not as an array of pixels.

Using _representation learning_, computers can organize knowledge by meaning too. For instance, the `Word2Vec` system maps words to vectors in a high-dimensional space, by training using an artificial problem. We can see that this captures many properties of words, not just similarity but analogies.

### Analogical reasoning

Much of our reasoning is based on analogy, which comes more naturally to us than formal abstraction. Indeed ancient Babylonian and Indian mathematics was explained purely through analogy.

As we mentioned, systems based on representation learning capture analogy automatically. It seems likely that extensions of these that seek analogies will do even better.

### Efficient learning

In the first wave of machine learning, systems performed very well but needed a large amount of labelled data. This limited the tasks that could be learnt, and made training expensive. To overcome this, the idea of _reinforcement learning_ was introduced, where a system refined its learning through a large amount of simulation - not unlike a child learning through play.

A striking example of this is the best _Go_ player today, _AplhaGo Zero_ (the chinese game of _Go_ is the hardest board game for computers). This is a system that learnt entirely by playing against itself, starting with just the rules of the game, i.e., with zero data.
