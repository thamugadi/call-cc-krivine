module Krivine where
import Lambda
import Typecheck

krivine1 :: (Term, [Term]) -> Either String (Term, [Term])
krivine1 a
  | not $ typecheck a = Left "Type Error" --Typechecking to be implemented.
krivine1 (Var x, t) = Right (Var x, t)

krivine1 (Lambda x ty t, []) = Right (Lambda x ty t, [])
krivine1 (Lambda x ty t, (s:stack)) = Right (beta x s t, stack)

krivine1 (Apply CC f, stack) = Right (f, (Cont stack):stack)
krivine1 (Cont stack1, s:stack2) = Right (s, stack1)

krivine1 (Apply a b, stack) = Right (a, b:stack)

krivine1 _ = Left "Error"
--krivine1 (a,b) = Right (a,b) -- for debug

krivine_ :: (Term, [Term]) -> [Either String (Term, [Term])]
krivine_ a
  | (krivine1 a) == Right a = pure $ Right a
  | otherwise = krivine1 a : [(krivine1 a) >>= (\x -> last $ krivine_ x)]

krivine__ :: Term -> Either String [(Term, [Term])]
krivine__ a = sequence $ (Right (a, [])) : krivine_ (a, [])

krivine :: Either a Term -> Either String [(Term, [Term])]
krivine (Left _) = Left "Parsing Error"
krivine (Right k) = krivine__ k
