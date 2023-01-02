# stlc-call-cc-krivine

**Work in progress. TODO: Implementing type checking.**
  
A Krivine machine for the reduction of simply typed lambda calculus (with call/cc) expressions in Haskell.  
  
Usage: (note: only use parentheses to apply a term to a term.)  
```hs  
runghc Main.hs "(call/cc lambda x:a->b->a.(x 10))"  
```  
Output example:  
```  
(call/cc (λx:(a→(b→a)).(x 10))) *** []  
(λx:(a→(b→a)).(x 10)) *** [continuation []]  
10 *** []  
```  
  
[In his paper](https://www.irif.fr/~krivine/articles/lazymach.pdf), Jean-Louis Krivine describes his machine for the reduction of lambda calculus expressions into head normal form using call-by-name reduction
  
The last chapter is about the addition of a call/cc instruction (call-with-current-continuation).  
  
By implementing a control instruction and a simple type system, we have equivalence with classical propositional logic (Curry-Howard correspondence).  
  
This program is based on a [compact representation of the Krivine machine](https://hal.inria.fr/hal-01479035/document) to which I added the transition for continuation.  
    
``t ⋆ π`` describes a state, where ``t`` is a term and ``π`` is a stack of terms. Pushing ``u`` on  ``π`` is written ``u :: π``.  
  
To implement ``call/cc``, we allow ourselves to have a term that carries a stack in the form ``continuation π``.  



*Before*                        |*After*|  
|-                              |-  
|``t s ⋆ π``                    | ``t ⋆ s :: π`` 
|``λx:τ.t ⋆ s :: π``            | ``t[x := s] ⋆ π``   
|``call/cc f ⋆ π``              |``f ⋆ continuation π :: π``
| ``continuation π₁ ⋆ s :: π₂`` | ``s ⋆ π₁``
