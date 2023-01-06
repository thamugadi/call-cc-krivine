# call-cc-krivine

**Work in progress.**
  
A Krivine machine for the reduction of lambda calculus (with call/cc) expressions in Haskell.  
  
Usage: (note: only use parentheses to apply a term to a term.)  
```hs  
runghc Main.hs "(call/cc lambda x.(x 10))"  
```  
Output example:  
```  
(call/cc (λx.(x 10))) *** []
(λx.(x 10)) *** [continuation []]
10 *** []
```  
  
[In his paper](https://www.irif.fr/~krivine/articles/lazymach.pdf), Jean-Louis Krivine describes his machine for the reduction of lambda calculus expressions into head normal form using call-by-name reduction
  
The last chapter is about the addition of a call/cc instruction (call-with-current-continuation).  
  
This program is based on a [compact representation of the Krivine machine](https://hal.inria.fr/hal-01479035/document) to which I added the transition for continuation.  
    
``t ⋆ π`` describes a state, where ``t`` is a term and ``π`` is a stack of terms. Pushing ``u`` on  ``π`` is written ``u :: π``.  
  
To implement ``call/cc``, we allow ourselves to have a term that carries a stack in the form ``continuation π``.  



*Before*                        |*After*|  
|-                              |-  
|``t s ⋆ π``                    | ``t ⋆ s :: π`` 
|``λx.t ⋆ s :: π``            | ``t[x := s] ⋆ π``   
|``call/cc f ⋆ π``              |``f ⋆ continuation π :: π``
| ``continuation π₁ ⋆ s :: π₂`` | ``s ⋆ π₁``
