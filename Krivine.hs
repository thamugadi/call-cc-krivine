module Krivine where
import Lambda

krivine1 :: (Term, [Term]) -> (Term, [Term])

krivine1 (App CC f, stack) = (f, (Cont stack):stack)
krivine1 (Cont stack1, s:_) = (s, stack1)

krivine1 (t@(Lambda _ _), (s:stack)) = (beta t s, stack)
krivine1 (App a b, stack) = (a, b:stack)

krivine1 a = a

krivine2 :: (Term, [Term]) -> [(Term, [Term])]
krivine2 a
   | krivine1 a == a = [a]
   | otherwise = eval : krivine2 eval 
       where eval = krivine1 a

krivine3 :: Term -> [(Term, [Term])]
krivine3 a = (alphaeq, []) : krivine2 (alphaeq, [])
  where alphaeq = alpha a

krivine :: Either a Term -> Either String [(Term, [Term])]
krivine (Left _)  = Left "Parsing Error"
krivine (Right k) = Right $ krivine3 k
