module Krivine where
import Lambda

krivine1 :: (Term, [Term], Integer) -> (Term, [Term], Integer)

--krivine1 (App CC f, stack, n)  = (f, (Cont stack):stack, n+1)
krivine1 (CC, (f:stack), n) = (f, (Cont stack):stack, n+1)
krivine1 (Cont stack1, s:_, n) = (s, stack1, n+1)

krivine1 (t@(Lambda _ _), (s:stack), n) = (beta t s, stack, n+1)
krivine1 (App a b, stack, n)            = (a, b:stack, n+1)

krivine1 (Clock, (s:stack), n) = (s, (Instr (n+1):stack), n+1)

krivine1 a = a

krivine2 :: (Term, [Term], Integer) -> [(Term, [Term], Integer)]
krivine2 a
   | eval == a = []
   | otherwise = eval : krivine2 eval 
       where eval = krivine1 a

krivine3 :: Term -> [(Term, [Term])]
krivine3 a = (alphaeq, []) : map pair (krivine2 (alphaeq, [], 0))
  where alphaeq = alpha a
        pair = \(a,b,c) -> (a,b)

krivine :: Either a Term -> Either String [(Term, [Term])]
krivine (Left _)  = Left "Parsing Error"
krivine (Right k) = Right $ krivine3 k
