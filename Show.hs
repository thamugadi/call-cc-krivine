module Show where
import Lambda
import Data.List (intercalate)
import Krivine

removeTags1 :: String -> Bool -> String
removeTags1 [] _      = []
removeTags1 (';':s) _ = removeTags1 s True
removeTags1 (' ':s) _ = ' ' : (removeTags1 s False)
removeTags1 ('.':s) _ = '.' : (removeTags1 s False)
removeTags1 (a:s) b
  | elem a ['0'..'9'] && b = removeTags1 s b
  | otherwise              = a : (removeTags1 s b)

removeTags :: String -> String
removeTags s = removeTags1 s False

t2str :: Term -> String
t2str (Var a)      = a
t2str (Lambda x e) = "λ"++(t2str x)++"."++(t2str e)
t2str (App a b)    = "("++(t2str a)++" "++(t2str b)++")"
t2str (Cont c)     = "continuation " ++ show (map t2str c)
t2str (Instr n)    = "instr n°" ++ show n

s2str :: [Term] -> String -> String
s2str s i = intercalate i (map t2str s)

showKrivine1 :: Either String [KMachine] -> String
showKrivine1 (Left s)   = s++"\n"
showKrivine1 (Right []) = ""

showKrivine1 (Right [((t@(Var x), s@(a:as), n),c)]) =
  (t2str t)++" *** "++ "[" ++ (s2str s ", ")++"]\nnot evaluated.\n"

showKrivine1 (Right (((t,s,n),c):kr)) =
  (t2str t)++" *** " ++ "["++ (s2str s ", ")++"]\n" ++ (showKrivine1 (Right kr))

showKrivine :: Either String [KMachine] -> String
showKrivine s@(Left _) = showKrivine1 s
showKrivine a = removeTags $ showKrivine1 a
