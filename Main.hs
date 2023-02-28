import Interpreter 
import Data.Maybe (listToMaybe)
import System.Environment (getArgs)

main :: IO ()
main = do
  args <- getArgs
  case listToMaybe args of
    Nothing -> repl []
    Just a  -> cmd args 
