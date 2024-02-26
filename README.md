# call-cc-krivine

**Work in progress.**

[A web version, compiled with the GHC 9.6 Javascript build, is available here](https://aramya.neocities.org/)

A Krivine machine for the call-by-name reduction of lambda calculus (with call/cc & clock) expressions in Haskell.  
    
``t ⋆ π`` describes a state, where ``t`` is a term and ``π`` is a stack of terms. Pushing ``u`` on  ``π`` is written ``u : π``. ``n`` is the number of instructions executed so far. 
  
To implement ``call/cc``, we allow ourselves to have a term that carries a stack in the form ``continuation π``.  

*Before* |*After*|
|- |-  
|``t s ⋆ π`` | ``t ⋆ s : π`` 
|``λx.t ⋆ s : π`` | ``t[x := s] ⋆ π`` 
|``call/cc ⋆ f : π`` |``f ⋆ continuation π : π`` 
| ``continuation π₁ ⋆ s : π₂`` | ``s ⋆ π₁`` 
| ``clock ⋆ s : π`` | ``s ⋆ n : π``
