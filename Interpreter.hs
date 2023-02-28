module Interpreter where

import Krivine
import Show
import Text.Megaparsec (runParser)
import Parser (parseTerm)

runKrivine1 :: String -> Context -> Either String [KMachine]
runKrivine1 s initContext = krivine (runParser parseTerm "" s) initContext

runMKrivine1 :: [String] -> Context -> [Either String [KMachine]]
runMKrivine1 [] _ = []
runMKrivine1 (x:xs) c =
  case runKrivine1 x c of
    Left a -> [Left a]
    Right machine -> (Right machine) : runMKrivine1 xs (snd $ last machine)

runMKrivine :: [String] -> Context -> Either String [KMachine]
runMKrivine s c = case (concat $ concat $ sequence $ runMKrivine1 s c) of
  [] -> Left "Parsing Error"
  xs -> Right xs

runKrivine :: String -> Context -> Either String [KMachine]
runKrivine s initContext = runMKrivine (divide s) initContext

cmd :: [String] -> IO ()
cmd args = putStr $ showKrivine $ runKrivine (head args) []  

repl :: Context -> IO ()
repl context = do
  x <- getLine
  let k = runKrivine x context
  putStr $ showKrivine k
  case k of
    Left b  -> repl $ context
    Right a -> repl $ snd $ last a

lreq1 :: String -> Int -> Int -> Int -> [Int]
lreq1 "" _ _ _ = []
lreq1 (x:xs) i 0 0
  | x=='(' = lreq1 xs (i+1) 1 0
  | x==')' = lreq1 xs (i+1) 0 1
  | otherwise = lreq1 xs (i+1) 0 0
lreq1 (x:xs) i l r
  | l==r = i : lreq1 xs 0 0 0
  | l/=r && x=='(' = lreq1 xs (i+1) (l+1) r
  | l/=r && x==')' = lreq1 xs (i+1) l (r+1)
  | otherwise = lreq1 xs (i+1) l r

lreq :: String -> [Int]
lreq x = lreq1 x 0 0 0

divide1 :: String -> [Int] -> [String]
divide1 s [] = [s]
divide1 s (i:is) = fst spl : divide1 (snd spl) is where spl = splitAt i s

divide :: String -> [String]
divide s = divide1 s $ lreq s
