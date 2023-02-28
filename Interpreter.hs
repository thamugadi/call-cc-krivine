module Interpreter where

import Krivine
import Show
import Text.Megaparsec (runParser)
import Parser (parseTerm)

runKrivine :: String -> Context -> Either String [KMachine]
runKrivine s initContext = krivine (runParser parseTerm "" s) initContext

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
