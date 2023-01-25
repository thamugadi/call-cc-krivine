# call-cc-krivine

**Work in progress.**

**TODO: Better parser.**

A Krivine machine for the call-by-name reduction of lambda calculus (with call/cc & clock) expressions in Haskell.  
  
[In his paper](https://www.irif.fr/~krivine/articles/lazymach.pdf), Jean-Louis Krivine describes his machine for the reduction of lambda calculus expressions into head normal form using call-by-name reduction
  
The last chapter is about the addition of a call/cc instruction (call-with-current-continuation).  
  
This program is based on a [compact representation of the Krivine machine](https://hal.inria.fr/hal-01479035/document) to which I added the transition for continuation.  
    
``t ⋆ π`` describes a state, where ``t`` is a term and ``π`` is a stack of terms. Pushing ``u`` on  ``π`` is written ``u : π``. ``n`` is the number of instructions executed so far. 
  
To implement ``call/cc``, we allow ourselves to have a term that carries a stack in the form ``continuation π``.  

As for the ``clock`` instruction, it is an instruction [described in this paper](https://www.irif.fr/~krivine/articles/Lacombe.pdf) that gives the number of instructions executed since the boot. Krivine establishes that a typed version of it would imply the *Axiom of dependent choice*, just like how a typed ``call/cc`` would imply the *excluded middle*.

*Before* |*After*|
|- |-  
|``t s ⋆ π`` | ``t ⋆ s : π`` 
|``λx.t ⋆ s : π`` | ``t[x := s] ⋆ π`` 
|``call/cc ⋆ f : π`` |``f ⋆ continuation π : π`` 
| ``continuation π₁ ⋆ s : π₂`` | ``s ⋆ π₁`` 
| ``clock ⋆ s : π`` | ``s ⋆ n : π``


[A similar transition table for SKI combinators is described in this paper from Krivine.](https://www.irif.fr/~krivine/articles/Lacombe.pdf) (p. 5)


Examples: (note: only use parentheses to apply a term to a term.)

```  
runghc Main.hs "((call/cc \a.(a x)) y)"
```
```  
((call/cc λa.(a x)) y) *** []
(call/cc λa.(a x)) *** [y]
call/cc *** [λa.(a x), y]
λa.(a x) *** [continuation [Var "y"], y]
(continuation [Var "y"] x) *** [y]
continuation [Var "y"] *** [x, y]
x *** [y]
(x y) not evaluated.
```  

```
runghc Main.hs "(\f. (\x. (f (x x)) \x. (f (x x))) g)"
```

```
(λf.(λx.(f (x x)) λx.(f (x x))) g) *** []
λf.(λx.(f (x x)) λx.(f (x x))) *** [g]
(λx.(g (x x)) λx.(g (x x))) *** []
λx.(g (x x)) *** [λx.(g (x x))]
(g (λx.(g (x x)) λx.(g (x x)))) *** []
g *** [(λx.(g (x x)) λx.(g (x x)))]
(g (λx.(g (x x)) λx.(g (x x)))) not evaluated.
```

```
runghc Main.hs "(\x. (clock (clock x)) y)"
```
```
(λx.(clock (clock x)) y) *** []
λx.(clock (clock x)) *** [y]
(clock (clock y)) *** []
clock *** [(clock y)]
(clock y) *** [instr n°4]
clock *** [y, instr n°4]
y *** [instr n°6, instr n°4]
(y instr n°6 instr n°4) not evaluated.
```
