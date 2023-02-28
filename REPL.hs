module REPL where

import Krivine
import Show
import Data.Maybe (listToMaybe)
import System.Environment (getArgs)

cmd :: IO ()
cmd = do  
  args <- getArgs  
  case listToMaybe args of  
    Nothing -> putStrLn "Usage: runghc Main.hs \"<expression>\""  
    Just a  -> putStr $ showKrivine $ runKrivine a []  

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
