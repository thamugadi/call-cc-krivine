module Krivine where
import Lambda

krivine1 :: State -> State

krivine1 (CC, (f:stack), n) = (f, (Cont stack):stack, n+1)
krivine1 (Cont stack1, s:_, n) = (s, stack1, n+1)

krivine1 (Clock, (s:stack), n) = (s, (Instr (n+1):stack), n+1)

krivine1 (t@(Lambda _ _), (s:stack), n) = (beta t s, stack, n+1)
krivine1 (App a b, stack, n)            = (a, b:stack, n+1)

krivine1 a = a

krivine2 :: State -> [State]
krivine2 a
   | eval == a = []
   | otherwise = eval : krivine2 eval 
       where eval = krivine1 a

krivine3 :: Term -> [State]
krivine3 a = (alphaeq, [], 0) : (krivine2 (alphaeq, [], 0))
  where alphaeq = alpha a

krivine :: Either a Term -> Either String [State]
krivine (Left _)  = Left "Parsing Error"
krivine (Right k) = Right $ krivine3 k
