{-# LANGUAGE GADTs #-}
module Lambda where
import Data.List (find)
data Term where
  Var    :: String -> Term
  Lambda :: Term -> Term -> Term
  Apply  :: Term -> Term -> Term 
  CC     :: Term
  Cont   :: [Term] -> Term deriving (Eq, Show)

alpha1 :: Int -> [(String, Int)] -> Term -> Term
alpha1 n bound (Var t)
  | p /= Nothing = Var $ t ++ ";" ++ (show $ snd $ (\(Just a) -> a) p)
  | otherwise = Var t where p = (find (\(s,i) -> s == t) bound)
alpha1 n bound (Lambda (Var x) t) = Lambda (Var $ x++";"++(show n)) (alpha1 (n+1) ((x,n):bound) t)
alpha1 n bound (Apply a b) = Apply (alpha1 n bound a) (alpha1 n bound b)
alpha1 _ _ a = a

alpha :: Term -> Term
alpha = alpha1 0 []

beta :: Term -> Term -> Term -> Term 
beta a b (Var t) 
  | (Var t) == a = b
  | otherwise = Var t
beta a b (Lambda x t) = Lambda x $ beta a b t
beta a b (Apply t u) = Apply (beta a b t) (beta a b u)
beta _ b _ = b
