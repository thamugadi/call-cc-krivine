module Krivine where
import Lambda
import Data.List (find)

type Context = [(String, Term)]
type KMachine = (State, Context)

krivine1 :: KMachine -> KMachine
krivine1 ((Var "call/cc", (f:stack), n),c) = ((f, (Cont stack):stack, n+1),c)
krivine1 ((Cont stack1, s:_, n),c) = ((s, stack1, n+1),c)
krivine1 ((Var "clock", (s:stack), n),c) = ((s, (Instr (n+1):stack), n+1),c)
krivine1 ((t@(Lambda _ _), (s:stack), n),c) = ((beta t s, stack, n+1),c)
krivine1 ((App a b, stack, n),c)            = ((a, b:stack, n+1),c)

krivine1 ((Var "define", (Var a:b:x:s), n), c) = ((x, s, n+1), (a, b):c)
krivine1 ((v@(Var "define"), (Var a:b:[]), n), c) = ((v, [], n+1), (a, b):c)

krivine1 ((t@(Var a), stack, n), context) = 
  ((maybe t snd $ find ((==a) . fst) context, stack, n), context)

krivine1 a = a

krivine2 :: KMachine -> [KMachine]
krivine2 a
  | eval == a = []
  | otherwise = eval : krivine2 eval 
      where eval = krivine1 a

krivine3 :: Term -> Context -> [KMachine]
krivine3 a c = ((alphaeq, [], 0), c) : (krivine2 ((alphaeq, [], 0), c)) 
  where alphaeq = alpha a

krivine :: Either a Term -> Context -> Either String [KMachine]
krivine (Left _) _ = Left "Parsing Error" 
krivine (Right k) initContext = Right $ krivine3 k initContext

--runKrivine :: String -> Context -> Either String [KMachine]
--runKrivine s initContext = krivine (runParser parseTerm "" s) initContext

--runMKrivine1 :: [String] -> Context -> [Either String [KMachine]]
--runMKrivine1 [] _ = []
--runMKrivine1 (x:xs) c =
--  case runKrivine x c of
--    Left a -> [Left a]
--    Right machine -> (Right machine) : runMKrivine1 xs (snd $ last machine)

--runMKrivine :: [String] -> Context -> Either String [KMachine]
--runMKrivine s c = case (concat $ concat $ sequence $ runMKrivine1 s c) of
--  [] -> Left "Parsing Error"
--  xs -> Right xs

