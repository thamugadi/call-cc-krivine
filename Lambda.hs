{-# LANGUAGE GADTs #-}
module Lambda where
import Data.List (find)

data Term where
  Var    :: String -> Term
  Lambda :: Term -> Term -> Term
  App    :: Term -> Term -> Term 
  CC     :: Term
  Cont   :: [Term] -> Term 
  Clock  :: Term
  Instr  :: Integer -> Term deriving (Eq, Show)

alpha1 :: Int -> [(String, Int)] -> Term -> Term

alpha1 n bound term@(Var name) =
  maybe term (\x -> Var $ name ++ ";" ++ (show $ snd $ x)) p 
    where p = find (\(s,i) -> s == name) bound

alpha1 n bound (Lambda (Var x) t) = Lambda (Var $ x++";"++(show n)) (alpha1 (n+1) ((x,n):bound) t)
alpha1 n bound (App a b)          = App (alpha1 n bound a) (alpha1 n bound b)
alpha1 _ _ a                      = a

alpha :: Term -> Term
alpha = alpha1 0 []

beta1 :: Term -> Term -> Term -> Term 
beta1 a b (Var t) 
  | (Var t) == a = b
  | otherwise    = Var t
beta1 a b (Lambda x t) = Lambda x $ beta1 a b t
beta1 a b (App t u)    = App (beta1 a b t) (beta1 a b u)
beta1 a b t            = t

beta :: Term -> Term -> Term
beta (Lambda x t) s = beta1 x s t
beta a _            = a

mulLambda :: [Term] -> Term -> Term 
mulLambda args t = foldr Lambda t args

mulApp :: [Term] -> Term
mulApp = foldl1 App
