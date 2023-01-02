{-# LANGUAGE GADTs #-}
module Lambda where

data Type where
  Base   :: String -> Type
  App    :: Type -> Type -> Type deriving (Eq, Show)
data Term where
  Var    :: String -> Term
  Lambda :: Term -> Type -> Term -> Term
  Apply  :: Term -> Term -> Term 
  CC     :: Term
  Cont   :: [Term] -> Term deriving (Eq, Show)

beta :: Term -> Term -> Term -> Term 
beta a b (Var t) 
  | (Var t) == a = b
  | otherwise = Var t
beta a b (Lambda x ty t) = Lambda x ty (beta a b t)
beta a b (Apply t u) = Apply (beta a b t) (beta a b u)

initType :: Type -> Type
initType (App t1 t2) =
  case t2 of
    (Base _) -> t1  
    _        -> App t1 (initType t2) 

composeTypeCheck :: Type -> Type -> Bool 
composeTypeCheck (Base a) _ = False
composeTypeCheck a b
  | a == initType b = True
  | otherwise = False
