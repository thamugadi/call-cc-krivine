# call-cc-krivine

**Work in progress.**

**TODO: Better parser.**

A Krivine machine for the call-by-name reduction of lambda calculus (with call/cc) expressions in Haskell.  
  
Examples: (note: only use parentheses to apply a term to a term.)  

```hs  
runghc Main.hs "(call/cc \f.(f 10))"  
```  
```  
(call/cc λf.(f 10)) *** []
λf.(f 10) *** [continuation []]
10 *** []
```  

```
runghc Main.hs "(\f. (\x. (f (x x)) \x. (f (x x))) g)"
```

```
(λf.(λx.(f (x x)) λx.(f (x x))) g) *** []
λf.(λx.(f (x x)) λx.(f (x x))) *** [g]
g *** [(λx.(g (x x)) λx.(g (x x)))]
(g (λx.(g (x x)) λx.(g (x x)))) not evaluated.
```

[In his paper](https://www.irif.fr/~krivine/articles/lazymach.pdf), Jean-Louis Krivine describes his machine for the reduction of lambda calculus expressions into head normal form using call-by-name reduction
  
The last chapter is about the addition of a call/cc instruction (call-with-current-continuation).  
  
This program is based on a [compact representation of the Krivine machine](https://hal.inria.fr/hal-01479035/document) to which I added the transition for continuation.  
    
``t ⋆ π`` describes a state, where ``t`` is a term and ``π`` is a stack of terms. Pushing ``u`` on  ``π`` is written ``u : π``.  
  
To implement ``call/cc``, we allow ourselves to have a term that carries a stack in the form ``continuation π``.  


*Before* |*After*|
|- |-  
|``t s ⋆ π`` | ``t ⋆ s : π`` 
|``λx.t ⋆ s : π`` | ``t[x := s] ⋆ π`` 
|``call/cc f ⋆ π`` |``f ⋆ continuation π : π`` 
| ``continuation π₁ ⋆ s : π₂`` | ``s ⋆ π₁`` 

