module Krivine where
import Lambda

krivine1 :: (Term, [Term]) -> Either String (Term, [Term])

krivine1 (App CC f, stack) = Right (f, (Cont stack):stack)
krivine1 (Cont stack1, s:_) = Right (s, stack1)

krivine1 (Lambda x t, (s:stack)) = Right (beta x s t, stack)
krivine1 (App a b, stack) = Right (a, b:stack)

krivine1 a = Right a

krivine_ :: (Term, [Term]) -> [Either String (Term, [Term])]
krivine_ a
  | (krivine1 a) == Right a = pure $ Right a
  | otherwise = krivine1 a : [(krivine1 a) >>= (\x -> last $ krivine_ x)]

krivine__ :: Term -> Either String [(Term, [Term])]
krivine__ a = sequence $ (Right (alphaeq, [])) : krivine_ (alphaeq, [])
  where alphaeq = alpha a

krivine :: Either a Term -> Either String [(Term, [Term])]
krivine (Left _) = Left "Parsing Error"
krivine (Right k) = krivine__ k
