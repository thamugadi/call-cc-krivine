module Krivine where
import Lambda

krivine1 :: (Term, [Term]) -> Either String (Term, [Term])

krivine1 (App CC f, stack) = Right (f, (Cont stack):stack)
krivine1 (Cont stack1, s:_) = Right (s, stack1)

krivine1 (t@(Lambda _ _), (s:stack)) = Right (beta t s, stack)
krivine1 (App a b, stack) = Right (a, b:stack)

krivine1 a = Right a

krivine2 :: (Term, [Term]) -> [Either String (Term, [Term])]
krivine2 a
  | (krivine1 a) == Right a = pure $ Right a
  | otherwise = krivine1 a : [(krivine1 a) >>= (\x -> last $ krivine2 x)]

krivine3 :: Term -> Either String [(Term, [Term])]
krivine3 a = sequence $ (Right (alphaeq, [])) : krivine2 (alphaeq, [])
  where alphaeq = alpha a

krivine :: Either a Term -> Either String [(Term, [Term])]
krivine (Left _) = Left "Parsing Error"
krivine (Right k) = krivine3 k
