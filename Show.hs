module Show where
import Lambda
import Data.List (intercalate)

rnas1 :: String -> Bool -> String
rnas1 [] _      = []
rnas1 (';':s) _ = rnas1 s True
rnas1 (' ':s) _ = ' ' : (rnas1 s False)
rnas1 ('.':s) _ = '.' : (rnas1 s False)
rnas1 (a:s) b
  | elem a ['0'..'9'] && b = rnas1 s b
  | otherwise              = a : (rnas1 s b)

rnas :: String -> String
rnas s = rnas1 s False

t2str :: Term -> String
t2str (Var a)      = a
t2str (Lambda x e) = "λ"++(t2str x)++"."++(t2str e)
t2str (App a b)    = "("++(t2str a)++" "++(t2str b)++")"
t2str (CC)         = "call/cc"
t2str (Cont c)     = "continuation " ++ show c
t2str (Clock)      = "clock"
t2str (Instr n)    = "instr n°" ++ show n

s2str :: [Term] -> String -> String
s2str s i = intercalate i (map t2str s)

showKrivine :: Either String [(Term, [Term])] -> String
showKrivine (Left s)   = s++"\n"
showKrivine (Right []) = ""

showKrivine (Right [(t@(Var x), s@(a:as))]) =
  (t2str t)++" *** "++ "[" ++ (s2str s ", ")++"]\nnot evaluated.\n"

showKrivine (Right ((t,s):kr)) =
  (t2str t)++" *** " ++ "["++ (s2str s ", ")++"]\n" ++ (showKrivine (Right kr))
