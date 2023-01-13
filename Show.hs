module Show where
import Lambda
import Data.List (intercalate)

rnas :: String -> String
rnas s = [x | x <- s, x /= ';' && ((not (elem x ['0'..'9'])) || x == ' ')]

t2str :: Term -> String
t2str (Var a) = a
t2str (Lambda x e) = "(λ"++(t2str x)++"."++(t2str e)++")"
t2str (Apply a b) = "("++(t2str a)++" "++(t2str b)++")"
t2str (CC) = "call/cc"
t2str (Cont c) = "continuation " ++ show c

showKrivine :: Either String [(Term, [Term])] -> String
showKrivine (Left s) = s++"\n"
showKrivine (Right []) = ""
showKrivine (Right [(t@(Var x), s@([a]))]) =
    (t2str t)++" *** "++
    "["++
    intercalate ", " (map t2str s)++"]"++ " not evaluated!\n"
showKrivine (Right ((t,s):kr)) =
  (t2str t)++" *** "++
  "["++
  intercalate ", " (map t2str s)++"]\n"++
  (showKrivine (Right kr))
