module Show where
import Lambda
import Data.List (intercalate)

rnas_ :: String -> Bool -> String
rnas_ [] _ = []
rnas_ (';':s) _ = rnas_ s True
rnas_ (' ':s) _ = ' ' : (rnas_ s False)
rnas_ (a:s) b
  | elem a ['0'..'9'] && b = rnas_ s b
  | otherwise = a : (rnas_ s b)

rnas :: String -> String
rnas s = rnas_ s False

t2str :: Term -> String
t2str (Var a) = a
t2str (Lambda x e) = "λ"++(t2str x)++"."++(t2str e)
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
