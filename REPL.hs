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
