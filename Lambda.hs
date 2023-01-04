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
beta a b (Lambda x ty t) = Lambda x ty $ beta a b t
beta a b (Apply t u) = Apply (beta a b t) (beta a b u)

initType :: Type -> Maybe Type
initType (Base _) = Nothing 
initType (App t1 (Base _)) = Just t1
initType (App t1 t2) = (initType t2) >>= (\x -> Just $ App t1 x)

tailType :: Type -> Maybe Type
tailType (Base _) = Nothing 
tailType (App (Base _) t2) = Just t2
tailType (App t1 t2) = (tailType t1) >>= (\x -> Just $ App x t2)
