{-# LANGUAGE GADTs #-}
module Lambda where

data Term where
  Var    :: String -> Term
  Lambda :: Term -> Term -> Term
  Apply  :: Term -> Term -> Term 
  CC     :: Term
  Cont   :: [Term] -> Term deriving (Eq, Show)

beta :: Term -> Term -> Term -> Term 
beta a b (Var t) 
  | (Var t) == a = b
  | otherwise = Var t
beta a b (Lambda x t) = Lambda x $ beta a b t
beta a b (Apply t u) = Apply (beta a b t) (beta a b u)
beta _ b _ = b
